package com.restoreexpress.config

import com.zaxxer.hikari.HikariConfig
import com.zaxxer.hikari.HikariDataSource
import org.flywaydb.core.Flyway
import org.jetbrains.exposed.sql.Database
import org.jetbrains.exposed.sql.transactions.experimental.newSuspendedTransaction

object DatabaseFactory {
    fun init(databaseUrl: String, user: String? = null, password: String? = null) {
        val config = HikariConfig().apply {
            jdbcUrl = databaseUrl
            user?.let { username = it }
            password?.let { this.password = it }
            driverClassName = "org.postgresql.Driver"
            maximumPoolSize = 10
            isAutoCommit = false
            transactionIsolation = "TRANSACTION_REPEATABLE_READ"
            validate()
        }
        val dataSource = HikariDataSource(config)
        Database.connect(dataSource)
        
        // Run migrations
        val flyway = Flyway.configure()
            .dataSource(dataSource)
            .load()
        flyway.repair()
        flyway.migrate()
    }

    suspend fun <T> dbQuery(block: suspend () -> T): T =
        newSuspendedTransaction { block() }
}
