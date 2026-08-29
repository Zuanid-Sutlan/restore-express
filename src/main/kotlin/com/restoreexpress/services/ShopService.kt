package com.restoreexpress.services

import com.restoreexpress.config.DatabaseFactory.dbQuery
import com.restoreexpress.models.*
import org.jetbrains.exposed.sql.*
import org.jetbrains.exposed.sql.SqlExpressionBuilder.eq
import java.time.LocalDateTime

open class ShopService {
    open suspend fun getAllActiveProducts(): List<Product> = dbQuery {
        Products.selectAll()
            .where { Products.isActive eq true }
            .orderBy(Products.createdAt to SortOrder.DESC)
            .map { it.toProduct(fetchImages(it[Products.id].value)) }
    }

    open suspend fun getAllProducts(): List<Product> = dbQuery {
        Products.selectAll()
            .orderBy(Products.createdAt to SortOrder.DESC)
            .map { it.toProduct(fetchImages(it[Products.id].value)) }
    }

    open suspend fun getProductById(id: Int): Product? = dbQuery {
        Products.selectAll()
            .where { Products.id eq id }
            .map { it.toProduct(fetchImages(id)) }
            .singleOrNull()
    }

    open suspend fun getProductBySlug(slug: String): Product? = dbQuery {
        val row = Products.selectAll()
            .where { Products.slug eq slug }
            .singleOrNull() ?: return@dbQuery null
        val images = fetchImages(row[Products.id].value)
        row.toProduct(images)
    }

    open suspend fun getProductImages(productId: Int): List<ProductImage> = dbQuery {
        fetchImages(productId)
    }

    open suspend fun addProductImage(productId: Int, url: String, sortOrder: Int = 0): Int = dbQuery {
        ProductImages.insert {
            it[ProductImages.productId] = productId
            it[ProductImages.url] = url
            it[ProductImages.sortOrder] = sortOrder
        }[ProductImages.id].value
    }

    open suspend fun deleteProductImage(imageId: Int): Boolean = dbQuery {
        ProductImages.deleteWhere { ProductImages.id eq imageId } > 0
    }

    open suspend fun deleteProduct(productId: Int): Boolean = dbQuery {
        ProductImages.deleteWhere { ProductImages.productId eq productId }
        Products.deleteWhere { Products.id eq productId } > 0
    }

    private fun fetchImages(productId: Int): List<ProductImage> {
        return ProductImages.selectAll()
            .where { ProductImages.productId eq productId }
            .orderBy(ProductImages.sortOrder to SortOrder.ASC, ProductImages.id to SortOrder.ASC)
            .map { row ->
                ProductImage(
                    id = row[ProductImages.id].value,
                    productId = row[ProductImages.productId].value,
                    url = row[ProductImages.url],
                    sortOrder = row[ProductImages.sortOrder]
                )
            }
    }

    private fun generateUniqueSlugInternal(baseSlug: String, currentId: Int? = null): String {
        val cleanBase = baseSlug.lowercase().trim().replace(" ", "-").replace(Regex("[^a-z0-9-]"), "").ifEmpty { "product" }
        var candidate = cleanBase
        var count = 1
        while (true) {
            val existing = Products.selectAll()
                .where { Products.slug eq candidate }
                .map { it[Products.id].value }
                .singleOrNull()
            if ((existing == null) || (existing == currentId)) {
                return candidate
            }
            count++
            candidate = "$cleanBase-$count"
        }
    }

    open suspend fun generateUniqueSlug(baseSlug: String, currentId: Int? = null): String = dbQuery {
        generateUniqueSlugInternal(baseSlug, currentId)
    }

    open suspend fun createProduct(
        brand: String,
        modelName: String,
        slug: String,
        description: String?,
        condition: ProductCondition,
        storageVariant: String?,
        color: String?,
        pricePence: Int,
        stockQuantity: Int,
        isActive: Boolean
    ): Int = dbQuery {
        val finalSlug = generateUniqueSlugInternal(slug)
        Products.insert {
            it[Products.brand] = brand
            it[Products.modelName] = modelName
            it[Products.slug] = finalSlug
            it[Products.description] = description
            it[Products.condition] = condition
            it[Products.storageVariant] = storageVariant
            it[Products.color] = color
            it[Products.pricePence] = pricePence
            it[Products.stockQuantity] = stockQuantity
            it[Products.isActive] = isActive
        }[Products.id].value
    }

