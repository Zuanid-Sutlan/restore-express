package com.restoreexpress.services

import com.restoreexpress.config.DatabaseFactory.dbQuery
import com.restoreexpress.models.SiteSettings
import com.restoreexpress.models.SiteSettingsData
import org.jetbrains.exposed.sql.*
import org.jetbrains.exposed.sql.SqlExpressionBuilder.eq

open class SettingsService {
    open suspend fun getSettings(): SiteSettingsData = dbQuery {
        val map = runCatching {
            SiteSettings.selectAll().associate { it[SiteSettings.key] to it[SiteSettings.value] }
        }.getOrDefault(emptyMap())

        SiteSettingsData(
            whatsappNumber = map["whatsapp_number"] ?: "18005557378",
            facebookUrl = map["facebook_url"] ?: "https://facebook.com/restoreexpress",
            instagramUrl = map["instagram_url"] ?: "https://instagram.com/restoreexpress",
            youtubeUrl = map["youtube_url"] ?: "https://youtube.com/restoreexpress",
            twitterUrl = map["twitter_url"] ?: "https://x.com/restoreexpress",
            phoneNumber = map["phone_number"] ?: "+1 (800) 555-RESTORE",
            supportEmail = map["support_email"] ?: "support@restoreexpress.com"
        )
    }

    open suspend fun updateSettings(data: SiteSettingsData): Boolean = dbQuery {
        val updates = mapOf(
            "whatsapp_number" to data.whatsappNumber,
            "facebook_url" to data.facebookUrl,
            "instagram_url" to data.instagramUrl,
            "youtube_url" to data.youtubeUrl,
            "twitter_url" to data.twitterUrl,
            "phone_number" to data.phoneNumber,
            "support_email" to data.supportEmail
        )

        for ((key, value) in updates) {
            val exists = SiteSettings.selectAll().where { SiteSettings.key eq key }.count() > 0
            if (exists) {
                SiteSettings.update({ SiteSettings.key eq key }) {
                    it[SiteSettings.value] = value
                }
            } else {
                SiteSettings.insert {
                    it[SiteSettings.key] = key
                    it[SiteSettings.value] = value
                }
            }
        }
        true
    }
}
