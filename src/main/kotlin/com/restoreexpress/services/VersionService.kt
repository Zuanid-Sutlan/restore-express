package com.restoreexpress.services

import com.restoreexpress.models.AppVersionInfo
import io.github.cdimascio.dotenv.Dotenv
import java.io.File
import java.util.Properties

open class VersionService(private val dotenv: Dotenv? = null) {

    open fun getVersionInfo(): AppVersionInfo {
        val properties = Properties()
        val versionFile = File("version.properties")
        if (versionFile.exists()) {
            runCatching {
                versionFile.inputStream().use { properties.load(it) }
            }
        }

        val rawVersion = properties.getProperty("app.version")
            ?: dotenv?.get("APP_VERSION")
            ?: System.getenv("APP_VERSION")
            ?: "1.0.0"

        val rawEnv = properties.getProperty("app.environment")
            ?: dotenv?.get("APP_ENV")
            ?: System.getenv("APP_ENV")
            ?: "develop"

        val normalizedEnv = rawEnv.lowercase().trim()
        val isProd = (normalizedEnv == "production") || (normalizedEnv == "prod") || (normalizedEnv == "main")
        val envName = if (isProd) "production" else "develop"

        // Clean base version by removing trailing -dev or -prod
        val cleanVersion = rawVersion.replace(Regex("(?i)-(dev|prod)$"), "").trim()

        val rawCommitHash = dotenv?.get("GIT_COMMIT_HASH")
            ?: System.getenv("GIT_COMMIT_HASH")
            ?: System.getenv("GITHUB_SHA")?.take(7)

        // Only attach commitHash if it's a valid hexadecimal commit SHA
        val commitHash = rawCommitHash?.trim()?.takeIf {
            it.lowercase() != "dev" && it.lowercase() != "local" && it.lowercase() != "main" && it.matches(Regex("^[a-fA-F0-9]{4,40}$"))
        }

        val suffix = if (isProd) "prod" else "dev"
        val commitPart = if (!commitHash.isNullOrEmpty()) "-$commitHash" else ""
        val fullTag = "v$cleanVersion-$suffix$commitPart"

        return AppVersionInfo(
            version = cleanVersion,
            environment = envName,
            fullVersionTag = fullTag,
            commitHash = commitHash,
            isProduction = isProd,
            isDevelopment = !isProd,
        )
    }
}
