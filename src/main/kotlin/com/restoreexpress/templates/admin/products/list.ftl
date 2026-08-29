<#import "../admin_layout.ftl" as layout>

<@layout.adminLayout title="Manage Products" activeTab="products">
    <div class="admin-page-header">
        <div>
            <h1>Products Inventory</h1>
            <p>Manage refurbished devices, multi-image galleries, prices, and deletion.</p>
        </div>
        <div class="header-actions">
            <a href="/admin/products/new" class="btn btn-primary"><i class="fa-solid fa-plus"></i> Add New Product</a>
        </div>
    </div>

    <#if msg??>
        <div class="alert alert-success">
            <#if msg == "created"><i class="fa-solid fa-circle-check"></i> Product created successfully with gallery images!</#if>
            <#if msg == "updated"><i class="fa-solid fa-circle-check"></i> Product details updated successfully!</#if>
            <#if msg == "toggled"><i class="fa-solid fa-circle-check"></i> Product visibility toggled!</#if>
            <#if msg == "deleted"><i class="fa-solid fa-trash"></i> Product and associated images deleted from database!</#if>
            <#if msg == "not_found"><i class="fa-solid fa-circle-exclamation"></i> Product not found.</#if>
        </div>
    </#if>

    <div class="dashboard-card">
        <table class="admin-table">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Image</th>
                    <th>Product Details</th>
                    <th>Condition</th>
                    <th>Price</th>
                    <th>Stock</th>
                    <th>Status</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <#list products as p>
                    <tr>
                        <td>#${p.id}</td>
                        <td style="width: 70px;">
                            <#if p.images?has_content>
                                <img src="${p.images[0].url}" alt="${p.modelName}" style="width: 50px; height: 50px; object-fit: cover; border-radius: 8px; border: 1px solid var(--border-color);">
                            <#else>
                                <div style="width: 50px; height: 50px; background: var(--primary-red-soft); color: var(--primary-red); display: flex; align-items: center; justify-content: center; border-radius: 8px; font-size: 1rem;">
                                    <i class="fa-solid fa-mobile-screen"></i>
                                </div>
                            </#if>
                        </td>
                        <td>
                            <strong>${p.brand} ${p.modelName}</strong><br>
                            <small class="text-muted">Slug: ${p.slug}</small>
                            <#if p.storageVariant?? || p.color??>
                                <br><small class="text-muted">${p.storageVariant!} ${p.color!}</small>
                            </#if>
                        </td>
                        <td><span class="badge badge-info">${p.condition}</span></td>
                        <td><strong>£${(p.pricePence / 100)?string["0.00"]}</strong></td>
                        <td>
                            <#if p.stockQuantity <= 0>
                                <span class="badge badge-danger">Out of Stock (${p.stockQuantity})</span>
                            <#else>
                                <span class="badge badge-success">${p.stockQuantity} in stock</span>
                            </#if>
                        </td>
                        <td>
                            <#if p.active>
                                <span class="badge badge-active">Active</span>
                            <#else>
                                <span class="badge badge-inactive">Inactive</span>
                            </#if>
                        </td>
                        <td class="table-actions">
                            <div style="display: flex; gap: 0.4rem; flex-wrap: wrap;">
                                <a href="/admin/products/${p.id}/edit" class="btn-sm btn-edit"><i class="fa-solid fa-pen-to-square"></i> Edit</a>
                                <form action="/admin/products/${p.id}/toggle-active" method="POST" style="display:inline;">
                                    <button type="submit" class="btn-sm <#if p.active>btn-warning<#else>btn-success</#if>">
                                        <#if p.active>Disable<#else>Enable</#if>
                                    </button>
                                </form>
                                <form action="/admin/products/${p.id}/delete" method="POST" style="display:inline;" onsubmit="return confirm('Are you sure you want to permanently delete this product and its images from the database?');">
                                    <button type="submit" class="btn-sm btn-danger"><i class="fa-solid fa-trash"></i> Delete</button>
                                </form>
                            </div>
                        </td>
                    </tr>
                <#else>
                    <tr>
                        <td colspan="8" class="empty-state">No products found. Click "+ Add New Product" to create one.</td>
                    </tr>
                </#list>
            </tbody>
        </table>
    </div>
</@layout.adminLayout>
