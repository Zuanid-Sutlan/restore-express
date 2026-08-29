<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Admin Login | Restore Express</title>

  <!-- Google Fonts (Poppins) -->
  <link rel="preconnect" href="https://fonts.googleapis.com" />
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
  <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&display=swap" rel="stylesheet" />

  <!-- Font Awesome 6 -->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" />

  <!-- External Stylesheet -->
  <link rel="stylesheet" href="/static/css/style.css" />
</head>
<body class="admin-login-body">

  <div class="admin-login-wrapper">
    <div class="admin-login-card">
      <div class="login-brand">
        <a href="/" class="logo">
          <span class="logo-icon"><i class="fa-solid fa-wrench"></i></span>
          <span class="logo-text">Restore<span class="highlight">Express</span></span>
        </a>
        <h2>Admin Portal</h2>
        <p>Sign in to manage inventory, orders, repairs, and site settings.</p>
      </div>

      <#if error?? && error == "invalid">
        <div class="alert alert-danger" style="margin-bottom: 1.5rem;">
          <i class="fa-solid fa-circle-exclamation"></i> Invalid email address or password.
        </div>
      </#if>

      <form action="/admin/login" method="POST" class="admin-form">
        <div class="form-group">
          <label for="email"><i class="fa-solid fa-envelope"></i> Email Address</label>
          <input type="email" id="email" name="email" placeholder="admin@restoreexpress.com" required autofocus>
        </div>

        <div class="form-group">
          <label for="password"><i class="fa-solid fa-lock"></i> Password</label>
          <input type="password" id="password" name="password" placeholder="••••••••" required>
        </div>

        <button type="submit" class="btn btn-primary btn-block">
          <i class="fa-solid fa-right-to-bracket"></i> Secure Sign In
        </button>
      </form>

      <div class="login-footer">
        <a href="/"><i class="fa-solid fa-arrow-left"></i> Return to Storefront</a>
      </div>
    </div>
  </div>

</body>
</html>
