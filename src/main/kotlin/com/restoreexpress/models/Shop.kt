package com.restoreexpress.models

import org.jetbrains.exposed.dao.id.IntIdTable
import org.jetbrains.exposed.sql.javatime.datetime
import java.time.LocalDateTime

object Products : IntIdTable("products") {
    val brand = varchar("brand", 100)
    val modelName = varchar("model_name", 255)
    val slug = varchar("slug", 255).uniqueIndex()
    val description = text("description").nullable()
    val condition = pgEnumeration<ProductCondition>("condition", "product_condition")
    val storageVariant = varchar("storage_variant", 50).nullable()
    val color = varchar("color", 50).nullable()
    val pricePence = integer("price_pence")
    val stockQuantity = integer("stock_quantity").default(0)
    val isActive = bool("is_active").default(true)
    val createdAt = datetime("created_at").default(LocalDateTime.now())
}

object ProductImages : IntIdTable("product_images") {
    val productId = reference("product_id", Products)
    val url = text("url")
    val sortOrder = integer("sort_order").default(0)
}

object Orders : IntIdTable("orders") {
    val orderReference = varchar("order_reference", 50).uniqueIndex()
    val customerName = varchar("customer_name", 255)
    val email = varchar("email", 255)
    val phone = varchar("phone", 50)
    val shippingAddressLine1 = text("shipping_address_line1")
    val shippingAddressLine2 = text("shipping_address_line2").nullable()
    val shippingCity = varchar("shipping_city", 100)
    val shippingPostcode = varchar("shipping_postcode", 20)
    val shippingCountry = varchar("shipping_country", 100)
    val status = pgEnumeration("status", "order_status", OrderStatus.PENDING)
    val subtotalPence = integer("subtotal_pence")
    val shippingCostPence = integer("shipping_cost_pence")
    val totalPence = integer("total_pence")
    val stripePaymentIntentId = varchar("stripe_payment_intent_id", 255).nullable()
    val trackingNumber = varchar("tracking_number", 100).nullable()
    val createdAt = datetime("created_at").default(LocalDateTime.now())
    val updatedAt = datetime("updated_at").default(LocalDateTime.now())
}

object OrderItems : IntIdTable("order_items") {
    val orderId = reference("order_id", Orders)
    val productId = reference("product_id", Products)
    val quantity = integer("quantity")
    val unitPricePence = integer("unit_price_pence")
}

data class Product(
    val id: Int,
    val brand: String,
    val modelName: String,
    val slug: String,
    val pricePence: Int,
    val stockQuantity: Int,
    val condition: ProductCondition
)
