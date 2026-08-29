package com.restoreexpress

import com.restoreexpress.models.*
import com.restoreexpress.routes.configureRouting
import com.restoreexpress.services.AdminService
import com.restoreexpress.services.RepairService
import com.restoreexpress.services.ShopService
import com.restoreexpress.services.StripeService
import com.restoreexpress.services.SettingsService
import com.restoreexpress.services.VersionService
import io.ktor.client.plugins.cookies.*
import io.ktor.client.request.*
import io.ktor.client.statement.*
import io.ktor.http.*
import io.ktor.serialization.kotlinx.json.*
import io.ktor.server.application.*
import io.ktor.server.plugins.contentnegotiation.*
import io.ktor.server.auth.*
import io.ktor.server.response.*
import io.ktor.server.testing.*
import io.ktor.server.sessions.*
import io.ktor.server.freemarker.*
import freemarker.cache.StringTemplateLoader
import freemarker.cache.FileTemplateLoader
import java.io.File
import org.mindrot.jbcrypt.BCrypt
import java.time.LocalDateTime
import kotlin.test.*

class ApiTests {

    private val sampleProduct = Product(
        1, "Apple", "iPhone 13", "iphone-13", 59900, 10, ProductCondition.NEW
    )

    private val sampleOrder = Order(
        1, "ORD-1001", "John Customer", "customer@example.com", "123456789",
        "123 High St", null, "London", "SW1A 1AA", "UK",
        OrderStatus.PENDING, 59900, 500, 60400, "pi_test", null,
        LocalDateTime.now(), LocalDateTime.now()
    )

    private val sampleRepair = Repair(
        1, "RE-2026-1234", "Jane Doe", "jane@example.com", "987654321",
        "iPhone 14 Pro", "123456789012345", "Broken glass screen", null,
        RepairStatus.RECEIVED, 12000, 0, 12000, null,
        LocalDateTime.now(), LocalDateTime.now()
    )

    class FakeSettingsService : SettingsService() {
        override suspend fun getSettings(): SiteSettingsData = SiteSettingsData()
        override suspend fun updateSettings(data: SiteSettingsData): Boolean = true
    }

    // Fake Services for Testing
    class FakeAdminService(private val validHash: String) : AdminService() {
        override suspend fun authenticate(email: String, password: String): Admin? {
            return if (email == "admin@restoreexpress.com" && BCrypt.checkpw(password, validHash)) {
                Admin(1, email, validHash)
            } else {
                null
            }
        }

        override suspend fun getDashboardStats(shopService: ShopService, repairService: RepairService): DashboardStats {
            return DashboardStats(
                totalProducts = 1, activeProducts = 1,
                totalOrders = 1, pendingOrders = 1,
                totalRepairs = 1, activeRepairs = 1,
                recentOrders = shopService.getAllOrders(),
                recentRepairs = repairService.getAllRepairs()
            )
        }
    }

    class FakeShopService(
        private val product: Product,
        private val order: Order
    ) : ShopService() {
        override suspend fun getAllActiveProducts(): List<Product> = listOf(product)
        override suspend fun getAllProducts(): List<Product> = listOf(product)
        override suspend fun getProductById(id: Int): Product? = if (id == product.id) product else null
        override suspend fun getProductImages(productId: Int): List<ProductImage> = emptyList()
        override suspend fun addProductImage(productId: Int, url: String, sortOrder: Int): Int = 1
        override suspend fun deleteProductImage(imageId: Int): Boolean = true
        override suspend fun deleteProduct(productId: Int): Boolean = true
        override suspend fun createProduct(
            brand: String, modelName: String, slug: String, description: String?,
            condition: ProductCondition, storageVariant: String?, color: String?,
            pricePence: Int, stockQuantity: Int, isActive: Boolean
        ): Int = 2
        override suspend fun updateProduct(
            id: Int, brand: String, modelName: String, slug: String, description: String?,
            condition: ProductCondition, storageVariant: String?, color: String?,
            pricePence: Int, stockQuantity: Int, isActive: Boolean
        ): Boolean = true
        override suspend fun toggleProductActive(id: Int): Boolean = true
        override suspend fun getAllOrders(statusFilter: OrderStatus?): List<Order> = listOf(order)
        override suspend fun getOrderById(id: Int): DetailedOrder? =
            if (id == order.id) DetailedOrder(order, listOf(OrderItemDetail(1, 1, "Apple", "iPhone 13", 1, 59900))) else null
        override suspend fun updateOrderStatus(id: Int, status: OrderStatus, trackingNumber: String?): Boolean = true
    }

