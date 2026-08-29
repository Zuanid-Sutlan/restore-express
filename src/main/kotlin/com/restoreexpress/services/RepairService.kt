package com.restoreexpress.services

import com.restoreexpress.config.DatabaseFactory.dbQuery
import com.restoreexpress.models.Repairs
import org.jetbrains.exposed.sql.insert
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
}
