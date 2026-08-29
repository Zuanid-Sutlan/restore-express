package com.restoreexpress.models

import org.jetbrains.exposed.dao.id.IntIdTable
import org.jetbrains.exposed.sql.javatime.datetime
import kotlinx.serialization.Serializable
import java.time.LocalDateTime

object Admins : IntIdTable("admins") {
    val email = varchar("email", 255).uniqueIndex()
    val passwordHash = varchar("password_hash", 255)
    val createdAt = datetime("created_at").default(LocalDateTime.now())
}

data class Admin(
    val id: Int,
    val email: String,
    val passwordHash: String
)

@Serializable
data class AdminSession(
    val adminId: Int,
    val email: String
)
