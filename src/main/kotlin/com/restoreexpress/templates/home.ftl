<#import "layout.ftl" as layout>

<@layout.mainLayout title="Fast Mobile Phone Repairs & Devices Store" activePage="home" settings=settings!>

  <!-- Hero Section -->
  <section class="hero-auction">
    <div class="container hero-container">
      <div class="hero-content">
        <div class="hero-badge">
          <i class="fa-solid fa-bolt text-red"></i> Express Mobile Repairs & E-Commerce Store
        </div>
        <h1 class="hero-title">
          Fast <span class="highlight">Mobile Phone Repairs</span> & Certified Device Store
        </h1>
        <p class="hero-desc">
          Book your smartphone repair online with instant quote, or shop brand new, grade-A refurbished, and pre-owned smartphones and mobile accessories.
        </p>

        <!-- Main Action Buttons -->
        <div class="hero-search-box" style="margin-bottom: 1.5rem;">
          <a href="/repair/book" class="btn btn-primary btn-lg">
            <i class="fa-solid fa-screwdriver-wrench"></i> Book Repair Online
          </a>
          <a href="/shop" class="btn btn-outline btn-lg">
            <i class="fa-solid fa-mobile-screen"></i> Browse Mobiles & Accessories
          </a>
          <a href="/track" class="btn btn-outline btn-lg">
            <i class="fa-solid fa-magnifying-glass"></i> Track Repair Job
          </a>
        </div>

        <div class="hero-category-shortcuts">
          <span class="shortcuts-label">Store Categories:</span>
          <a href="/shop?cat=Mobiles" class="shortcut-chip">Smartphones</a>
          <a href="/shop?cat=Accessories" class="shortcut-chip">Accessories</a>
          <a href="/shop?condition=NEW" class="shortcut-chip">Brand New</a>
          <a href="/shop?condition=REFURBISHED_A" class="shortcut-chip">Refurbished (Grade A)</a>
          <a href="/shop?condition=USED" class="shortcut-chip">Pre-Owned / Used</a>
        </div>

        <div class="hero-stats-row">
          <div class="stat-cell">
            <span class="stat-value text-red">50,000+</span>
            <span class="stat-label">Devices Repaired</span>
          </div>
          <div class="stat-divider"></div>
          <div class="stat-cell">
            <span class="stat-value">24-48h</span>
            <span class="stat-label">Avg Turnaround</span>
          </div>
          <div class="stat-divider"></div>
          <div class="stat-cell">
            <span class="stat-value">12 Months</span>
            <span class="stat-label">Warranty</span>
          </div>
          <div class="stat-divider"></div>
          <div class="stat-cell">
            <span class="stat-value">100%</span>
            <span class="stat-label">Quality Guaranteed</span>
          </div>
        </div>
      </div>

      <!-- Hero Visual Card -->
      <div class="hero-visual">
        <div class="featured-lot-spotlight">
          <div class="spotlight-header">
            <span class="spotlight-badge"><i class="fa-solid fa-screwdriver-wrench text-red"></i> REPAIR BOOKING & TRACKING</span>
          </div>
          <div class="spotlight-img-wrap">
            <img src="https://images.unsplash.com/photo-1592899677977-9c10ca588bbd?w=600&auto=format&fit=crop&q=80"
                 alt="Mobile Phone Repair" class="spotlight-img" />
          </div>
          <div class="spotlight-body">
            <h3 class="spotlight-title">Instant Online Repair Booking</h3>
            <p style="font-size: 0.85rem; color: var(--text-muted); margin-bottom: 0.8rem;">
              Select your device fault, get upfront pricing, confirm your booking, and send your device to our lab address.
            </p>
            <a href="/repair/book" class="btn btn-primary btn-block">
              <i class="fa-solid fa-screwdriver-wrench"></i> Start Repair Booking
            </a>
          </div>
        </div>
      </div>
    </div>
  </section>

  <!-- Popular Repair Services Section -->
  <section class="section">
    <div class="container">
      <div class="section-header">
        <span class="section-subtitle">Certified Hardware Labs</span>
        <h2 class="section-title">Popular Mobile Phone Repair Services</h2>
        <p class="section-desc">Upfront transparent pricing, OEM parts, and 12-month warranty on every repair.</p>
      </div>

      <div class="process-grid">
        <div class="feature-card">
          <div class="feature-icon"><i class="fa-solid fa-mobile-screen-button"></i></div>
          <h3>Screen & OLED Replacement</h3>
          <p>Fix cracked glass, unresponsive touch digitizers, and bleeding OLED/LCD panels with genuine spec screens.</p>
          <div class="repair-card-footer">
            <span class="text-red"><strong>From £39.00</strong></span>
            <a href="/repair/book" class="btn btn-sm btn-primary">Book Now</a>
          </div>
        </div>

        <div class="feature-card">
          <div class="feature-icon"><i class="fa-solid fa-battery-full"></i></div>
          <h3>Battery Health Restoration</h3>
          <p>Restore full-day battery life with brand-new high-capacity, zero-cycle battery cells.</p>
          <div class="repair-card-footer">
            <span class="text-red"><strong>From £29.00</strong></span>
            <a href="/repair/book" class="btn btn-sm btn-primary">Book Now</a>
          </div>
        </div>

        <div class="feature-card">
          <div class="feature-icon"><i class="fa-solid fa-plug"></i></div>
          <h3>Charging Port & IC Repair</h3>
          <p>Resolve loose cables, slow charging, dust blockage, or failed USB-C/Lightning charging ports.</p>
          <div class="repair-card-footer">
            <span class="text-red"><strong>From £34.00</strong></span>
            <a href="/repair/book" class="btn btn-sm btn-primary">Book Now</a>
          </div>
        </div>

        <div class="feature-card">
          <div class="feature-icon"><i class="fa-solid fa-camera"></i></div>
          <h3>Camera Lens & Sensor Repair</h3>
          <p>Clear blurry shots, replace cracked camera lens glass, and calibrate optical stabilization.</p>
          <div class="repair-card-footer">
            <span class="text-red"><strong>From £45.00</strong></span>
            <a href="/repair/book" class="btn btn-sm btn-primary">Book Now</a>
          </div>
        </div>
      </div>
    </div>
  </section>

  <!-- Store Catalog Section -->
  <section class="section bg-light">
    <div class="container">
      <div class="section-header">
        <span class="section-subtitle">Store Catalog</span>
        <h2 class="section-title">Featured Mobiles & Mobile Accessories</h2>
        <p class="section-desc">Brand new, grade-A refurbished, and pre-owned smartphones and essential mobile accessories.</p>
      </div>

      <div class="auction-grid">
        <#if products?has_content>
          <#list products as product>
            <#assign pricePounds = (product.pricePence / 100)?string["0.00"]>
            <article class="auction-card">
              <div class="lot-thumb-wrap">
                <a href="/shop/${product.slug}" class="thumb-link">
                  <#if product.images?has_content>
                    <img src="${product.images[0].url}" alt="${product.modelName}" class="lot-thumb-img" loading="lazy" />
                  <#else>
                    <img src="https://images.unsplash.com/photo-1592899677977-9c10ca588bbd?w=600&auto=format&fit=crop&q=80"
                         alt="${product.modelName}" class="lot-thumb-img" loading="lazy" />
                  </#if>
                </a>

                <!-- Product Condition Badge -->
                <span class="lot-status-badge live">
                  <#if product.condition == 'NEW'>Brand New
                  <#elseif product.condition == 'REFURBISHED_A'>Refurbished (Grade A)
                  <#elseif product.condition == 'REFURBISHED_B'>Refurbished (Grade B)
                  <#else>Pre-Owned / Used</#if>
                </span>
              </div>

              <div class="lot-card-body">
                <h3 class="lot-title">
                  <a href="/shop/${product.slug}">${product.brand} ${product.modelName}</a>
                </h3>

                <div class="lot-meta-row">
                  <span class="lot-region-badge"><i class="fa-solid fa-tag text-red"></i> ${product.condition}</span>
                  <span class="lot-bids-count">In Stock (${product.stockQuantity})</span>
                </div>

                <div class="bid-time-row">
                  <div class="bid-col">
                    <span class="bid-label">Price</span>
                    <span class="bid-amount text-red">£${pricePounds}</span>
                  </div>
                  <div class="time-col">
                    <span class="time-label">Status</span>
                    <span class="time-value" style="font-size: 0.75rem;"><i class="fa-solid fa-check text-success"></i> Verified Stock</span>
                  </div>
                </div>

                <div class="lot-card-actions">
                  <a href="/shop/${product.slug}" class="btn btn-primary btn-block btn-bid-action">
                    <i class="fa-solid fa-cart-shopping"></i> View & Buy Now
                  </a>
                </div>
              </div>
            </article>
          </#list>
        </#if>
      </div>

      <div style="text-align: center; margin-top: 2rem;">
        <a href="/shop" class="btn btn-outline btn-lg">
          <i class="fa-solid fa-store"></i> View All Mobiles & Accessories
        </a>
      </div>
    </div>
  </section>

  <!-- How Mail-In Repair Works -->
  <section class="section">
    <div class="container">
      <div class="section-header">
        <span class="section-subtitle">Simple 4-Stage Repair Flow</span>
        <h2 class="section-title">How Postal Repair Booking Works</h2>
        <p class="section-desc">Transparent step-by-step process from booking to final device return dispatch.</p>
      </div>

      <div class="process-grid">
        <div class="process-card">
          <div class="step-badge">1</div>
          <div class="process-icon"><i class="fa-solid fa-calendar-check"></i></div>
          <h3>1. Book Online</h3>
          <p>Select your fault, get instant quote, and complete booking.</p>
        </div>

        <div class="process-card">
          <div class="step-badge">2</div>
          <div class="process-icon"><i class="fa-solid fa-location-dot"></i></div>
          <h3>2. Receive Send-In Address</h3>
          <p>Get your unique Job Reference and the lab Delivery Address to ship your device.</p>
        </div>

        <div class="process-card">
          <div class="step-badge">3</div>
          <div class="process-icon"><i class="fa-solid fa-box"></i></div>
          <h3>3. Device Received</h3>
          <p>Our lab receives your parcel, logs intake inspection, and notifies you immediately.</p>
        </div>

        <div class="process-card">
          <div class="step-badge">4</div>
          <div class="process-icon"><i class="fa-solid fa-truck-fast"></i></div>
          <h3>4. Repair & Dispatched</h3>
          <p>Engineers repair, quality test, and dispatch your device right back via insured courier.</p>
        </div>
      </div>
    </div>
  </section>

</@layout.mainLayout>
