<#import "../admin_layout.ftl" as layout>

<#assign order = detailedOrder.order>
<#assign items = detailedOrder.items>

<@layout.adminLayout title="Order #" + order.orderReference activeTab="orders">
    <div class="admin-page-header">
        <div>
            <h1>Order #${order.orderReference}</h1>
            <p>Placed on ${order.createdAt} &bull; Current Status: <span class="badge badge-${order.status?lower_case}">${order.status}</span></p>
        </div>
        <div class="header-actions">
            <a href="/admin/orders" class="btn btn-alt">&larr; Back to Orders</a>
        </div>
    </div>

    <#if msg??>
        <div class="alert alert-success">
            <#if msg == "updated"><i class="fa-solid fa-circle-check"></i> Order status updated successfully!</#if>
        </div>
    </#if>

    <div class="detail-grid">
        <div class="detail-column main-col">
            <div class="dashboard-card">
                <h2><i class="fa-solid fa-box-open"></i> Items Ordered</h2>
                <table class="admin-table">
                    <thead>
                        <tr>
                            <th>Product</th>
                            <th>Unit Price</th>
                            <th>Quantity</th>
                            <th>Line Total</th>
                        </tr>
                    </thead>
                    <tbody>
                        <#list items as item>
                            <tr>
                                <td>
                                    <strong>${item.productBrand} ${item.productModel}</strong><br>
                                    <small class="text-muted">Product ID: #${item.productId}</small>
                                </td>
                                <td>£${(item.unitPricePence / 100)?string["0.00"]}</td>
                                <td>${item.quantity}</td>
                                <td><strong>£${((item.unitPricePence * item.quantity) / 100)?string["0.00"]}</strong></td>
                            </tr>
                        <#else>
                            <tr>
                                <td colspan="4" class="empty-state">No item breakdown found.</td>
                            </tr>
                        </#list>
                    </tbody>
                    <tfoot>
                        <tr>
                            <td colspan="3" style="text-align: right;"><strong>Subtotal:</strong></td>
                            <td>£${(order.subtotalPence / 100)?string["0.00"]}</td>
                        </tr>
                        <tr>
                            <td colspan="3" style="text-align: right;"><strong>Shipping Cost:</strong></td>
                            <td>£${(order.shippingCostPence / 100)?string["0.00"]}</td>
                        </tr>
                        <tr>
                            <td colspan="3" style="text-align: right;"><strong>Total Paid:</strong></td>
                            <td><strong style="font-size: 1.2rem; color: var(--primary-red);">£${(order.totalPence / 100)?string["0.00"]}</strong></td>
                        </tr>
                    </tfoot>
                </table>
            </div>
        </div>

        <div class="detail-column side-col">
            <div class="dashboard-card">
                <h2><i class="fa-solid fa-pen-to-square"></i> Update Order Status</h2>
                <form action="/admin/orders/${order.id}/status" method="POST" class="admin-form">
                    <div class="form-group">
                        <label for="status">Order Status</label>
                        <select id="status" name="status" required>
                            <#list statuses as st>
                                <option value="${st}" <#if order.status == st>selected</#if>>${st}</option>
                            </#list>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="trackingNumber">Carrier Tracking Number</label>
                        <input type="text" id="trackingNumber" name="trackingNumber" value="${order.trackingNumber!}" placeholder="e.g. Royal Mail GB123456789">
                    </div>

                    <button type="submit" class="btn btn-primary" style="width:100%;"><i class="fa-solid fa-floppy-disk"></i> Update Order</button>
                </form>
            </div>

            <div class="dashboard-card">
                <h2><i class="fa-solid fa-user"></i> Customer & Shipping</h2>
                <div class="info-group">
                    <label>Customer Name:</label>
                    <p><strong>${order.customerName}</strong></p>
                </div>
                <div class="info-group">
                    <label>Email Address:</label>
                    <p><a href="mailto:${order.email}">${order.email}</a></p>
                </div>
                <div class="info-group">
                    <label>Phone Number:</label>
                    <p><a href="tel:${order.phone}">${order.phone}</a></p>
                </div>
                <hr style="margin: 1rem 0; border: none; border-top: 1px solid var(--border-color);">
                <div class="info-group">
                    <label>Shipping Address:</label>
                    <p>
                        ${order.shippingAddressLine1}<br>
                        <#if order.shippingAddressLine2?? && order.shippingAddressLine2?has_content>
                            ${order.shippingAddressLine2}<br>
                        </#if>
                        ${order.shippingCity}, ${order.shippingPostcode}<br>
                        ${order.shippingCountry}
                    </p>
                </div>
                <#if order.stripePaymentIntentId??>
                    <hr style="margin: 1rem 0; border: none; border-top: 1px solid var(--border-color);">
                    <div class="info-group">
                        <label>Stripe Payment Intent:</label>
                        <p><small class="text-muted">${order.stripePaymentIntentId}</small></p>
                    </div>
                </#if>
            </div>
        </div>
    </div>
</@layout.adminLayout>
