package com.restoreexpress.models

import org.jetbrains.exposed.sql.Table
import org.jetbrains.exposed.sql.Column
import org.postgresql.util.PGobject

enum class RepairStatus(val label: String) {
    RECEIVED("Device Received"),
    REPAIRING("Repairing"),
    WAITING_FOR_APPROVAL("Waiting for Approval"),
    REPAIRED("Repaired"),
    DISPATCHED("Dispatched");

    val displayName: String get() = label
}

enum class ProductCondition(val label: String) {
    NEW("Brand New"),
    REFURBISHED_A("Refurbished - Grade A"),
    REFURBISHED_B("Refurbished - Grade B"),
    USED("Pre-Owned / Used");

    val displayName: String get() = label
}

enum class OrderStatus(val label: String) {
    PENDING("Payment Pending"),
    PAID("Paid (Advance via Stripe)"),
    PROCESSING("Processing"),
    SHIPPED("Dispatched"),
    DELIVERED("Delivered"),
    CANCELLED("Cancelled"),
    REFUNDED("Refunded");

    val displayName: String get() = label
}

class PGEnum<T : Enum<T>>(enumTypeName: String, enumValue: T?) : PGobject() {
    init {
        value = enumValue?.name
        type = enumTypeName
    }
}

inline fun <reified T : Enum<T>> Table.pgEnumeration(
    columnName: String,
    postgresEnumName: String,
    defaultValue: T? = null
): Column<T> = customEnumeration(
    name = columnName,
    sql = postgresEnumName,
    fromDb = { value ->
        val enumValue = (value as? PGobject)?.value ?: value.toString()
        enumValues<T>().firstOrNull { it.name == enumValue } ?: enumValues<T>().first()
    },
    toDb = { value -> PGEnum(postgresEnumName, value) }
).apply {
    if (defaultValue != null) {
        default(defaultValue)
    }
}
