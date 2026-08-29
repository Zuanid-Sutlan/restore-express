package com.restoreexpress.routes

import com.restoreexpress.services.SettingsService
import com.restoreexpress.services.VersionService
import io.ktor.server.application.*
import io.ktor.server.freemarker.*
import io.ktor.server.response.*
import io.ktor.server.routing.*

fun Route.staticPageRoutes(
    settingsService: SettingsService = SettingsService(),
    versionService: VersionService = VersionService()
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
        call.respond(FreeMarkerContent("home.ftl", buildModel("Home")))
    }
    get("/how-it-works") {
        call.respond(FreeMarkerContent("static.ftl", buildModel("How It Works")))
    }
    get("/why-choose-us") {
        call.respond(FreeMarkerContent("static.ftl", buildModel("Why Choose Us")))
    }
    get("/repairs") {
        call.respond(FreeMarkerContent("static.ftl", buildModel("Repairs")))
    }
    get("/reviews") {
        call.respond(FreeMarkerContent("static.ftl", buildModel("Customer Reviews")))
    }
    get("/track") {
        call.respond(FreeMarkerContent("static.ftl", buildModel("Track Repair")))
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
        call.respond(FreeMarkerContent("static.ftl", buildModel("Warranty")))
    }
    get("/returns-refunds") {
        call.respond(FreeMarkerContent("static.ftl", buildModel("Returns & Refunds")))
    }
    get("/security") {
        call.respond(FreeMarkerContent("static.ftl", buildModel("Security & Trust")))
    }
    get("/turnaround") {
        call.respond(FreeMarkerContent("static.ftl", buildModel("Turnaround Schedule")))
    }
    get("/postage") {
        call.respond(FreeMarkerContent("static.ftl", buildModel("Post Your Phone Guide")))
    }
}