    class FakeRepairService(
        private val repair: Repair
    ) : RepairService() {
        override suspend fun createRepair(
            customerName: String, email: String, phone: String, 
            deviceModel: String, reportedFault: String, pricePence: Int
        ): String = "RE-2026-1234"
        override suspend fun getAllRepairs(statusFilter: RepairStatus?): List<Repair> = listOf(repair)
        override suspend fun getRepairById(id: Int): DetailedRepair? =
            if (id == repair.id) DetailedRepair(repair, emptyList()) else null
        override suspend fun updateRepairStatus(id: Int, status: RepairStatus, note: String?): Boolean = true
    }

    @Test
    fun testAdminLoginSuccess() = testApplication {
        val validHash = "\$2a\$10\$MrwodC4t4RKqQus5ouholO8S9wNkQApe7c0TsUxCngQTzPgEJJggS"
        application {
            setupTestModule(validHash)
        }
        val response = client.post("/admin/login") {
            setBody(Parameters.build {
                append("email", "admin@restoreexpress.com")
                append("password", "admin123")
            }.formUrlEncode())
            header(HttpHeaders.ContentType, ContentType.Application.FormUrlEncoded.toString())
        }
        assertEquals(HttpStatusCode.Found, response.status)
        assertEquals("/admin/dashboard", response.headers[HttpHeaders.Location])
    }

    @Test
    fun testAdminLoginFailure() = testApplication {
        val validHash = "\$2a\$10\$MrwodC4t4RKqQus5ouholO8S9wNkQApe7c0TsUxCngQTzPgEJJggS"
        application {
            setupTestModule(validHash)
        }
        val response = client.post("/admin/login") {
            setBody(Parameters.build {
                append("email", "admin@restoreexpress.com")
                append("password", "wrongpassword")
            }.formUrlEncode())
            header(HttpHeaders.ContentType, ContentType.Application.FormUrlEncoded.toString())
        }
        assertEquals(HttpStatusCode.Found, response.status)
        assertTrue(response.headers[HttpHeaders.Location]?.contains("error=invalid") == true)
    }

    @Test
    fun testGetShop() = testApplication {
        application {
            setupTestModule("")
        }
        val response = client.get("/shop")
        assertEquals(HttpStatusCode.OK, response.status)
        assertTrue(response.bodyAsText().contains("iPhone 13"))
    }

    @Test
    fun testPostRepairBook() = testApplication {
        application {
            setupTestModule("")
        }
        val response = client.post("/repair/book") {
            setBody(Parameters.build {
                append("customer_name", "John Doe")
                append("email", "john@example.com")
                append("phone", "123456789")
                append("device_model", "iPhone 15")
                append("reported_fault", "Cracked screen")
            }.formUrlEncode())
            header(HttpHeaders.ContentType, ContentType.Application.FormUrlEncoded.toString())
        }
        assertEquals(HttpStatusCode.Found, response.status)
        assertTrue(response.headers[HttpHeaders.Location]?.contains("ref=RE-2026-1234") == true)
    }

