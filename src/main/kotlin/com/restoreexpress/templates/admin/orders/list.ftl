<#import "../admin_layout.ftl" as layout>

<@layout.adminLayout title="Manage Orders" activeTab="orders">
    <div class="admin-page-header">
        <div>
            <h1>Orders Management</h1>
            <p>Track customer purchases, manage fulfillment, and update shipment tracking numbers.</p>
        </div>
    </div>

    <#if msg??>
        <div class="alert alert-success">
            <#if msg == "updated"><i class="fa-solid fa-circle-check"></i> Order status updated successfully!</#if>
            <#if msg == "not_found"><i class="fa-solid fa-circle-exclamation"></i> Order not found.</#if>
        </div>
    </#if>

    <div class="filter-bar">
        <span class="filter-label"><i class="fa-solid fa-filter"></i> Filter by Status:</span>
        <a href="/admin/orders" class="filter-chip <#if selectedStatus == ''>active</#if>">All</a>
        <#list statuses as st>
            <a href="/admin/orders?status=${st}" class="filter-chip <#if selectedStatus == st>active</#if>">${st}</a>
        </#list>
    </div>

    <div class="dashboard-card">
        <table class="admin-table">
            <thead>
                <tr>
                    <th>Order Ref</th>
                    <th>Customer Name</th>
                    <th>Email & Phone</th>
                    <th>Status</th>
                    <th>Total</th>
                    <th>Order Date</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <#list orders as o>
                    <tr>
                        <td><strong>${o.orderReference}</strong></td>
                        <td>${o.customerName}</td>
                        <td>${o.email}<br><small class="text-muted">${o.phone}</small></td>
                        <td><span class="badge badge-${o.status?lower_case}">${o.status}</span></td>
                        <td><strong>£${(o.totalPence / 100)?string["0.00"]}</strong></td>
                        <td><small>${o.createdAt}</small></td>
                        <td>
                            <a href="/admin/orders/${o.id}" class="btn-sm"><i class="fa-solid fa-eye"></i> Details</a>
                        </td>
                    </tr>
                <#else>
                    <tr>
                        <td colspan="7" class="empty-state">No orders found matching status filter "${selectedStatus!}".</td>
                    </tr>
                </#list>
            </tbody>
        </table>
    </div>
</@layout.adminLayout>
