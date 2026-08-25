package com.restoreexpress

import com.restoreexpress.models.*
import com.restoreexpress.routes.configureRouting
import com.restoreexpress.services.AdminService
import com.restoreexpress.services.RepairService
import com.restoreexpress.services.ShopService
import com.restoreexpress.services.StripeService
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
import org.mindrot.jbcrypt.BCrypt
import kotlin.test.*

class ApiTests {

    // Fake Services for Testing
    class FakeAdminService(private val validHash: String) : AdminService() {
        override suspend fun authenticate(email: String, password: String): Admin? {
            return if (email == "admin@restoreexpress.com" && BCrypt.checkpw(password, validHash)) {
                Admin(1, email, validHash)
            } else {
                null
            }
        }
    }

    class FakeShopService : ShopService() {
        override suspend fun getAllActiveProducts(): List<Product> = listOf(
            Product(1, "Apple", "iPhone 13", "iphone-13", 59900, 10, ProductCondition.NEW)
        )
    }

    class FakeRepairService : RepairService() {
        override suspend fun createRepair(
            customerName: String, email: String, phone: String, 
            deviceModel: String, reportedFault: String, pricePence: Int
        ): String = "RE-2026-1234"
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
    fun testBCryptVerificationLogic() {
        val password = "admin123"
        val hash = "\$2a\$10\$MrwodC4t4RKqQus5ouholO8S9wNkQApe7c0TsUxCngQTzPgEJJggS"
        assertTrue(BCrypt.checkpw(password, hash), "Hash should match password")
        assertFalse(BCrypt.checkpw("wrong", hash), "Hash should not match wrong password")
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
                putTemplate("shop.ftl", "Shop: <#list products as p>\${p.modelName}</#list>")
                putTemplate("repair_booking.ftl", "Repair Booking")
            }
        }
        configureRouting(
            shopService = FakeShopService(),
            repairService = FakeRepairService(),
            stripeService = StripeService(), // Not used in these tests
            adminService = FakeAdminService(validHash)
        )
    }
}
