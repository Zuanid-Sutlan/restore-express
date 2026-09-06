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
    adminService: AdminService,
    settingsService: SettingsService = SettingsService(),
    versionService: VersionService = VersionService()
) {
    routing {
        staticResources("/static", "static")

        swaggerUI(path = "swagger", swaggerFile = "openapi/documentation.yaml")
        openAPI(path = "openapi", swaggerFile = "openapi/documentation.yaml")

        get("/api/health") {
            val v = versionService.getVersionInfo()
            call.respond(mapOf(
                "status" to "OK",
                "environment" to v.environment,
                "version" to v.version,
                "fullVersionTag" to v.fullVersionTag
            ))
        }

        get("/api/version") {
            call.respond(versionService.getVersionInfo())
        }

        get("/favicon.ico") {
            call.respondRedirect("/static/images/logo-icon.png")
        }

        staticPageRoutes(settingsService, versionService)
        repairRoutes(repairService)
        shopRoutes(shopService)
        webhookRoutes(stripeService)
        adminRoutes(adminService, shopService, repairService, settingsService, versionService)
    }
}
