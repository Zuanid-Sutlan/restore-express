package com.restoreexpress.routes

import com.restoreexpress.services.StripeService
import io.ktor.http.*
import io.ktor.server.application.*
import io.ktor.server.request.*
import io.ktor.server.response.*
import io.ktor.server.routing.*

fun Route.webhookRoutes(stripeService: StripeService) {
    post("/webhooks/stripe") {
        val payload = call.receiveText()
        val signature = call.request.header("Stripe-Signature") ?: ""
        val event = stripeService.verifyWebhook(payload, signature)
        
        if (event == null) {
            call.respond(HttpStatusCode.BadRequest)
            return@post
        }

        when (event.type) {
            "payment_intent.succeeded" -> {
                // Handle success
            }
        }
        
        call.respond(HttpStatusCode.OK)
    }
}
