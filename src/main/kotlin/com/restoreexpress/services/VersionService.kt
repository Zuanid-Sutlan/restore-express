package com.restoreexpress.services

import com.restoreexpress.models.AppVersionInfo
import io.github.cdimascio.dotenv.Dotenv

open class VersionService(private val dotenv: Dotenv? = null) {

    open fun getVersionInfo(): AppVersionInfo {
        val baseVersion = dotenv?.get("APP_VERSION")
            ?: System.getenv("APP_VERSION")
            ?: "1.0.0"

        val rawEnv = dotenv?.get("APP_ENV")
            ?: System.getenv("APP_ENV")
            ?: "develop"

        val normalizedEnv = rawEnv.lowercase().trim()
        val isProd = normalizedEnv == "production" || normalizedEnv == "prod" || normalizedEnv == "main"
        val envName = if (isProd) "production" else "develop"

        val commitHash = dotenv?.get("GIT_COMMIT_HASH")
            ?: System.getenv("GIT_COMMIT_HASH")
            ?: System.getenv("GITHUB_SHA")?.take(7)

        val suffix = if (isProd) "prod" else "dev"
        val commitPart = if (!commitHash.isNullOrEmpty()) "-$commitHash" else ""
        val fullTag = "v$baseVersion-$suffix$commitPart"

        return AppVersionInfo(
            version = baseVersion,
            environment = envName,
            fullVersionTag = fullTag,
            commitHash = commitHash,
            isProduction = isProd,
            isDevelopment = !isProd
        )
    }
}
