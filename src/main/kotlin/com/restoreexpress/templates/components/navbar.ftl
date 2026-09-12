<#macro navbar activePage="home" settings={}>
  <#if !settings?is_hash><#assign settings = {}></#if>
  <!-- Top Utility Bar with Contact Info from Admin DB -->
  <div class="utility-bar">
    <div class="container utility-container">
      <div class="utility-left">
        <span class="utility-item"><i class="fa-solid fa-phone text-red"></i> ${(settings.phoneNumber)!'+1 (800) 555-RESTORE'}</span>
        <span class="utility-item"><i class="fa-solid fa-envelope text-red"></i> ${(settings.supportEmail)!'support@restoreexpress.com'}</span>
        <span class="utility-item"><i class="fa-solid fa-shield-halved text-red"></i> 12-Month Repair & Product Warranty</span>
      </div>
      <div class="utility-right">
        <a href="/track" class="utility-link"><i class="fa-solid fa-magnifying-glass"></i> Track Repair Job</a>
        <a href="/contact" class="utility-link"><i class="fa-regular fa-circle-question"></i> Help & FAQ</a>
      </div>
    </div>
  </div>

  <!-- Primary Header Navigation -->
  <header class="header" id="header">
    <div class="container nav-container">
      <a href="/" class="logo">
        <span class="logo-icon"><img src="/static/images/ic_icon_favicon.png" alt="RestoreExpress Logo" class="brand-logo-img"></span>
        <span class="logo-text">Restore<span class="highlight">Express</span></span>
      </a>

      <!-- Desktop Nav -->
      <nav class="navbar" id="navbar">
        <ul class="nav-links">
          <li><a href="/" class="nav-link <#if activePage == "home">active</#if>">Home</a></li>
          <li><a href="/shop?cat=Mobiles" class="nav-link">Mobiles & Tablets</a></li>
          <li><a href="/shop?cat=Accessories" class="nav-link">Accessories</a></li>
          <li><a href="/shop" class="nav-link <#if activePage == "shop">active</#if>">Store Catalog</a></li>
          <li><a href="/repairs" class="nav-link <#if activePage == "repairs">active</#if>">Repair Services</a></li>
          <li><a href="/track" class="nav-link <#if activePage == "track">active</#if>">Track Repair</a></li>
        </ul>
      </nav>

      <!-- Action Buttons -->
      <div class="nav-actions">
        <a href="/repair/book" class="btn btn-primary nav-cta">
          <i class="fa-solid fa-screwdriver-wrench"></i> Book Repair
        </a>
        <button class="menu-toggle" id="menu-toggle" aria-label="Toggle navigation">
          <i class="fa-solid fa-bars"></i>
        </button>
      </div>
    </div>
  </header>
</#macro>
