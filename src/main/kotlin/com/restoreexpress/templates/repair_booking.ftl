<#import "layout.ftl" as layout>
<@layout.mainLayout title="Book a Repair">
    <h1>Book Your Repair</h1>
    <form action="/repair/book" method="post" class="booking-form">
        <div class="form-group">
            <label for="customer_name">Full Name</label>
            <input type="text" id="customer_name" name="customer_name" required>
        </div>
        <div class="form-group">
            <label for="email">Email Address</label>
            <input type="email" id="email" name="email" required>
        </div>
        <div class="form-group">
            <label for="phone">Phone Number</label>
            <input type="tel" id="phone" name="phone" required>
        </div>
        <div class="form-group">
            <label for="device_model">Device Model</label>
            <input type="text" id="device_model" name="device_model" placeholder="e.g. iPhone 15 Pro" required>
        </div>
        <div class="form-group">
            <label for="reported_fault">Reported Fault</label>
            <textarea id="reported_fault" name="reported_fault" required></textarea>
        </div>
        <button type="submit" class="btn">Submit Booking</button>
    </form>
</@layout.mainLayout>
