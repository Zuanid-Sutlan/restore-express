package com.restoreexpress

import com.restoreexpress.config.DatabaseFactory
import com.restoreexpress.config.StripeConfig
import com.restoreexpress.models.AdminSession
import com.restoreexpress.routes.configureRouting
import com.restoreexpress.services.RepairService
import com.restoreexpress.services.ShopService
import com.restoreexpress.services.StripeService
import com.restoreexpress.services.AdminService
import io.github.cdimascio.dotenv.dotenv
import io.ktor.serialization.kotlinx.json.*
import io.ktor.server.application.*
import io.ktor.server.auth.*
import io.ktor.server.freemarker.*
import io.ktor.server.netty.*
import io.ktor.server.plugins.calllogging.*
import io.ktor.server.plugins.contentnegotiation.*
import io.ktor.server.plugins.statuspages.*
import io.ktor.server.response.*
import io.ktor.server.sessions.*
import io.ktor.http.*
import freemarker.cache.*
import java.io.File

fun main(args: Array<String>): Unit = EngineMain.main(args)

fun Application.module() {
    val dotenv = dotenv {
        ignoreIfMissing = true
    }

    val databaseUrl = dotenv["DATABASE_URL"] ?: "jdbc:postgresql://localhost:5433/restore_express"
    val dbUser = dotenv["DATABASE_USER"] ?: dotenv["POSTGRES_USER"] ?: "postgres"
    val dbPassword = dotenv["DATABASE_PASSWORD"] ?: dotenv["POSTGRES_PASSWORD"] ?: "postgres"
    
    val stripeSecretKey = dotenv["STRIPE_SECRET_KEY"] ?: ""
    val stripeWebhookSecret = dotenv["STRIPE_WEBHOOK_SECRET"] ?: ""
    val sessionSecret = dotenv["SESSION_SECRET"] ?: "change-me-in-production-123456789012"

    // Infrastructure
    DatabaseFactory.init(databaseUrl, dbUser, dbPassword)
    StripeConfig.init(stripeSecretKey, stripeWebhookSecret)

    // Services
    val shopService = ShopService()
    val repairService = RepairService()
    val stripeService = StripeService()
    val adminService = AdminService()

    // Plugins
    install(CallLogging)
    
    install(ContentNegotiation) {
        json()
    }

    install(Sessions) {
        cookie<AdminSession>("ADMIN_SESSION") {
            cookie.path = "/"
            cookie.maxAgeInSeconds = 60 * 60 * 24 // 1 day
            transform(SessionTransportTransformerMessageAuthentication(sessionSecret.toByteArray()))
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
        // Use the folder requested by the user
        templateLoader = FileTemplateLoader(File("src/main/kotlin/com/restoreexpress/templates"))
    }

    install(StatusPages) {
        status(HttpStatusCode.NotFound) { call, status ->
            call.respond(FreeMarkerContent("error.ftl", mapOf("status" to status.value, "message" to "Page Not Found")))
        }
        exception<Throwable> { call, cause ->
            call.respond(HttpStatusCode.InternalServerError, "Internal Server Error")
        }
    }

    configureRouting(shopService, repairService, stripeService, adminService)
}
