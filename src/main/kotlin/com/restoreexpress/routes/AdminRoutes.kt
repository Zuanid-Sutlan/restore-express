package com.restoreexpress.routes

import io.ktor.http.content.*
import io.ktor.server.application.*
import io.ktor.server.auth.*
import io.ktor.server.freemarker.*
import io.ktor.server.request.*
import io.ktor.server.response.*
import io.ktor.server.routing.*
import io.ktor.server.sessions.*
import com.restoreexpress.services.*
import com.restoreexpress.models.*
import java.util.Base64

fun Route.adminRoutes(
    adminService: AdminService,
    shopService: ShopService,
    repairService: RepairService,
    settingsService: SettingsService = SettingsService(),
    versionService: VersionService = VersionService()
) {
    suspend fun ApplicationCall.respondAdmin(template: String, model: Map<String, Any?>) {
        val fullModel = model.toMutableMap()
        fullModel["versionInfo"] = versionService.getVersionInfo()
        respond(FreeMarkerContent(template, fullModel))
    }

    route("/admin") {
        get("/login") {
            val error = call.request.queryParameters["error"]
            call.respond(FreeMarkerContent("admin/login.ftl", mapOf("error" to error)))
        }

        post("/login") {
            val params = call.receiveParameters()
            val email = params["email"] ?: ""
            val password = params["password"] ?: ""

            val admin = adminService.authenticate(email, password)
            if (admin != null) {
                call.sessions.set(AdminSession(admin.id, admin.email))
                call.respondRedirect("/admin/dashboard")
            } else {
                call.respondRedirect("/admin/login?error=invalid")
            }
        }
        
        authenticate("auth-session") {
            get("/dashboard") {
                val stats = adminService.getDashboardStats(shopService, repairService)
                call.respondAdmin("admin/dashboard.ftl", mapOf("stats" to stats, "activeTab" to "dashboard"))
            }

            // Settings Management
            get("/settings") {
                val settings = settingsService.getSettings()
                val msg = call.request.queryParameters["msg"]
                call.respondAdmin("admin/settings.ftl", mapOf("settings" to settings, "msg" to msg, "activeTab" to "settings"))
            }

            post("/settings") {
                val params = call.receiveParameters()
                val waNumber = params["whatsappNumber"]?.trim() ?: ""
                val fbUrl = params["facebookUrl"]?.trim() ?: ""
                val igUrl = params["instagramUrl"]?.trim() ?: ""
                val ytUrl = params["youtubeUrl"]?.trim() ?: ""
                val twUrl = params["twitterUrl"]?.trim() ?: ""
                val phone = params["phoneNumber"]?.trim() ?: ""
                val email = params["supportEmail"]?.trim() ?: ""
                val deliveryAddress = params["deliveryAddress"]?.trim() ?: ""

                val updatedData = SiteSettingsData(
                    whatsappNumber = waNumber,
                    facebookUrl = fbUrl,
                    instagramUrl = igUrl,
                    youtubeUrl = ytUrl,
                    twitterUrl = twUrl,
                    phoneNumber = phone,
                    supportEmail = email,
                    deliveryAddress = deliveryAddress
                )

                settingsService.updateSettings(updatedData)
                call.respondRedirect("/admin/settings?msg=saved")
            }

            // Products Management
            get("/products") {
                val products = shopService.getAllProducts()
                val msg = call.request.queryParameters["msg"]
                call.respondAdmin("admin/products/list.ftl", mapOf("products" to products, "msg" to msg, "activeTab" to "products"))
            }

            get("/products/new") {
                call.respondAdmin("admin/products/form.ftl", mapOf("conditions" to ProductCondition.entries, "activeTab" to "products"))
            }

            post("/products/new") {
                val input = call.parseProductParams()
                val baseSlug = input.slug ?: input.modelName
                val slug = shopService.generateUniqueSlug(baseSlug)

                val productId = shopService.createProduct(
                    input.brand, input.modelName, slug, input.description,
                    input.condition, input.storageVariant, input.color,
                    input.pricePence, input.stockQuantity, input.isActive
                )

                for ((index, imgUrl) in input.images.withIndex()) {
                    shopService.addProductImage(productId, imgUrl, index)
                }

                call.respondRedirect("/admin/products?msg=created")
            }

            get("/products/{id}/edit") {
                val id = call.parameters["id"]?.toIntOrNull()
                val product = id?.let { shopService.getProductById(it) }
                if (product == null) {
                    call.respondRedirect("/admin/products?msg=not_found")
                } else {
                    val msg = call.request.queryParameters["msg"]
                    call.respondAdmin("admin/products/form.ftl", mapOf("product" to product, "conditions" to ProductCondition.entries, "msg" to msg, "activeTab" to "products"))
                }
            }

            post("/products/{id}/edit") {
                val id = call.parameters["id"]?.toIntOrNull() ?: return@post call.respondRedirect("/admin/products")
                val input = call.parseProductParams()
                val baseSlug = input.slug ?: input.modelName
                val slug = shopService.generateUniqueSlug(baseSlug, id)

                shopService.updateProduct(
                    id, input.brand, input.modelName, slug, input.description,
                    input.condition, input.storageVariant, input.color,
                    input.pricePence, input.stockQuantity, input.isActive
                )

                for ((index, imgUrl) in input.images.withIndex()) {
                    shopService.addProductImage(id, imgUrl, index)
                }

                call.respondRedirect("/admin/products/$id/edit?msg=updated")
            }

            post("/products/{id}/toggle-active") {
                val id = call.parameters["id"]?.toIntOrNull()
                if (id != null) {
                    shopService.toggleProductActive(id)
                }
                call.respondRedirect("/admin/products?msg=toggled")
            }

            post("/products/{id}/delete") {
                val id = call.parameters["id"]?.toIntOrNull()
                if (id != null) {
                    shopService.deleteProduct(id)
                }
                call.respondRedirect("/admin/products?msg=deleted")
            }

            post("/products/{productId}/images/{imageId}/delete") {
                val productId = call.parameters["productId"]?.toIntOrNull() ?: return@post call.respondRedirect("/admin/products")
                val imageId = call.parameters["imageId"]?.toIntOrNull()
                if (imageId != null) {
                    shopService.deleteProductImage(imageId)
                }
                call.respondRedirect("/admin/products/$productId/edit?msg=img_deleted")
            }

            // Orders Management
            get("/orders") {
                val statusStr = call.request.queryParameters["status"]
                val statusFilter = statusStr?.let { runCatching { OrderStatus.valueOf(it) }.getOrNull() }
                val orders = shopService.getAllOrders(statusFilter)
                val msg = call.request.queryParameters["msg"]
                call.respondAdmin(
                    "admin/orders/list.ftl",
                    mapOf(
                        "orders" to orders,
                        "selectedStatus" to (statusStr ?: ""),
                        "statuses" to OrderStatus.entries,
                        "msg" to msg,
                        "activeTab" to "orders"
                    )
                )
            }

            get("/orders/{id}") {
                val id = call.parameters["id"]?.toIntOrNull()
                val detailedOrder = id?.let { shopService.getOrderById(it) }
                if (detailedOrder == null) {
                    call.respondRedirect("/admin/orders?msg=not_found")
                } else {
                    val msg = call.request.queryParameters["msg"]
                    call.respondAdmin(
                        "admin/orders/detail.ftl",
                        mapOf(
                            "detailedOrder" to detailedOrder,
                            "statuses" to OrderStatus.entries,
                            "msg" to msg,
                            "activeTab" to "orders"
                        )
                    )
                }
            }

            post("/orders/{id}/status") {
                val id = call.parameters["id"]?.toIntOrNull() ?: return@post call.respondRedirect("/admin/orders")
                val params = call.receiveParameters()
                val status = OrderStatus.valueOf(params["status"] ?: "PENDING")
                val trackingNumber = params["trackingNumber"]
                shopService.updateOrderStatus(id, status, trackingNumber)
                call.respondRedirect("/admin/orders/$id?msg=updated")
            }

            // Repairs Management
            get("/repairs") {
                val statusStr = call.request.queryParameters["status"]
                val statusFilter = statusStr?.let { runCatching { RepairStatus.valueOf(it) }.getOrNull() }
                val repairs = repairService.getAllRepairs(statusFilter)
                val msg = call.request.queryParameters["msg"]
                call.respondAdmin(
                    "admin/repairs/list.ftl",
                    mapOf(
                        "repairs" to repairs,
                        "selectedStatus" to (statusStr ?: ""),
                        "statuses" to RepairStatus.entries,
                        "msg" to msg,
                        "activeTab" to "repairs"
                    )
                )
            }

            get("/repairs/{id}") {
                val id = call.parameters["id"]?.toIntOrNull()
                val detailedRepair = id?.let { repairService.getRepairById(it) }
                if (detailedRepair == null) {
                    call.respondRedirect("/admin/repairs?msg=not_found")
                } else {
                    val msg = call.request.queryParameters["msg"]
                    call.respondAdmin(
                        "admin/repairs/detail.ftl",
                        mapOf(
                            "detailedRepair" to detailedRepair,
                            "statuses" to RepairStatus.entries,
                            "msg" to msg,
                            "activeTab" to "repairs"
                        )
                    )
                }
            }

            post("/repairs/{id}/status") {
                val id = call.parameters["id"]?.toIntOrNull() ?: return@post call.respondRedirect("/admin/repairs")
                val params = call.receiveParameters()
                val status = RepairStatus.valueOf(params["status"] ?: "RECEIVED")
                val note = params["note"]
                repairService.updateRepairStatus(id, status, note)
                call.respondRedirect("/admin/repairs/$id?msg=updated")
            }
        }

        get("/logout") {
            call.sessions.clear<AdminSession>()
            call.respondRedirect("/admin/login")
        }
    }
}

