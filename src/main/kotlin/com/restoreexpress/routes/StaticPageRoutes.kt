package com.restoreexpress.routes

import io.ktor.server.application.*
import io.ktor.server.freemarker.*
import io.ktor.server.response.*
import io.ktor.server.routing.*

fun Route.staticPageRoutes() {
    get("/") {
        call.respond(FreeMarkerContent("home.ftl", mapOf("title" to "Home")))
    }
    get("/privacy") { call.respond(FreeMarkerContent("static.ftl", mapOf("title" to "Privacy Policy"))) }
    get("/terms") { call.respond(FreeMarkerContent("static.ftl", mapOf("title" to "Terms & Conditions"))) }
}
