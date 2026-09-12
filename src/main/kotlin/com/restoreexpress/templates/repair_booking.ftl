<#import "layout.ftl" as layout>

<@layout.mainLayout title="Book Mobile Repair" activePage="repairs" settings=settings!>
    <div class="container section">
        <div class="section-header">
            <span class="section-subtitle">Express Repair Booking</span>
            <h1 class="section-title">Book Smartphone Repair Online</h1>
            <p class="section-desc">Select your device and fault, confirm your booking, and send your device to our central lab address.</p>
        </div>

        <div class="form-container-card">
            <form action="/repair/book" method="post" class="booking-form">

                <div class="form-row">
                    <div class="form-group">
                        <label for="customer_name">Full Name / Business Name *</label>
                        <input type="text" id="customer_name" name="customer_name" placeholder="John Doe" required>
                    </div>
                    <div class="form-group">
                        <label for="email">Email Address *</label>
                        <input type="email" id="email" name="email" placeholder="john@example.com" required>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="phone">Phone Number *</label>
                        <input type="tel" id="phone" name="phone" placeholder="+44 7123 456789" required>
                    </div>
                    <div class="form-group">
                        <label for="device_model">Device Brand & Model *</label>
                        <input type="text" id="device_model" name="device_model" placeholder="e.g. Apple iPhone 15 Pro Max, Samsung Galaxy S24 Ultra" required>
                    </div>
                </div>

                <div class="form-group">
                    <label for="reported_fault">Select Fault & Service Required *</label>
                    <select id="reported_fault" name="reported_fault" class="form-control" style="width: 100%; padding: 0.6rem; border: 1px solid var(--border-grey); border-radius: 2px;" required>
                        <option value="Screen & OLED Panel Replacement (£69.00)">Screen & OLED Panel Replacement (£69.00)</option>
                        <option value="Battery Health Restoration (£39.00)">Battery Health Restoration (£39.00)</option>
                        <option value="Charging Port & USB-C/Lightning Module Repair (£35.00)">Charging Port & USB-C/Lightning Module Repair (£35.00)</option>
                        <option value="Camera Lens & Optical Sensor Repair (£45.00)">Camera Lens & Optical Sensor Repair (£45.00)</option>
                        <option value="Rear Glass Laser Removal & Replacement (£49.00)">Rear Glass Laser Removal & Replacement (£49.00)</option>
                        <option value="Full Hardware Diagnostic & Water Damage Audit (£25.00)">Full Hardware Diagnostic & Water Damage Audit (£25.00)</option>
                    </select>
                </div>

                <div class="form-actions">
                    <button type="submit" class="btn btn-primary btn-lg"><i class="fa-solid fa-calendar-check"></i> BOOK REPAIR & GET SEND-IN INSTRUCTIONS</button>
                    <a href="/" class="btn btn-outline"><i class="fa-solid fa-arrow-left"></i> Cancel</a>
                </div>
            </form>
        </div>
    </div>
</@layout.mainLayout>