    @Test
    fun testVersionAndHealthEndpoints() = testApplication {
        application {
            setupTestModule("")
        }
        val healthRes = client.get("/api/health")
        assertEquals(HttpStatusCode.OK, healthRes.status)
        assertTrue(healthRes.bodyAsText().contains("environment"))

        val versionRes = client.get("/api/version")
        assertEquals(HttpStatusCode.OK, versionRes.status)
        assertTrue(versionRes.bodyAsText().contains("fullVersionTag"))
    }

    @Test
    fun testAdminAuthenticatedRoutes() = testApplication {
        val validHash = "\$2a\$10\$MrwodC4t4RKqQus5ouholO8S9wNkQApe7c0TsUxCngQTzPgEJJggS"
        val testClient = createClient {
            install(HttpCookies)
        }
        application {
            setupTestModule(validHash)
        }

        // 1. Authenticate
        val loginRes = testClient.post("/admin/login") {
            setBody(Parameters.build {
                append("email", "admin@restoreexpress.com")
                append("password", "admin123")
            }.formUrlEncode())
            header(HttpHeaders.ContentType, ContentType.Application.FormUrlEncoded.toString())
        }
        assertEquals(HttpStatusCode.Found, loginRes.status)

        // 2. Dashboard
        val dashRes = testClient.get("/admin/dashboard")
        assertEquals(HttpStatusCode.OK, dashRes.status)
        assertTrue(dashRes.bodyAsText().contains("Admin Dashboard"))

        // 3. Products List & Form
        val prodListRes = testClient.get("/admin/products")
        assertEquals(HttpStatusCode.OK, prodListRes.status)
        assertTrue(prodListRes.bodyAsText().contains("Products List"))

        val prodNewRes = testClient.get("/admin/products/new")
        assertEquals(HttpStatusCode.OK, prodNewRes.status)
        assertTrue(prodNewRes.bodyAsText().contains("Product Form"))

        // 4. Product Deletion
        val deleteProdRes = testClient.post("/admin/products/1/delete")
        assertEquals(HttpStatusCode.Found, deleteProdRes.status)
        assertTrue(deleteProdRes.headers[HttpHeaders.Location]?.contains("msg=deleted") == true)

        // 5. Image Deletion
        val deleteImgRes = testClient.post("/admin/products/1/images/1/delete")
        assertEquals(HttpStatusCode.Found, deleteImgRes.status)
        assertTrue(deleteImgRes.headers[HttpHeaders.Location]?.contains("msg=img_deleted") == true)

        // 6. Settings Page
        val settingsRes = testClient.get("/admin/settings")
        assertEquals(HttpStatusCode.OK, settingsRes.status)
        assertTrue(settingsRes.bodyAsText().contains("Admin Settings"))

        // 7. Orders List & Detail
        val ordersListRes = testClient.get("/admin/orders")
        assertEquals(HttpStatusCode.OK, ordersListRes.status)
        assertTrue(ordersListRes.bodyAsText().contains("Orders List"))

        val orderDetailRes = testClient.get("/admin/orders/1")
        assertEquals(HttpStatusCode.OK, orderDetailRes.status)
        assertTrue(orderDetailRes.bodyAsText().contains("Order Detail"))

        // 8. Repairs List & Detail
        val repairsListRes = testClient.get("/admin/repairs")
        assertEquals(HttpStatusCode.OK, repairsListRes.status)
        assertTrue(repairsListRes.bodyAsText().contains("Repairs List"))

        val repairDetailRes = testClient.get("/admin/repairs/1")
        assertEquals(HttpStatusCode.OK, repairDetailRes.status)
        assertTrue(repairDetailRes.bodyAsText().contains("Repair Detail"))
    }

    @Test
    fun testBCryptVerificationLogic() {
        val password = "admin123"
        val hash = "\$2a\$10\$MrwodC4t4RKqQus5ouholO8S9wNkQApe7c0TsUxCngQTzPgEJJggS"
        assertTrue(BCrypt.checkpw(password, hash), "Hash should match password")
        assertFalse(BCrypt.checkpw("wrong", hash), "Hash should not match wrong password")
    }

