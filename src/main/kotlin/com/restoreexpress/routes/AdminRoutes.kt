package com.restoreexpress.routes

import io.ktor.server.application.*
import io.ktor.server.auth.*
import io.ktor.server.freemarker.*
import io.ktor.server.request.*
import io.ktor.server.response.*
import io.ktor.server.routing.*
import io.ktor.server.sessions.*
import com.restoreexpress.services.AdminService
import com.restoreexpress.models.AdminSession

fun Route.adminRoutes(adminService: AdminService) {
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
            get("/dashboard") { call.respond(FreeMarkerContent("admin/dashboard.ftl", emptyMap<String, String>())) }
            // Repairs, Products, Orders...
        }

        get("/logout") {
            call.sessions.clear<AdminSession>()
            call.respondRedirect("/admin/login")
        }
    }
}
