<#import "components/navbar.ftl" as nav>
<#import "components/footer.ftl" as foot>

<#macro mainLayout title="Restore Express" activePage="home" settings={}>
<#if !settings?is_hash><#assign settings = {}></#if>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>${title} | Restore Express</title>

  <!-- Google Fonts (Poppins) -->
  <link rel="preconnect" href="https://fonts.googleapis.com" />
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
  <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&display=swap" rel="stylesheet" />

  <!-- Font Awesome 6 -->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" />

  <!-- Favicon / Browser Icon -->
  <link rel="icon" type="image/png" href="/static/images/ic_icon_favicon.png" />
  <link rel="shortcut icon" href="/static/images/logo-icon.png" type="image/png" />

  <!-- External Stylesheet -->
  <link rel="stylesheet" href="/static/css/style.css" />
</head>
<body>

  <@nav.navbar activePage=activePage />

  <main>
    <#nested>
  </main>

  <@foot.footerSection settings=settings />

  <!-- Floating WhatsApp Widget -->
  <#assign waNum = (settings.whatsappNumber)!'18005557378'>
  <#assign cleanWa = waNum?replace("[^0-9]", "", "r")>
  <a href="https://wa.me/${cleanWa}" target="_blank" rel="noopener noreferrer" class="whatsapp-float" aria-label="Chat with us on WhatsApp">
    <i class="fa-brands fa-whatsapp"></i>
    <span class="whatsapp-tooltip">Chat with us on WhatsApp</span>
  </a>

  <!-- External JavaScript -->
  <script src="/static/js/main.js"></script>
</body>
</html>
</#macro>
