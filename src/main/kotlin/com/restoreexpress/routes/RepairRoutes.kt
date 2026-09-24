package com.restoreexpress.routes

import com.restoreexpress.services.RepairService
import io.ktor.server.application.*
import io.ktor.server.freemarker.*
import io.ktor.server.request.*
import io.ktor.server.response.*
import io.ktor.server.routing.*

fun Route.repairRoutes(repairService: RepairService) {
    route("/repair") {
        get("/book") {
            call.respond(FreeMarkerContent("repair_booking.ftl", mapOf("title" to "Book a Repair")))
        }
        post("/book") {
            val params = call.receiveParameters()
            val reference = repairService.createRepair(
                customerName = params["customer_name"] ?: "",
                email = params["email"] ?: "",
                phone = params["phone"] ?: "",
                deviceModel = params["device_model"] ?: "",
                reportedFault = params["reported_fault"] ?: "",
                pricePence = 0 // TBD
            )
            call.respondRedirect("/track?ref=$reference")
        }
    }
}
