package com.restoreexpress.models

import org.jetbrains.exposed.dao.id.IntIdTable
import org.jetbrains.exposed.sql.javatime.datetime
import java.time.LocalDateTime

object Repairs : IntIdTable("repairs") {
    val referenceCode = varchar("reference_code", 50).uniqueIndex()
    val customerName = varchar("customer_name", 255)
    val email = varchar("email", 255)
    val phone = varchar("phone", 50)
    val deviceModel = varchar("device_model", 255)
    val imeiSerial = varchar("imei_serial", 100).nullable()
    val reportedFault = text("reported_fault")
    val conditionNotes = text("condition_notes").nullable()
    val status = pgEnumeration("status", "repair_status", RepairStatus.RECEIVED)
    val quotedPricePence = integer("quoted_price_pence")
    val depositPaidPence = integer("deposit_paid_pence").default(0)
    val balanceDuePence = integer("balance_due_pence")
    val stripePaymentIntentId = varchar("stripe_payment_intent_id", 255).nullable()
    val createdAt = datetime("created_at").default(LocalDateTime.now())
    val updatedAt = datetime("updated_at").default(LocalDateTime.now())
}

object RepairEvents : IntIdTable("repair_events") {
    val repairId = reference("repair_id", Repairs)
    val status = pgEnumeration<RepairStatus>("status", "repair_status")
    val note = text("note").nullable()
    val createdAt = datetime("created_at").default(LocalDateTime.now())
}

object RepairPhotos : IntIdTable("repair_photos") {
    val repairId = reference("repair_id", Repairs)
    val url = text("url")
    val createdAt = datetime("created_at").default(LocalDateTime.now())
}

data class Repair(
    val id: Int,
    val referenceCode: String,
    val customerName: String,
    val email: String,
    val phone: String,
    val deviceModel: String,
    val imeiSerial: String?,
    val reportedFault: String,
    val conditionNotes: String?,
    val status: RepairStatus,
    val quotedPricePence: Int,
    val depositPaidPence: Int,
    val balanceDuePence: Int,
    val stripePaymentIntentId: String?,
    val createdAt: LocalDateTime,
    val updatedAt: LocalDateTime
)

data class RepairEvent(
    val id: Int,
    val repairId: Int,
    val status: RepairStatus,
    val note: String?,
    val createdAt: LocalDateTime
)

data class DetailedRepair(
    val repair: Repair,
    val events: List<RepairEvent>
)
