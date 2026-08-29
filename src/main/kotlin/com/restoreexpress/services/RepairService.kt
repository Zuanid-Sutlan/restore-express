package com.restoreexpress.services

import com.restoreexpress.config.DatabaseFactory.dbQuery
import com.restoreexpress.models.*
import org.jetbrains.exposed.sql.*
import java.time.LocalDateTime

open class RepairService {
    open suspend fun createRepair(
        customerName: String,
        email: String,
        phone: String,
        deviceModel: String,
        reportedFault: String,
        pricePence: Int
    ): String = dbQuery {
        val reference = "RE-${LocalDateTime.now().year}-${(1000..9999).random()}"
        Repairs.insert {
            it[referenceCode] = reference
            it[this.customerName] = customerName
            it[this.email] = email
            it[this.phone] = phone
            it[this.deviceModel] = deviceModel
            it[this.reportedFault] = reportedFault
            it[quotedPricePence] = pricePence
            it[balanceDuePence] = pricePence
        }
        reference
    }

    open suspend fun getAllRepairs(statusFilter: RepairStatus? = null): List<Repair> = dbQuery {
        val query = if (statusFilter != null) {
            Repairs.selectAll().where { Repairs.status eq statusFilter }
        } else {
            Repairs.selectAll()
        }
        query.orderBy(Repairs.createdAt to SortOrder.DESC)
            .map { it.toRepair() }
    }

    open suspend fun getRepairById(id: Int): DetailedRepair? = dbQuery {
        val repairRow = Repairs.selectAll().where { Repairs.id eq id }.singleOrNull() ?: return@dbQuery null
        val repair = repairRow.toRepair()

        val events = RepairEvents.selectAll()
            .where { RepairEvents.repairId eq id }
            .orderBy(RepairEvents.createdAt to SortOrder.DESC)
            .map { row ->
                RepairEvent(
                    id = row[RepairEvents.id].value,
                    repairId = row[RepairEvents.repairId].value,
                    status = row[RepairEvents.status],
                    note = row[RepairEvents.note],
                    createdAt = row[RepairEvents.createdAt]
                )
            }

        DetailedRepair(repair, events)
    }

    open suspend fun updateRepairStatus(id: Int, status: RepairStatus, note: String?): Boolean = dbQuery {
        val updated = Repairs.update({ Repairs.id eq id }) {
            it[Repairs.status] = status
            it[Repairs.updatedAt] = LocalDateTime.now()
        } > 0

        if (updated) {
            RepairEvents.insert {
                it[repairId] = id
                it[this.status] = status
                it[this.note] = if (note.isNullOrBlank()) null else note.trim()
            }
        }
        updated
    }

    private fun ResultRow.toRepair() = Repair(
        id = this[Repairs.id].value,
        referenceCode = this[Repairs.referenceCode],
        customerName = this[Repairs.customerName],
        email = this[Repairs.email],
        phone = this[Repairs.phone],
        deviceModel = this[Repairs.deviceModel],
        imeiSerial = this[Repairs.imeiSerial],
        reportedFault = this[Repairs.reportedFault],
        conditionNotes = this[Repairs.conditionNotes],
        status = this[Repairs.status],
        quotedPricePence = this[Repairs.quotedPricePence],
        depositPaidPence = this[Repairs.depositPaidPence],
        balanceDuePence = this[Repairs.balanceDuePence],
        stripePaymentIntentId = this[Repairs.stripePaymentIntentId],
        createdAt = this[Repairs.createdAt],
        updatedAt = this[Repairs.updatedAt]
    )
}
