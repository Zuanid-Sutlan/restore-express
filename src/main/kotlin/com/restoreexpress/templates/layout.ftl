<#macro mainLayout title="Restore Express">
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${title} | Restore Express</title>
    <link rel="stylesheet" href="/static/css/style.css">
</head>
<body>
    <header>
        <nav>
            <a href="/">Home</a>
            <a href="/shop">Shop</a>
            <a href="/repair/book">Book Repair</a>
            <a href="/track">Track Order</a>
        </nav>
    </header>

    <main>
        <#nested>
    </main>

    <footer>
        <p>&copy; 2026 Restore Express. <a href="/privacy">Privacy</a> | <a href="/terms">Terms</a></p>
    </footer>

    <script src="/static/js/main.js"></script>
</body>
</html>
</#macro>
