<#import "layout.ftl" as layout>

<@layout.mainLayout title=title activePage="static" settings=settings!>
    <section class="section">
        <div class="container">
            <div class="section-header">
                <span class="section-subtitle">Restore Express</span>
                <h2 class="section-title">${title}</h2>
                <p class="section-desc">We are dedicated to providing fast, reliable, and transparent mobile repair services.</p>
            </div>
            <div style="background: #ffffff; padding: 2.5rem; border-radius: 14px; border: 1px solid #eaedf2; box-shadow: 0 2px 4px rgba(0,0,0,0.04); max-width: 900px; margin: 0 auto;">
                <p>Welcome to the <strong>${title}</strong> page. Full details and guidelines are maintained here to keep you informed about our services and policies.</p>
                <br>
                <a href="/" class="btn btn-primary"><i class="fa-solid fa-arrow-left"></i> Return to Home</a>
            </div>
        </div>
    </section>
</@layout.mainLayout>
