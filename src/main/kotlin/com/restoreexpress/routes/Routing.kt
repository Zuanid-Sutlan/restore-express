package com.restoreexpress.routes

import io.ktor.server.application.*
import io.ktor.server.http.content.*
import io.ktor.server.plugins.swagger.*
import io.ktor.server.plugins.openapi.*
import io.ktor.server.response.*
import io.ktor.server.routing.*
import com.restoreexpress.services.*

fun Application.configureRouting(
    shopService: ShopService,
    repairService: RepairService,
    stripeService: StripeService,
    adminService: AdminService
) {
    routing {
        staticResources("/static", "static")

        swaggerUI(path = "swagger", swaggerFile = "openapi/documentation.yaml")
        openAPI(path = "openapi", swaggerFile = "openapi/documentation.yaml")

        get("/api/health") {
            call.respondText("OK")
        }

        staticPageRoutes()
        repairRoutes(repairService)
        shopRoutes(shopService)
        webhookRoutes(stripeService)
        adminRoutes(adminService)
    }
}