    @Test
    fun testRealTemplatesRendering() = testApplication {
        val validHash = "\$2a\$10\$MrwodC4t4RKqQus5ouholO8S9wNkQApe7c0TsUxCngQTzPgEJJggS"
        val testClient = createClient {
            install(HttpCookies)
        }
        application {
            install(ContentNegotiation) { json() }
            install(Sessions) {
                cookie<AdminSession>("ADMIN_SESSION") {
                    cookie.path = "/"
                }
            }
            install(Authentication) {
                session<AdminSession>("auth-session") {
                    validate { session -> session }
                    challenge {
                        call.respondRedirect("/admin/login")
                    }
                }
            }
            install(FreeMarker) {
                templateLoader = FileTemplateLoader(File("src/main/kotlin/com/restoreexpress/templates"))
            }
            configureRouting(
                shopService = FakeShopService(sampleProduct, sampleOrder),
                repairService = FakeRepairService(sampleRepair),
                stripeService = StripeService(),
                adminService = FakeAdminService(validHash),
                settingsService = FakeSettingsService(),
                versionService = VersionService()
            )
        }

        // Authenticate as Admin
        val loginRes = testClient.post("/admin/login") {
            setBody(Parameters.build {
                append("email", "admin@restoreexpress.com")
                append("password", "admin123")
            }.formUrlEncode())
            header(HttpHeaders.ContentType, ContentType.Application.FormUrlEncoded.toString())
        }
        assertEquals(HttpStatusCode.Found, loginRes.status)

        // Test real admin dashboard template rendering (tests versionInfo.isProduction and admin_layout.ftl)
        val dashRes = testClient.get("/admin/dashboard")
        assertEquals(HttpStatusCode.OK, dashRes.status)
        assertTrue(dashRes.bodyAsText().contains("Dashboard Overview"))

        // Test real home page template rendering (tests footer.ftl and layout.ftl with settings)
        val homeRes = testClient.get("/")
        assertEquals(HttpStatusCode.OK, homeRes.status)
        assertTrue(homeRes.bodyAsText().contains("Restore"))

        // Test shop page rendering where settings is omitted (tests default settings parameter handling)
        val shopRes = testClient.get("/shop")
        assertEquals(HttpStatusCode.OK, shopRes.status)
        assertTrue(shopRes.bodyAsText().contains("Shop"))
    }

    private fun Application.setupTestModule(validHash: String) {
        install(ContentNegotiation) { json() }
        install(Sessions) {
            cookie<AdminSession>("ADMIN_SESSION") {
                cookie.path = "/"
            }
        }
        install(Authentication) {
            session<AdminSession>("auth-session") {
                validate { session -> session }
                challenge {
                    call.respondRedirect("/admin/login")
                }
            }
        }
        install(FreeMarker) {
            templateLoader = StringTemplateLoader().apply {
                putTemplate("admin/login.ftl", "Login Page \${error!}")
                putTemplate("admin/dashboard.ftl", "Admin Dashboard")
                putTemplate("admin/products/list.ftl", "Products List")
                putTemplate("admin/products/form.ftl", "Product Form")
                putTemplate("admin/settings.ftl", "Admin Settings")
                putTemplate("admin/orders/list.ftl", "Orders List")
                putTemplate("admin/orders/detail.ftl", "Order Detail")
                putTemplate("admin/repairs/list.ftl", "Repairs List")
                putTemplate("admin/repairs/detail.ftl", "Repair Detail")
                putTemplate("shop.ftl", "Shop: <#list products as p>\${p.modelName}</#list>")
                putTemplate("repair_booking.ftl", "Repair Booking")
            }
        }
        configureRouting(
            shopService = FakeShopService(sampleProduct, sampleOrder),
            repairService = FakeRepairService(sampleRepair),
            stripeService = StripeService(),
            adminService = FakeAdminService(validHash),
            settingsService = FakeSettingsService(),
            versionService = VersionService()
        )
    }
}
