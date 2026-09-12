package com.restoreexpress.models

import org.jetbrains.exposed.sql.Table

object SiteSettings : Table("site_settings") {
    val key = varchar("key", 100)
    val value = text("value")
    override val primaryKey = PrimaryKey(key)
}

data class SiteSettingsData(
    val whatsappNumber: String = "18005557378",
    val facebookUrl: String = "https://facebook.com/restoreexpress",
    val instagramUrl: String = "https://instagram.com/restoreexpress",
    val youtubeUrl: String = "https://youtube.com/restoreexpress",
    val twitterUrl: String = "https://x.com/restoreexpress",
    val phoneNumber: String = "+1 (800) 555-RESTORE",
    val supportEmail: String = "support@restoreexpress.com",
    val deliveryAddress: String = "Restore Express Central Repair Lab\nAttn: Inbound Service Dept (Job Ref: {REF})\n120 Tech Boulevard, Suite 400\nCentral City, UK, CC 90210"
)
