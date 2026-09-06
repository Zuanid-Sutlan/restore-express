<#macro footerSection settings={}>
  <#if !settings?is_hash><#assign settings = {}></#if>
  <footer class="footer">
    <div class="container">
      <div class="footer-top">
        <!-- Brand Col -->
        <div class="footer-col brand-col">
          <a href="/" class="footer-logo">
            <img src="/static/images/logo-icon.png" alt="RestoreExpress Logo" class="brand-logo-img"> Restore<span class="highlight">Express</span>
          </a>
          <p class="footer-about">
            Your premier nationwide postal and express mobile repair destination. We deliver OEM-grade quality, quick
            turnaround times, and verified customer trust.
          </p>
          <div class="social-links">
            <a href="${(settings.facebookUrl)!'#'}" target="_blank" rel="noopener" aria-label="Facebook"><i class="fa-brands fa-facebook-f"></i></a>
            <a href="${(settings.instagramUrl)!'#'}" target="_blank" rel="noopener" aria-label="Instagram"><i class="fa-brands fa-instagram"></i></a>
            <a href="${(settings.twitterUrl)!'#'}" target="_blank" rel="noopener" aria-label="X Twitter"><i class="fa-brands fa-x-twitter"></i></a>
            <a href="${(settings.youtubeUrl)!'#'}" target="_blank" rel="noopener" aria-label="YouTube"><i class="fa-brands fa-youtube"></i></a>
          </div>
        </div>

        <!-- Quick Links -->
        <div class="footer-col">
          <h4>Quick Links</h4>
          <ul class="footer-links">
            <li><a href="/"><i class="fa-solid fa-angle-right"></i> Home</a></li>
            <li><a href="/how-it-works"><i class="fa-solid fa-angle-right"></i> How It Works</a></li>
            <li><a href="/why-choose-us"><i class="fa-solid fa-angle-right"></i> Why Choose Us</a></li>
            <li><a href="/track"><i class="fa-solid fa-angle-right"></i> Repair Tracker</a></li>
            <li><a href="/shop"><i class="fa-solid fa-angle-right"></i> Accessories Shop</a></li>
            <li><a href="/reviews"><i class="fa-solid fa-angle-right"></i> Customer Reviews</a></li>
          </ul>
        </div>

        <!-- Services -->
        <div class="footer-col">
          <h4>Services</h4>
          <ul class="footer-links">
            <li><a href="/repairs"><i class="fa-solid fa-angle-right"></i> Screen Replacement</a></li>
            <li><a href="/repairs"><i class="fa-solid fa-angle-right"></i> Battery Health Restoration</a></li>
            <li><a href="/repairs"><i class="fa-solid fa-angle-right"></i> Port & Mic Repair</a></li>
            <li><a href="/repairs"><i class="fa-solid fa-angle-right"></i> Rear Glass Laser Work</a></li>
            <li><a href="/turnaround"><i class="fa-solid fa-angle-right"></i> Turnaround Schedule</a></li>
            <li><a href="/postage"><i class="fa-solid fa-angle-right"></i> Post Your Phone Guide</a></li>
          </ul>
        </div>

        <!-- Contact Info & Legal -->
        <div class="footer-col">
          <h4>Contact Us</h4>
          <ul class="contact-info">
            <li>
              <i class="fa-solid fa-phone"></i>
              <span>${(settings.phoneNumber)!'+1 (800) 555-RESTORE'}<br><small>Mon - Sat: 8:00 AM - 7:00 PM</small></span>
            </li>
            <li>
              <i class="fa-solid fa-envelope"></i>
              <span>${(settings.supportEmail)!'support@restoreexpress.com'}</span>
            </li>
            <li>
              <i class="fa-solid fa-location-dot"></i>
              <span>120 Tech Boulevard, Suite 400<br>Central City, USA</span>
            </li>
          </ul>
        </div>
      </div>

      <!-- Footer Bottom -->
      <div class="footer-bottom">
        <p>&copy; 2026 Restore Express. All Rights Reserved.</p>
        <div class="legal-links">
          <a href="/terms">Terms & Conditions</a>
          <a href="/privacy">Privacy Policy</a>
          <a href="/warranty">Warranty</a>
          <a href="/returns-refunds">Returns & Refunds</a>
          <a href="/security">Security & Trust</a>
        </div>
      </div>
    </div>
  </footer>
</#macro>