    open suspend fun updateProduct(
        id: Int,
        brand: String,
        modelName: String,
        slug: String,
        description: String?,
        condition: ProductCondition,
        storageVariant: String?,
        color: String?,
        pricePence: Int,
        stockQuantity: Int,
        isActive: Boolean
    ): Boolean = dbQuery {
        val finalSlug = generateUniqueSlugInternal(slug, id)
        Products.update({ Products.id eq id }) {
            it[Products.brand] = brand
            it[Products.modelName] = modelName
            it[Products.slug] = finalSlug
            it[Products.description] = description
            it[Products.condition] = condition
            it[Products.storageVariant] = storageVariant
            it[Products.color] = color
            it[Products.pricePence] = pricePence
            it[Products.stockQuantity] = stockQuantity
            it[Products.isActive] = isActive
        } > 0
    }

    open suspend fun toggleProductActive(id: Int): Boolean = dbQuery {
        val current = Products.selectAll().where { Products.id eq id }.singleOrNull() ?: return@dbQuery false
        val newStatus = !current[Products.isActive]
        Products.update({ Products.id eq id }) {
            it[Products.isActive] = newStatus
        } > 0
    }

    open suspend fun getAllOrders(statusFilter: OrderStatus? = null): List<Order> = dbQuery {
        val query = if (statusFilter != null) {
            Orders.selectAll().where { Orders.status eq statusFilter }
        } else {
            Orders.selectAll()
        }
        query.orderBy(Orders.createdAt to SortOrder.DESC)
            .map { it.toOrder() }
    }

    open suspend fun getOrderById(id: Int): DetailedOrder? = dbQuery {
        val orderRow = Orders.selectAll().where { Orders.id eq id }.singleOrNull() ?: return@dbQuery null
        val order = orderRow.toOrder()

        val items = (OrderItems innerJoin Products)
            .selectAll()
            .where { OrderItems.orderId eq id }
            .map { row ->
                OrderItemDetail(
                    id = row[OrderItems.id].value,
                    productId = row[OrderItems.productId].value,
                    productBrand = row[Products.brand],
                    productModel = row[Products.modelName],
                    quantity = row[OrderItems.quantity],
                    unitPricePence = row[OrderItems.unitPricePence]
                )
            }

        DetailedOrder(order, items)
    }

    open suspend fun updateOrderStatus(id: Int, status: OrderStatus, trackingNumber: String?): Boolean = dbQuery {
        Orders.update({ Orders.id eq id }) {
            it[Orders.status] = status
            if (!trackingNumber.isNullOrEmpty()) {
                it[Orders.trackingNumber] = trackingNumber
            }
            it[Orders.updatedAt] = LocalDateTime.now()
        } > 0
    }

    private fun ResultRow.toProduct(images: List<ProductImage> = emptyList()) = Product(
        id = this[Products.id].value,
        brand = this[Products.brand],
        modelName = this[Products.modelName],
        slug = this[Products.slug],
        pricePence = this[Products.pricePence],
        stockQuantity = this[Products.stockQuantity],
        condition = this[Products.condition],
        description = this[Products.description],
        storageVariant = this[Products.storageVariant],
        color = this[Products.color],
        isActive = this[Products.isActive],
        createdAt = this[Products.createdAt],
        images = images
    )

    private fun ResultRow.toOrder() = Order(
        id = this[Orders.id].value,
        orderReference = this[Orders.orderReference],
        customerName = this[Orders.customerName],
        email = this[Orders.email],
        phone = this[Orders.phone],
        shippingAddressLine1 = this[Orders.shippingAddressLine1],
        shippingAddressLine2 = this[Orders.shippingAddressLine2],
        shippingCity = this[Orders.shippingCity],
        shippingPostcode = this[Orders.shippingPostcode],
        shippingCountry = this[Orders.shippingCountry],
        status = this[Orders.status],
        subtotalPence = this[Orders.subtotalPence],
        shippingCostPence = this[Orders.shippingCostPence],
        totalPence = this[Orders.totalPence],
        stripePaymentIntentId = this[Orders.stripePaymentIntentId],
        trackingNumber = this[Orders.trackingNumber],
        createdAt = this[Orders.createdAt],
        updatedAt = this[Orders.updatedAt]
    )
}
