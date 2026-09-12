<#import "../admin_layout.ftl" as layout>

<@layout.adminLayout title="Manage Repairs" activeTab="repairs">
    <div class="admin-page-header">
        <div>
            <h1>Repair Jobs Management</h1>
            <p>Track incoming device repairs, technician notes, quotes, and repair status progression (Device Received &rarr; Repairing &rarr; Waiting for Approval &rarr; Repaired &rarr; Dispatched).</p>
        </div>
    </div>

    <#if msg??>
        <div class="alert alert-success">
            <#if msg == "updated"><i class="fa-solid fa-circle-check"></i> Repair status updated successfully!</#if>
            <#if msg == "not_found"><i class="fa-solid fa-circle-exclamation"></i> Repair job not found.</#if>
        </div>
    </#if>

    <div class="filter-bar">
        <span class="filter-label"><i class="fa-solid fa-filter"></i> Filter Status:</span>
        <a href="/admin/repairs" class="filter-chip <#if selectedStatus == ''>active</#if>">All Jobs</a>
        <#list statuses as st>
            <a href="/admin/repairs?status=${st}" class="filter-chip <#if selectedStatus == st>active</#if>">${st}</a>
        </#list>
    </div>

    <div class="dashboard-card">
        <table class="admin-table">
            <thead>
                <tr>
                    <th>Job Reference</th>
                    <th>Customer Name</th>
                    <th>Phone & Email</th>
                    <th>Device Model</th>
                    <th>Advance Paid</th>
                    <th>Current Status</th>
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
                        <td><strong class="text-red">£${(r.quotedPricePence / 100)?string["0.00"]}</strong></td>
                        <td><span class="badge badge-active">${r.status}</span></td>
                        <td><small>${r.createdAt}</small></td>
                        <td>
                            <a href="/admin/repairs/${r.id}" class="btn-sm btn-primary"><i class="fa-solid fa-pen-to-square"></i> Manage Status</a>
                        </td>
                    </tr>
                <#else>
                    <tr>
                        <td colspan="8" class="empty-state">No repair bookings found matching filter "${selectedStatus!}".</td>
                    </tr>
                </#list>
            </tbody>
        </table>
    </div>
</@layout.adminLayout>
