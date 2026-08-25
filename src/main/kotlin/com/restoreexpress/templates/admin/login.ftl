<#import "../layout.ftl" as layout>

<@layout.mainLayout title="Admin Login">
    <div class="admin-login">
        <h1>Admin Login</h1>

        <#if error?? && error == "invalid">
            <p style="color: red;">Invalid email or password.</p>
        </#if>

        <form action="/admin/login" method="POST">
            <div class="form-group">
                <label for="email">Email:</label>
                <input type="email" id="email" name="email" required>
            </div>
            <div class="form-group">
                <label for="password">Password:</label>
                <input type="password" id="password" name="password" required>
            </div>
            <button type="submit">Login</button>
        </form>
    </div>
</@layout.mainLayout>
