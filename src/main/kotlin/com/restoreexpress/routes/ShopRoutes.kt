package com.restoreexpress.routes

import com.restoreexpress.services.ShopService
import io.ktor.server.application.*
import io.ktor.server.freemarker.*
import io.ktor.server.response.*
import io.ktor.server.routing.*

fun Route.shopRoutes(shopService: ShopService) {
    route("/shop") {
        get {
            val products = shopService.getAllActiveProducts()
            call.respond(FreeMarkerContent("shop.ftl", mapOf("title" to "Shop", "products" to products)))
        }
        get("/{slug}") {
            val slug = call.parameters["slug"]
            call.respond(FreeMarkerContent("product_detail.ftl", mapOf("title" to "Product Detail", "slug" to slug)))
        }
    }
}
