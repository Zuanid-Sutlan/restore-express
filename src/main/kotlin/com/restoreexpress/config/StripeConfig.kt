package com.restoreexpress.config

import com.stripe.Stripe

object StripeConfig {
    lateinit var secretKey: String
    lateinit var webhookSecret: String

    fun init(key: String, webhook: String) {
        secretKey = key
        webhookSecret = webhook
        Stripe.apiKey = secretKey
    }
}
