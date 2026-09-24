package com.restoreexpress.models

import org.jetbrains.exposed.sql.Table
import org.jetbrains.exposed.sql.Column
import org.postgresql.util.PGobject

enum class RepairStatus {
    RECEIVED, IN_PROGRESS, AWAITING_PARTS, COMPLETED, RETURNED
}

enum class ProductCondition {
    NEW, REFURBISHED_A, REFURBISHED_B, USED
}

enum class OrderStatus {
    PENDING, PAID, PROCESSING, SHIPPED, DELIVERED, CANCELLED, REFUNDED
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
        enumValues<T>().first { it.name == enumValue }
    },
    toDb = { value -> PGEnum(postgresEnumName, value) }
).apply {
    if (defaultValue != null) {
        default(defaultValue)
    }
}
