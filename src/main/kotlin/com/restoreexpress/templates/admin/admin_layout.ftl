<#macro adminLayout title="Admin Panel" activeTab="" versionInfo={}>
<#if !versionInfo?is_hash><#assign versionInfo = {}></#if>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${title} | Restore Express Admin</title>

    <!-- Google Fonts (Poppins) -->
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&display=swap" rel="stylesheet" />

    <!-- Font Awesome 6 -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" />

    <!-- External Stylesheet -->
    <link rel="stylesheet" href="/static/css/style.css">
</head>
<body class="admin-body">
    <header class="admin-header">
        <div class="header-container">
            <div class="brand">
                <a href="/admin/dashboard" class="logo">
                    <span class="logo-icon"><i class="fa-solid fa-wrench"></i></span>
                    <span>RestoreExpress</span>
                    <span class="logo-badge">Admin</span>
                </a>
                <#if versionInfo?? && versionInfo?has_content && versionInfo.isProduction??>
                    <#if versionInfo.isProduction>
                        <span class="env-badge env-prod" title="Environment: Production"><i class="fa-solid fa-shield"></i> PROD ${(versionInfo.fullVersionTag)!''}</span>
                    <#else>
                        <span class="env-badge env-dev" title="Environment: Development"><i class="fa-solid fa-code-branch"></i> DEV ${(versionInfo.fullVersionTag)!''}</span>
                    </#if>
                </#if>
            </div>
            <nav class="admin-nav">
                <a href="/admin/dashboard" class="<#if activeTab == 'dashboard'>active</#if>"><i class="fa-solid fa-chart-line"></i> Dashboard</a>
                <a href="/admin/products" class="<#if activeTab == 'products'>active</#if>"><i class="fa-solid fa-box"></i> Products</a>
                <a href="/admin/orders" class="<#if activeTab == 'orders'>active</#if>"><i class="fa-solid fa-shopping-cart"></i> Orders</a>
                <a href="/admin/repairs" class="<#if activeTab == 'repairs'>active</#if>"><i class="fa-solid fa-screwdriver-wrench"></i> Repairs</a>
                <a href="/admin/settings" class="<#if activeTab == 'settings'>active</#if>"><i class="fa-solid fa-gear"></i> Settings</a>
                <a href="/" target="_blank" class="nav-secondary"><i class="fa-solid fa-arrow-up-right-from-square"></i> Storefront</a>
                <a href="/admin/logout" class="nav-logout"><i class="fa-solid fa-right-from-bracket"></i> Logout</a>
            </nav>
        </div>
    </header>

    <main class="admin-main">
        <#nested>
    </main>

    <footer class="admin-footer">
        <p>&copy; 2026 Restore Express Admin Panel &bull; <#if versionInfo?? && versionInfo?has_content>${versionInfo.fullVersionTag}<#else>v1.0.0-dev</#if></p>
    </footer>

    <script src="/static/js/main.js"></script>
</body>
</html>
</#macro>
