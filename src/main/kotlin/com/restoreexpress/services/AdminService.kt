package com.restoreexpress.services

import com.restoreexpress.config.DatabaseFactory.dbQuery
import com.restoreexpress.models.Admin
import com.restoreexpress.models.Admins
import org.jetbrains.exposed.sql.selectAll
import org.mindrot.jbcrypt.BCrypt

open class AdminService {
    open suspend fun authenticate(email: String, password: String): Admin? {
        val admin = dbQuery {
            Admins.selectAll().where { Admins.email eq email }
                .map {
                    Admin(
                        id = it[Admins.id].value,
                        email = it[Admins.email],
                        passwordHash = it[Admins.passwordHash]
                    )
                }
                .singleOrNull()
        }

        return if (admin != null && BCrypt.checkpw(password, admin.passwordHash)) {
            admin
        } else {
            null
        }
    }
}
