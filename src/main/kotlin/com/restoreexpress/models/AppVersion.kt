package com.restoreexpress.models

import kotlinx.serialization.Serializable

@Serializable
data class AppVersionInfo(
    val version: String,
    val environment: String,
    val fullVersionTag: String,
    val commitHash: String? = null,
    @get:JvmName("getIsProduction") val isProduction: Boolean = false,
    @get:JvmName("getIsDevelopment") val isDevelopment: Boolean = true
) {
    val production: Boolean get() = isProduction
    val development: Boolean get() = isDevelopment
}
