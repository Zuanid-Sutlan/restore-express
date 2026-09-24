package com.restoreexpress.services

import com.restoreexpress.config.DatabaseFactory.dbQuery
import com.restoreexpress.models.*
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

    open suspend fun getDashboardStats(shopService: ShopService, repairService: RepairService): DashboardStats {
        val allProducts = shopService.getAllProducts()
        val allOrders = shopService.getAllOrders()
        val allRepairs = repairService.getAllRepairs()

        val activeProducts = allProducts.count { it.isActive }
        val pendingOrders = allOrders.count { it.status == OrderStatus.PENDING }
        val activeRepairs = allRepairs.count {
            it.status == RepairStatus.RECEIVED || it.status == RepairStatus.IN_PROGRESS || it.status == RepairStatus.AWAITING_PARTS
        }

        return DashboardStats(
            totalProducts = allProducts.size,
            activeProducts = activeProducts,
            totalOrders = allOrders.size,
            pendingOrders = pendingOrders,
            totalRepairs = allRepairs.size,
            activeRepairs = activeRepairs,
            recentOrders = allOrders.take(5),
            recentRepairs = allRepairs.take(5)
        )
    }
}
