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
            val fault = params["reported_fault"] ?: "Screen & Hardware Repair"
            val priceVal = params["quoted_price"]?.toDoubleOrNull() ?: 59.00
            val pricePence = (priceVal * 100).toInt()

            val reference = repairService.createRepair(
                customerName = params["customer_name"] ?: "",
                email = params["email"] ?: "",
                phone = params["phone"] ?: "",
                deviceModel = params["device_model"] ?: "",
                reportedFault = fault,
                pricePence = pricePence
            )
            call.respondRedirect("/track?ref=$reference&booked=1")
        }
    }
}
