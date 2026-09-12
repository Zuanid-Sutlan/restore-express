<#macro footerSection settings={}>
  <#if !settings?is_hash><#assign settings = {}></#if>
  <footer class="footer">
    <div class="container">
      <div class="footer-top">
        <!-- Brand & Overview -->
        <div class="footer-col brand-col">
          <a href="/" class="footer-logo">
            <img src="/static/images/logo-icon.png" alt="Restore Express Logo" class="brand-logo-img">
            Restore<span class="highlight">Express</span>
          </a>
          <p class="footer-about">
            Your premier nationwide postal and express mobile phone repair lab and certified device & accessories store. High-grade OEM components, certified diagnostic testing, and express turnaround.
          </p>

          <div class="social-links">
            <a href="${(settings.facebookUrl)!'#'}" target="_blank" rel="noopener" aria-label="Facebook"><i class="fa-brands fa-facebook-f"></i></a>
            <a href="${(settings.instagramUrl)!'#'}" target="_blank" rel="noopener" aria-label="Instagram"><i class="fa-brands fa-instagram"></i></a>
            <a href="${(settings.twitterUrl)!'#'}" target="_blank" rel="noopener" aria-label="X Twitter"><i class="fa-brands fa-x-twitter"></i></a>
            <a href="${(settings.youtubeUrl)!'#'}" target="_blank" rel="noopener" aria-label="YouTube"><i class="fa-brands fa-youtube"></i></a>
          </div>
        </div>

        <!-- Store Categories -->
        <div class="footer-col">
          <h4>Store Catalog</h4>
          <ul class="footer-links">
            <li><a href="/shop?cat=Mobiles"><i class="fa-solid fa-angle-right"></i> Mobile Phones</a></li>
            <li><a href="/shop?cat=Tablets"><i class="fa-solid fa-angle-right"></i> Tablets & iPads</a></li>
            <li><a href="/shop?cat=Cases"><i class="fa-solid fa-angle-right"></i> Protective Cases & Covers</a></li>
            <li><a href="/shop?cat=Chargers"><i class="fa-solid fa-angle-right"></i> Fast Chargers & Cables</a></li>
            <li><a href="/shop?cat=Audio"><i class="fa-solid fa-angle-right"></i> Wireless Audio & Headphones</a></li>
            <li><a href="/shop?cat=Parts"><i class="fa-solid fa-angle-right"></i> OEM Replacement Components</a></li>
          </ul>
        </div>

        <!-- Repair Services -->
        <div class="footer-col">
          <h4>Repair Services</h4>
          <ul class="footer-links">
            <li><a href="/repair/book"><i class="fa-solid fa-angle-right"></i> Book Repair Online</a></li>
            <li><a href="/track"><i class="fa-solid fa-angle-right"></i> Live Repair Job Tracker</a></li>
            <li><a href="/repairs"><i class="fa-solid fa-angle-right"></i> Screen Replacement</a></li>
            <li><a href="/repairs"><i class="fa-solid fa-angle-right"></i> Battery Restoration</a></li>
            <li><a href="/repairs"><i class="fa-solid fa-angle-right"></i> Charging Port & IC Work</a></li>
            <li><a href="/postage"><i class="fa-solid fa-angle-right"></i> Device Post-In Instructions</a></li>
          </ul>
        </div>

        <!-- Device Send-In Address Managed from Admin -->
        <div class="footer-col">
          <h4>Device Send-In Address</h4>
          <ul class="contact-info">
            <li>
              <i class="fa-solid fa-truck-ramp-box text-red"></i>
              <span><strong>Send Your Device To:</strong><br>
              <address style="font-style: normal; white-space: pre-line; margin-top: 0.2rem; color: #d1d5db;">${(settings.deliveryAddress)!'Restore Express Central Repair Lab\n120 Tech Boulevard, Suite 400\nCentral City, UK, CC 90210'}</address>
              </span>
            </li>
            <li>
              <i class="fa-solid fa-headset text-red"></i>
              <span>${(settings.phoneNumber)!'+1 (800) 555-RESTORE'}</span>
            </li>
            <li>
              <i class="fa-solid fa-envelope text-red"></i>
              <span>${(settings.supportEmail)!'support@restoreexpress.com'}</span>
            </li>
          </ul>
        </div>
      </div>

      <!-- Footer Bottom -->
      <div class="footer-bottom">
        <p>&copy; 2026 Restore Express Ltd. All Rights Reserved.</p>
        <div class="legal-links">
          <a href="/terms">Terms & Conditions</a>
          <a href="/privacy">Privacy Policy</a>
          <a href="/warranty">12-Month Warranty</a>
          <a href="/returns-refunds">Returns Policy</a>
          <a href="/security">Security Guarantee</a>
        </div>
      </div>
    </div>
  </footer>
</#macro>
