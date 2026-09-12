<#import "layout.ftl" as layout>

<#assign pageTitle = (product??)?then("${product.brand} ${product.modelName}", "Product Detail ${slug!''}")>
<@layout.mainLayout title=pageTitle activePage="shop" settings=settings!>

    <div class="container detail-container">
        <!-- Breadcrumbs -->
        <div class="detail-top-nav">
            <div class="breadcrumbs">
                <a href="/"><i class="fa-solid fa-house"></i> Home</a>
                <i class="fa-solid fa-angle-right sep"></i>
                <a href="/shop">Store Catalog</a>
                <i class="fa-solid fa-angle-right sep"></i>
                <span class="active-crumb"><#if product??>${product.brand} ${product.modelName}<#else>${slug!''}</#if></span>
            </div>
            <div class="lot-id-badge">
                <span class="lot-label">PRODUCT CODE:</span>
                <strong class="lot-ref-code"><#if product??>SKU-#${product.id}<#else>SKU-100</#if></strong>
            </div>
        </div>

        <#if product??>
            <#assign pricePounds = (product.pricePence / 100)?string["0.00"]>

            <div class="lot-detail-grid">
                <!-- Image Gallery & Specs -->
                <div class="lot-left-col">
                    <div class="lot-gallery-card">
                        <div class="lot-main-image-wrap">
                            <#if product.images?has_content>
                                <img src="${product.images[0].url}" id="main-product-img" alt="${product.modelName}" class="lot-main-img" />
                            <#else>
                                <img src="https://images.unsplash.com/photo-1592899677977-9c10ca588bbd?w=800&auto=format&fit=crop&q=80"
                                     id="main-product-img" alt="${product.modelName}" class="lot-main-img" />
                            </#if>

                            <!-- Condition Badge -->
                            <span class="lot-status-badge live">
                                <#if product.condition == 'NEW'>Brand New
                                <#elseif product.condition == 'REFURBISHED_A'>Refurbished (Grade A)
                                <#elseif product.condition == 'REFURBISHED_B'>Refurbished (Grade B)
                                <#else>Pre-Owned / Used</#if>
                            </span>
                        </div>
                    </div>

                    <!-- Description & Specifications -->
                    <div class="specifications-card">
                        <h2 class="card-section-title"><i class="fa-solid fa-circle-info text-red"></i> Product Overview & Specifications</h2>
                        <p class="card-section-desc">${product.description!'High quality mobile hardware inspected and verified by Restore Express technicians.'}</p>

                        <table class="spec-table">
                            <tbody>
                                <tr>
                                    <th>Brand</th>
                                    <td><strong>${product.brand}</strong></td>
                                </tr>
                                <tr>
                                    <th>Model Name</th>
                                    <td>${product.modelName}</td>
                                </tr>
                                <tr>
                                    <th>Condition</th>
                                    <td><span class="badge badge-active">${product.condition}</span></td>
                                </tr>
                                <tr>
                                    <th>Storage / Variant</th>
                                    <td>${product.storageVariant!'Standard'}</td>
                                </tr>
                                <tr>
                                    <th>Color</th>
                                    <td>${product.color!'Original'}</td>
                                </tr>
                                <tr>
                                    <th>Warranty</th>
                                    <td>12-Month Restore Express Hardware Warranty</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>

                <!-- Purchase Action Panel -->
                <div class="lot-right-col">
                    <div class="bidding-panel-card">
                        <div class="panel-header">
                            <h1 class="lot-detail-title">${product.brand} ${product.modelName}</h1>
                            <div class="lot-tags-row">
                                <span class="tag-hub"><i class="fa-solid fa-shield-check text-red"></i> Verified Quality</span>
                                <span class="tag-reserve"><i class="fa-solid fa-check text-success"></i> IN STOCK (${product.stockQuantity})</span>
                            </div>
                        </div>

                        <div class="bidding-price-box">
                            <div class="price-col">
                                <span class="price-label">Price</span>
                                <div class="price-value-row">
                                    <span class="currency-symbol">£</span>
                                    <span class="price-amount text-red">${pricePounds}</span>
                                </div>
                                <span class="bid-count-sub">Includes 12-Month Warranty</span>
                            </div>
                            <div class="time-col-detail">
                                <span class="time-label">Availability</span>
                                <span class="time-countdown" style="font-size: 0.95rem; color: #059669;"><i class="fa-solid fa-circle-check"></i> Ready to Ship</span>
                            </div>
                        </div>

                        <!-- Buy Action Form -->
                        <form action="/shop/${product.slug}/buy" method="POST" class="bidding-form" onsubmit="alert('Proceeding to Checkout...');">
                            <div class="form-group">
                                <label for="quantity_select">Quantity:</label>
                                <select id="quantity_select" name="quantity" class="form-control" style="width: 100%; padding: 0.6rem; border: 1px solid var(--border-grey); border-radius: 2px;">
                                    <option value="1">1 Unit</option>
                                    <option value="2">2 Units</option>
                                    <option value="3">3 Units</option>
                                </select>
                            </div>

                            <button type="submit" class="btn btn-primary btn-lg btn-block btn-submit-bid">
                                <i class="fa-solid fa-bag-shopping"></i> PROCEED TO CHECKOUT
                            </button>
                        </form>

                        <div class="panel-secondary-actions">
                            <a href="/shop" class="link-ask-question"><i class="fa-solid fa-arrow-left"></i> Back to Store Catalog</a>
                            <a href="/contact" class="link-ask-question"><i class="fa-regular fa-envelope"></i> Ask Support</a>
                        </div>
                    </div>
                </div>
            </div>
        <#else>
            <div class="empty-state-box" style="text-align: center; padding: 4rem 1rem;">
                <h2>Product Not Found</h2>
                <p>The product you are looking for does not exist in our store.</p>
                <br>
                <a href="/shop" class="btn btn-primary"><i class="fa-solid fa-arrow-left"></i> Return to Store Catalog</a>
            </div>
        </#if>
    </div>

</@layout.mainLayout>
