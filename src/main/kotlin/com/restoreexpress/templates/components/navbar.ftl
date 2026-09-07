<#macro navbar activePage="home">
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
          <li><a href="/how-it-works" class="nav-link <#if activePage == "how-it-works">active</#if>">How It Works</a></li>
          <li><a href="/repairs" class="nav-link <#if activePage == "repairs">active</#if>">Repairs</a></li>
          <li><a href="/shop" class="nav-link <#if activePage == "shop">active</#if>">Shop</a></li>
          <li><a href="/track" class="nav-link <#if activePage == "track">active</#if>">Track Repair</a></li>
          <li><a href="/contact" class="nav-link <#if activePage == "contact">active</#if>">Contact</a></li>
          <li><a href="/admin/login" class="nav-link login-link"><i class="fa-regular fa-user"></i> Login</a></li>
        </ul>
      </nav>

      <!-- Action Button & Hamburger -->
      <div class="nav-actions">
        <a href="/repair/book" class="btn btn-primary nav-cta">Book Repair</a>
        <button class="menu-toggle" id="menu-toggle" aria-label="Toggle navigation">
          <i class="fa-solid fa-bars"></i>
        </button>
      </div>
    </div>
  </header>
</#macro>
