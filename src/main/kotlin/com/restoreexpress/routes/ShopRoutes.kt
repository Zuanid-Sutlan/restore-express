package com.restoreexpress.routes

import com.restoreexpress.services.ShopService
import io.ktor.server.freemarker.*
import io.ktor.server.response.*
import io.ktor.server.routing.*

fun Route.shopRoutes(shopService: ShopService) {
    route("/shop") {
        get {
            val products = shopService.getAllActiveProducts()
            call.respond(FreeMarkerContent("shop.ftl", mapOf("title" to "Auction Marketplace", "products" to products)))
        }
        get("/{slug}") {
            val slug = call.parameters["slug"] ?: ""
            val product = shopService.getProductBySlug(slug)
            val title = product?.let { "${it.brand} ${it.modelName}" } ?: "Lot Detail"
            call.respond(FreeMarkerContent("product_detail.ftl", mapOf("title" to title, "product" to product, "slug" to slug)))
        }
    }
}
