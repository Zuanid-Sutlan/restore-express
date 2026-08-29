<#import "admin_layout.ftl" as layout>

<@layout.adminLayout title="Dashboard" activeTab="dashboard" versionInfo=versionInfo!>
    <div class="admin-page-header">
        <div>
            <h1>Dashboard Overview</h1>
            <p>Welcome back! Here is what's happening in your shop and repair operations.</p>
        </div>
        <div class="header-actions">
            <a href="/admin/products/new" class="btn btn-primary"><i class="fa-solid fa-plus"></i> Add New Product</a>
        </div>
    </div>

    <#if versionInfo?? && versionInfo?has_content && versionInfo.isProduction??>
        <div class="dashboard-card" style="padding: 1.2rem 1.8rem; margin-bottom: 2rem; background: var(--bg-light); border-left: 4px solid <#if versionInfo.isProduction>#059669<#else>#d97706</#if>;">
            <div style="display: flex; align-items: center; justify-content: space-between; flex-wrap: wrap; gap: 1rem;">
                <div>
                    <strong><i class="fa-solid fa-server"></i> System Environment:</strong>
                    <#if versionInfo.isProduction>
                        <span class="badge badge-success">Production (main)</span>
                    <#else>
                        <span class="badge badge-warning">Development (develop)</span>
                    </#if>
                    <span style="margin-left: 1rem; color: var(--text-muted); font-size: 0.9rem;">
                        Version: <code>${(versionInfo.fullVersionTag)!''}</code>
                    </span>
                </div>
                <div>
                    <a href="/api/version" target="_blank" class="btn-sm"><i class="fa-solid fa-code"></i> API Version JSON</a>
                    <a href="/api/health" target="_blank" class="btn-sm"><i class="fa-solid fa-heart-pulse"></i> Health Status</a>
                </div>
            </div>
        </div>
    </#if>

    <div class="stats-grid">
        <div class="stat-card">
            <div class="stat-icon icon-products">&#128268;</div>
            <div class="stat-content">
                <span class="stat-value">${stats.activeProducts} / ${stats.totalProducts}</span>
                <span class="stat-label">Active / Total Products</span>
            </div>
        </div>
        <div class="stat-card">
            <div class="stat-icon icon-orders">&#128722;</div>
            <div class="stat-content">
                <span class="stat-value">${stats.pendingOrders}</span>
                <span class="stat-label">Pending Orders (${stats.totalOrders} total)</span>
            </div>
        </div>
        <div class="stat-card">
            <div class="stat-icon icon-repairs">&#128295;</div>
            <div class="stat-content">
                <span class="stat-value">${stats.activeRepairs}</span>
                <span class="stat-label">Active Repairs (${stats.totalRepairs} total)</span>
            </div>
        </div>
    </div>

    <div class="dashboard-sections">
        <div class="dashboard-card">
            <div class="card-header">
                <h2>Recent Orders</h2>
                <a href="/admin/orders" class="link-btn">View All Orders &rarr;</a>
            </div>
            <table class="admin-table">
                <thead>
                    <tr>
                        <th>Order Ref</th>
                        <th>Customer</th>
                        <th>Status</th>
                        <th>Total</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <#list stats.recentOrders as order>
                        <tr>
                            <td><strong>${order.orderReference}</strong></td>
                            <td>${order.customerName}<br><small>${order.email}</small></td>
                            <td><span class="badge badge-${order.status?lower_case}">${order.status}</span></td>
                            <td>£${(order.totalPence / 100)?string["0.00"]}</td>
                            <td><a href="/admin/orders/${order.id}" class="btn-sm">Details</a></td>
                        </tr>
                    <#else>
                        <tr>
                            <td colspan="5" class="empty-state">No orders received yet.</td>
                        </tr>
                    </#list>
                </tbody>
            </table>
        </div>

        <div class="dashboard-card">
            <div class="card-header">
                <h2>Recent Repairs</h2>
                <a href="/admin/repairs" class="link-btn">View All Repairs &rarr;</a>
            </div>
            <table class="admin-table">
                <thead>
                    <tr>
                        <th>Reference</th>
                        <th>Customer</th>
                        <th>Device</th>
                        <th>Status</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <#list stats.recentRepairs as repair>
                        <tr>
                            <td><strong>${repair.referenceCode}</strong></td>
                            <td>${repair.customerName}<br><small>${repair.phone}</small></td>
                            <td>${repair.deviceModel}</td>
                            <td><span class="badge badge-${repair.status?lower_case}">${repair.status}</span></td>
                            <td><a href="/admin/repairs/${repair.id}" class="btn-sm">Details</a></td>
                        </tr>
                    <#else>
                        <tr>
                            <td colspan="5" class="empty-state">No repair bookings yet.</td>
                        </tr>
                    </#list>
                </tbody>
            </table>
        </div>
    </div>
</@layout.adminLayout>