private suspend fun ApplicationCall.parseProductParams(): ProductFormInput {
    var brand = ""
    var modelName = ""
    var slug: String? = null
    var description: String? = null
    var conditionStr = "REFURBISHED_A"
    var storageVariant: String? = null
    var color: String? = null
    var pricePence = 0
    var stockQuantity = 0
    var isActive = false
    val images = mutableListOf<String>()

    if (request.isMultipart()) {
        val multipart = receiveMultipart()
        multipart.forEachPart { part ->
            when (part) {
                is PartData.FormItem -> {
                    when (part.name) {
                        "brand" -> brand = part.value.trim()
                        "modelName" -> modelName = part.value.trim()
                        "slug" -> slug = part.value.trim().ifEmpty { null }
                        "description" -> description = part.value.trim().ifEmpty { null }
                        "condition" -> conditionStr = part.value
                        "storageVariant" -> storageVariant = part.value.trim().ifEmpty { null }
                        "color" -> color = part.value.trim().ifEmpty { null }
                        "price" -> {
                            val p = part.value.toDoubleOrNull()
                            if (p != null) pricePence = (p * 100).toInt()
                        }
                        "pricePence" -> if (pricePence == 0) pricePence = part.value.toIntOrNull() ?: 0
                        "stockQuantity" -> stockQuantity = part.value.toIntOrNull() ?: 0
                        "isActive" -> isActive = (part.value == "on" || part.value == "true" || part.value == "1")
                        "imageUrls" -> {
                            part.value.split(",").map { it.trim() }.filter { it.isNotEmpty() }.forEach {
                                images.add(it)
                            }
                        }
                    }
                }
                is PartData.FileItem -> {
                    @Suppress("DEPRECATION")
                    val bytes = part.streamProvider().readBytes()
                    if (bytes.isNotEmpty()) {
                        val contentType = part.contentType?.toString() ?: "image/jpeg"
                        val base64 = Base64.getEncoder().encodeToString(bytes)
                        images.add("data:$contentType;base64,$base64")
                    }
                }
                else -> {}
            }
            part.dispose()
        }
    } else {
        val params = receiveParameters()
        brand = params["brand"]?.trim() ?: ""
        modelName = params["modelName"]?.trim() ?: ""
        slug = params["slug"]?.trim()?.ifEmpty { null }
        description = params["description"]?.trim()?.ifEmpty { null }
        conditionStr = params["condition"] ?: "REFURBISHED_A"
        storageVariant = params["storageVariant"]?.trim()?.ifEmpty { null }
        color = params["color"]?.trim()?.ifEmpty { null }
        val priceVal = params["price"]?.toDoubleOrNull()
        pricePence = if (priceVal != null) (priceVal * 100).toInt() else (params["pricePence"]?.toIntOrNull() ?: 0)
        stockQuantity = params["stockQuantity"]?.toIntOrNull() ?: 0
        isActive = (params["isActive"] == "on" || params["isActive"] == "true")
        params["imageUrls"]?.split(",")?.map { it.trim() }?.filter { it.isNotEmpty() }?.forEach {
            images.add(it)
        }
    }

    val condition = runCatching { ProductCondition.valueOf(conditionStr) }.getOrDefault(ProductCondition.REFURBISHED_A)

    return ProductFormInput(
        brand, modelName, slug, description, condition, storageVariant, color, pricePence, stockQuantity, isActive, images
    )
}

private data class ProductFormInput(
    val brand: String,
    val modelName: String,
    val slug: String?,
    val description: String?,
    val condition: ProductCondition,
    val storageVariant: String?,
    val color: String?,
    val pricePence: Int,
    val stockQuantity: Int,
    val isActive: Boolean,
    val images: List<String>
)
