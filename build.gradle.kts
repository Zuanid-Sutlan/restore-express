plugins {
    alias(libs.plugins.kotlin.jvm)
    alias(libs.plugins.shadow)
    alias(libs.plugins.ktor)
    alias(libs.plugins.kotlin.serialization)
}

kotlin {
    jvmToolchain(21)
}

group = "com.restoreexpress"
version = "0.0.1"

application {
    mainClass.set("io.ktor.server.netty.EngineMain")
}

repositories {
    mavenCentral()
}

dependencies {
    // Ktor Core & Netty
    implementation(libs.ktor.server.core)
    implementation(libs.ktor.server.netty)
    
    // Ktor Plugins
    implementation(libs.ktor.server.sessions)
    implementation(libs.ktor.server.auth)
    implementation(libs.ktor.server.content.negotiation)
    implementation(libs.ktor.server.status.pages)
    implementation(libs.ktor.server.freemarker)
    implementation(libs.ktor.server.host.common)
    implementation(libs.ktor.call.logging)
    implementation(libs.ktor.server.swagger)
    implementation(libs.ktor.server.openapi)
    
    // Serialization
    implementation(libs.ktor.serialization.json)
    
    // Database (Exposed + Postgres + Hikari)
    implementation(libs.exposed.core)
    implementation(libs.exposed.dao)
    implementation(libs.exposed.jdbc)
    implementation(libs.exposed.javatime)
    implementation(libs.exposed.kotlin.datetime)
    implementation(libs.postgresql)
    implementation(libs.hikaricp)
    
    // Migrations
    implementation(libs.flyway.core)
    implementation(libs.flyway.database.postgresql)
    
    // Stripe SDK
    implementation(libs.stripe.java)
    
    // Environment Variables
    implementation(libs.dotenv.kotlin)
    
    // Password Hashing
    implementation(libs.jbcrypt)

    // Logging
    implementation(libs.logback.classic)
    
    testImplementation(libs.ktor.server.tests)
    testImplementation(libs.kotlin.test.junit)
}
