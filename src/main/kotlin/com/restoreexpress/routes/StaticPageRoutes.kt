package com.restoreexpress.routes

import com.restoreexpress.services.RepairService
import com.restoreexpress.services.SettingsService
import com.restoreexpress.services.ShopService
import com.restoreexpress.services.VersionService
import io.ktor.server.freemarker.*
import io.ktor.server.response.*
import io.ktor.server.routing.*

fun Route.staticPageRoutes(
    settingsService: SettingsService = SettingsService(),
    versionService: VersionService = VersionService(),
    shopService: ShopService? = null,
    repairService: RepairService? = null
) {
    suspend fun buildModel(title: String, extraMap: Map<String, Any> = emptyMap()): Map<String, Any> {
        val baseMap = mutableMapOf<String, Any>(
            "title" to title,
            "versionInfo" to versionService.getVersionInfo()
        )
        runCatching { baseMap["settings"] = settingsService.getSettings() }
        baseMap.putAll(extraMap)
        return baseMap
    }

    get("/") {
        val products = shopService?.getAllActiveProducts() ?: emptyList()
        call.respond(FreeMarkerContent("home.ftl", buildModel("Express Mobile Repairs & Accessories Store", mapOf("products" to products))))
    }
    get("/how-it-works") {
        call.respond(FreeMarkerContent("static.ftl", buildModel("How It Works")))
    }
    get("/why-choose-us") {
        call.respond(FreeMarkerContent("static.ftl", buildModel("Why Choose Us")))
    }
    get("/repairs") {
        call.respond(FreeMarkerContent("static.ftl", buildModel("Repairs Catalog")))
    }
    get("/reviews") {
        call.respond(FreeMarkerContent("static.ftl", buildModel("Customer Reviews")))
    }
    get("/track") {
        val ref = call.request.queryParameters["ref"] ?: ""
        val booked = call.request.queryParameters["booked"] ?: ""
        val repairs = repairService?.getAllRepairs() ?: emptyList()
        val trackedRepair = if (ref.isNotEmpty()) repairs.firstOrNull { it.referenceCode.equals(ref, ignoreCase = true) } else null

        call.respond(FreeMarkerContent("static.ftl", buildModel("Track Repair Status", mapOf("ref" to ref, "booked" to booked, "trackedRepair" to (trackedRepair ?: "")))))
    }
    get("/contact") {
        call.respond(FreeMarkerContent("static.ftl", buildModel("Contact Us")))
    }
    get("/privacy") {
        call.respond(FreeMarkerContent("static.ftl", buildModel("Privacy Policy")))
    }
    get("/terms") {
        call.respond(FreeMarkerContent("static.ftl", buildModel("Terms & Conditions")))
    }
    get("/warranty") {
        call.respond(FreeMarkerContent("static.ftl", buildModel("Warranty Policy")))
    }
    get("/returns-refunds") {
        call.respond(FreeMarkerContent("static.ftl", buildModel("Returns & Refunds")))
    }
    get("/security") {
        call.respond(FreeMarkerContent("static.ftl", buildModel("Security & Payments")))
    }
    get("/turnaround") {
        call.respond(FreeMarkerContent("static.ftl", buildModel("Turnaround Schedule")))
    }
    get("/postage") {
        call.respond(FreeMarkerContent("static.ftl", buildModel("Post Your Device Guide")))
    }
}
