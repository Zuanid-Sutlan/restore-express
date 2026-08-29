package com.restoreexpress.services

import com.restoreexpress.config.StripeConfig
import com.stripe.model.PaymentIntent
import com.stripe.net.Webhook
import com.stripe.param.PaymentIntentCreateParams

class StripeService {
    fun createPaymentIntent(amountPence: Long, metadata: Map<String, String>): PaymentIntent {
        val params = PaymentIntentCreateParams.builder()
            .setAmount(amountPence)
            .setCurrency("gbp")
            .putAllMetadata(metadata)
            .build()
        return PaymentIntent.create(params)
    }

    fun verifyWebhook(payload: String, signature: String): com.stripe.model.Event? {
        return try {
            Webhook.constructEvent(payload, signature, StripeConfig.webhookSecret)
        } catch (e: Exception) {
            null
        }
    }
}
