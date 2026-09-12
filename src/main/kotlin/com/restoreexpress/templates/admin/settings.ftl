<#import "admin_layout.ftl" as layout>

<@layout.adminLayout title="Site Settings" activeTab="settings">
    <div class="admin-page-header">
        <div>
            <h1>Site Settings & Delivery Address</h1>
            <p>Manage floating WhatsApp number, Device Send-In Delivery Address, contact details, and social platform links.</p>
        </div>
    </div>

    <#if msg??>
        <div class="alert alert-success">
            <#if msg == "saved"><i class="fa-solid fa-circle-check"></i> Settings updated successfully!</#if>
        </div>
    </#if>

    <div class="admin-form-container">
        <form action="/admin/settings" method="POST" class="admin-form">
            <!-- Delivery Address Section -->
            <h2 style="font-size: 1.2rem; font-weight: 700; margin-bottom: 1.2rem; color: var(--primary-red); display: flex; align-items: center; gap: 0.5rem;">
                <i class="fa-solid fa-truck-ramp-box"></i> Device Send-In Delivery Address (Managed from Admin)
            </h2>

            <div class="form-group">
                <label for="deliveryAddress"><i class="fa-solid fa-location-dot"></i> Official Device Send-In / Delivery Address *</label>
                <textarea id="deliveryAddress" name="deliveryAddress" rows="4" placeholder="Restore Express Central Repair Lab&#10;Attn: Inbound Repair Dept&#10;120 Tech Boulevard, Suite 400&#10;Central City, UK" required>${settings.deliveryAddress!''}</textarea>
                <small class="form-hint">This exact address is displayed to customers after they book a repair, telling them where to ship/post their mobile device.</small>
            </div>

            <hr style="margin: 2rem 0; border: none; border-top: 1px solid var(--border-color);">

            <h2 style="font-size: 1.2rem; font-weight: 700; margin-bottom: 1.2rem; color: var(--text-dark); display: flex; align-items: center; gap: 0.5rem;">
                <i class="fa-brands fa-whatsapp"></i> WhatsApp Widget Settings
            </h2>

            <div class="form-group">
                <label for="whatsappNumber"><i class="fa-brands fa-whatsapp"></i> WhatsApp Chat Phone Number *</label>
                <input type="text" id="whatsappNumber" name="whatsappNumber" value="${settings.whatsappNumber!''}" placeholder="e.g. 18005557378 or +18005557378" required>
                <small class="form-hint">This number controls the floating WhatsApp widget in the bottom-right corner of all storefront pages.</small>
            </div>

            <hr style="margin: 2rem 0; border: none; border-top: 1px solid var(--border-color);">

            <h2 style="font-size: 1.2rem; font-weight: 700; margin-bottom: 1.2rem; color: var(--text-dark); display: flex; align-items: center; gap: 0.5rem;">
                <i class="fa-solid fa-share-nodes"></i> Social Media Platform Links
            </h2>

            <div class="form-row">
                <div class="form-group">
                    <label for="facebookUrl"><i class="fa-brands fa-facebook-f"></i> Facebook Page URL</label>
                    <input type="url" id="facebookUrl" name="facebookUrl" value="${settings.facebookUrl!''}" placeholder="https://facebook.com/yourpage">
                </div>
                <div class="form-group">
                    <label for="instagramUrl"><i class="fa-brands fa-instagram"></i> Instagram Profile URL</label>
                    <input type="url" id="instagramUrl" name="instagramUrl" value="${settings.instagramUrl!''}" placeholder="https://instagram.com/yourprofile">
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label for="youtubeUrl"><i class="fa-brands fa-youtube"></i> YouTube Channel URL</label>
                    <input type="url" id="youtubeUrl" name="youtubeUrl" value="${settings.youtubeUrl!''}" placeholder="https://youtube.com/@yourchannel">
                </div>
                <div class="form-group">
                    <label for="twitterUrl"><i class="fa-brands fa-x-twitter"></i> X / Twitter Profile URL</label>
                    <input type="url" id="twitterUrl" name="twitterUrl" value="${settings.twitterUrl!''}" placeholder="https://x.com/yourprofile">
                </div>
            </div>

            <hr style="margin: 2rem 0; border: none; border-top: 1px solid var(--border-color);">

            <h2 style="font-size: 1.2rem; font-weight: 700; margin-bottom: 1.2rem; color: var(--text-dark); display: flex; align-items: center; gap: 0.5rem;">
                <i class="fa-solid fa-headset"></i> Storefront Contact Info
            </h2>

            <div class="form-row">
                <div class="form-group">
                    <label for="phoneNumber"><i class="fa-solid fa-phone"></i> Customer Support Phone</label>
                    <input type="text" id="phoneNumber" name="phoneNumber" value="${settings.phoneNumber!''}" placeholder="+1 (800) 555-RESTORE">
                </div>
                <div class="form-group">
                    <label for="supportEmail"><i class="fa-solid fa-envelope"></i> Support Email Address</label>
                    <input type="email" id="supportEmail" name="supportEmail" value="${settings.supportEmail!''}" placeholder="support@restoreexpress.com">
                </div>
            </div>

            <div class="form-actions">
                <button type="submit" class="btn btn-primary"><i class="fa-solid fa-floppy-disk"></i> Save Settings</button>
            </div>
        </form>
    </div>
</@layout.adminLayout>
