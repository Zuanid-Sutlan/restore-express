package com.restoreexpress.services

import com.restoreexpress.config.DatabaseFactory.dbQuery
import com.restoreexpress.models.Product
import com.restoreexpress.models.Products
import org.jetbrains.exposed.sql.ResultRow
import org.jetbrains.exposed.sql.selectAll

open class ShopService {
    open suspend fun getAllActiveProducts(): List<Product> = dbQuery {
        Products.selectAll()
            .where { Products.isActive eq true }
            .map { it.toProduct() }
    }

    private fun ResultRow.toProduct() = Product(
        id = this[Products.id].value,
        brand = this[Products.brand],
        modelName = this[Products.modelName],
        slug = this[Products.slug],
        pricePence = this[Products.pricePence],
        stockQuantity = this[Products.stockQuantity],
        condition = this[Products.condition]
    )
}
