<#import "../admin_layout.ftl" as layout>

<@layout.adminLayout title="Manage Repairs" activeTab="repairs">
    <div class="admin-page-header">
        <div>
            <h1>Repair Jobs Management</h1>
            <p>Track incoming device repairs, technician notes, quotes, and repair progression.</p>
        </div>
    </div>

    <#if msg??>
        <div class="alert alert-success">
            <#if msg == "updated"><i class="fa-solid fa-circle-check"></i> Repair status and note updated!</#if>
            <#if msg == "not_found"><i class="fa-solid fa-circle-exclamation"></i> Repair job not found.</#if>
        </div>
    </#if>

    <div class="filter-bar">
        <span class="filter-label"><i class="fa-solid fa-filter"></i> Filter by Status:</span>
        <a href="/admin/repairs" class="filter-chip <#if selectedStatus == ''>active</#if>">All</a>
        <#list statuses as st>
            <a href="/admin/repairs?status=${st}" class="filter-chip <#if selectedStatus == st>active</#if>">${st}</a>
        </#list>
    </div>

    <div class="dashboard-card">
        <table class="admin-table">
            <thead>
                <tr>
                    <th>Reference</th>
                    <th>Customer Name</th>
                    <th>Phone & Email</th>
                    <th>Device Model</th>
                    <th>Quoted Price</th>
                    <th>Status</th>
                    <th>Booking Date</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <#list repairs as r>
                    <tr>
                        <td><strong>${r.referenceCode}</strong></td>
                        <td>${r.customerName}</td>
                        <td>${r.phone}<br><small class="text-muted">${r.email}</small></td>
                        <td>${r.deviceModel}</td>
                        <td>£${(r.quotedPricePence / 100)?string["0.00"]}</td>
                        <td><span class="badge badge-${r.status?lower_case}">${r.status}</span></td>
                        <td><small>${r.createdAt}</small></td>
                        <td>
                            <a href="/admin/repairs/${r.id}" class="btn-sm"><i class="fa-solid fa-eye"></i> Details</a>
                        </td>
                    </tr>
                <#else>
                    <tr>
                        <td colspan="8" class="empty-state">No repair bookings found matching status "${selectedStatus!}".</td>
                    </tr>
                </#list>
            </tbody>
        </table>
    </div>
</@layout.adminLayout>
