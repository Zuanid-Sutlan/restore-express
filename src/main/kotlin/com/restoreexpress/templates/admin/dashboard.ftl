<#import "../layout.ftl" as layout>

<@layout.mainLayout title="Admin Dashboard">
    <h1>Admin Dashboard</h1>
    <p>Welcome to the admin panel.</p>
    <ul>
        <li><a href="/admin/repairs">Manage Repairs</a></li>
        <li><a href="/admin/products">Manage Products</a></li>
        <li><a href="/admin/orders">Manage Orders</a></li>
        <li><a href="/admin/logout">Logout</a></li>
    </ul>
</@layout.mainLayout>
