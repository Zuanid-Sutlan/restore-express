<#import "layout.ftl" as layout>

<@layout.mainLayout title="Mobiles & Accessories Store" activePage="shop" settings=settings!>
    <div class="shop-container container">

        <!-- Store Header Banner -->
        <div class="shop-header">
            <div class="shop-title-box">
                <h1 class="page-title"><i class="fa-solid fa-store text-red"></i> Mobile Phones & Accessories Store</h1>
                <p class="page-subtitle">Shop brand new, grade-A refurbished, and pre-owned smartphones and mobile accessories.</p>
            </div>
        </div>

        <!-- Marketplace Main Layout (Sidebar Facets + Product Grid) -->
        <div class="marketplace-layout">

            <!-- Persistent Filter Sidebar -->
            <aside class="filter-sidebar" id="filter-sidebar">
                <div class="sidebar-header">
                    <h3><i class="fa-solid fa-filter"></i> Filter Store</h3>
                    <button type="button" class="btn-reset-filters" id="reset-filters-btn">Reset All</button>
                </div>

                <!-- Category Facet Group -->
                <div class="facet-group collapsible open">
                    <div class="facet-header">
                        <span>Product Category</span>
                        <i class="fa-solid fa-chevron-down facet-toggle"></i>
                    </div>
                    <div class="facet-content">
                        <label class="facet-option">
                            <input type="checkbox" name="cat" value="Mobiles" class="facet-checkbox" checked />
                            <span class="facet-label">Smartphones & Mobiles</span>
                        </label>
                        <label class="facet-option">
                            <input type="checkbox" name="cat" value="Tablets" class="facet-checkbox" checked />
                            <span class="facet-label">Tablets & iPads</span>
                        </label>
                        <label class="facet-option">
                            <input type="checkbox" name="cat" value="Chargers" class="facet-checkbox" checked />
                            <span class="facet-label">Chargers & Power Cables</span>
                        </label>
                        <label class="facet-option">
                            <input type="checkbox" name="cat" value="Cases" class="facet-checkbox" checked />
                            <span class="facet-label">Cases & Screen Protection</span>
                        </label>
                        <label class="facet-option">
                            <input type="checkbox" name="cat" value="Audio" class="facet-checkbox" checked />
                            <span class="facet-label">Audio & Headphones</span>
                        </label>
                        <label class="facet-option">
                            <input type="checkbox" name="cat" value="Parts" class="facet-checkbox" checked />
                            <span class="facet-label">OEM Replacement Parts</span>
                        </label>
                    </div>
                </div>

                <!-- Condition Facet Group -->
                <div class="facet-group collapsible open">
                    <div class="facet-header">
                        <span>Condition</span>
                        <i class="fa-solid fa-chevron-down facet-toggle"></i>
                    </div>
                    <div class="facet-content">
                        <label class="facet-option">
                            <input type="checkbox" name="condition" value="NEW" class="facet-checkbox" checked />
                            <span class="facet-label">Brand New / Sealed</span>
                        </label>
                        <label class="facet-option">
                            <input type="checkbox" name="condition" value="REFURBISHED_A" class="facet-checkbox" checked />
                            <span class="facet-label">Refurbished - Grade A</span>
                        </label>
                        <label class="facet-option">
                            <input type="checkbox" name="condition" value="REFURBISHED_B" class="facet-checkbox" checked />
                            <span class="facet-label">Refurbished - Grade B</span>
                        </label>
                        <label class="facet-option">
                            <input type="checkbox" name="condition" value="USED" class="facet-checkbox" checked />
                            <span class="facet-label">Pre-Owned / Used</span>
                        </label>
                    </div>
                </div>

                <!-- Price Range Facet -->
                <div class="facet-group collapsible open">
                    <div class="facet-header">
                        <span>Price Range (£)</span>
                        <i class="fa-solid fa-chevron-down facet-toggle"></i>
                    </div>
                    <div class="facet-content price-inputs-row">
                        <input type="number" id="min-price" placeholder="Min £" class="price-input" min="0" />
                        <span class="price-dash">-</span>
                        <input type="number" id="max-price" placeholder="Max £" class="price-input" min="0" />
                        <button type="button" id="btn-apply-price" class="btn-sm btn-primary">Go</button>
                    </div>
                </div>
            </aside>

            <!-- Product Grid Section -->
            <main class="results-area">

                <!-- Inline Search & Filter Bar -->
                <div class="inline-filter-bar">
                    <div class="type-filter-pills">
                        <button class="type-pill active" data-type="ALL">All Products</button>
                        <button class="type-pill" data-type="NEW">Brand New Only</button>
                        <button class="type-pill" data-type="REFURBISHED">Refurbished</button>
                    </div>

                    <div class="inline-controls-right">
                        <div class="search-box-inline">
                            <i class="fa-solid fa-magnifying-glass search-icon"></i>
                            <input type="text" id="inline-search" placeholder="Search devices, accessories..." class="search-input-field" />
                        </div>

                        <div class="sort-box-inline">
                            <label for="sort-select" class="sort-label">Sort:</label>
                            <select id="sort-select" class="sort-select-dropdown">
                                <option value="newest">Newest Listed</option>
                                <option value="price-low">Price: Low to High</option>
                                <option value="price-high">Price: High to Low</option>
                                <option value="title-az">Title: A-Z</option>
                            </select>
                        </div>
                    </div>
                </div>

                <!-- Results Counter -->
                <div class="results-counter-bar">
                    <span class="results-count-text">Showing <strong id="results-count-number">${products?size}</strong> products</span>
                    <span class="results-live-indicator"><i class="fa-solid fa-shield-check text-red"></i> Verified Quality Guaranteed</span>
                </div>

                <!-- Product Card Grid -->
                <div class="auction-grid" id="auction-grid">
                    <#list products as product>
                        <#assign pricePounds = (product.pricePence / 100)?string["0.00"]>
                        <article class="auction-card"
                                 data-id="${product.id}"
                                 data-brand="${product.brand}"
                                 data-title="${product.modelName}"
                                 data-condition="${product.condition}"
                                 data-price="${product.pricePence}">

                            <!-- Thumbnail Image Wrapper -->
                            <div class="lot-thumb-wrap">
                                <a href="/shop/${product.slug}" class="thumb-link">
                                    <#if product.images?has_content>
                                        <img src="${product.images[0].url}" alt="${product.modelName}" class="lot-thumb-img" loading="lazy" />
                                    <#else>
                                        <img src="https://images.unsplash.com/photo-1592899677977-9c10ca588bbd?w=600&auto=format&fit=crop&q=80"
                                             alt="${product.modelName}" class="lot-thumb-img" loading="lazy" />
                                    </#if>
                                </a>

                                <!-- Condition Tag Overlay -->
                                <span class="lot-status-badge live">
                                    <#if product.condition == 'NEW'>Brand New
                                    <#elseif product.condition == 'REFURBISHED_A'>Refurbished - Grade A
                                    <#elseif product.condition == 'REFURBISHED_B'>Refurbished - Grade B
                                    <#else>Pre-Owned / Used</#if>
                                </span>
                            </div>

                            <!-- Card Body -->
                            <div class="lot-card-body">
                                <h3 class="lot-title">
                                    <a href="/shop/${product.slug}" title="${product.brand} ${product.modelName}">
                                        ${product.brand} ${product.modelName}
                                    </a>
                                </h3>

                                <div class="lot-meta-row">
                                    <span class="lot-region-badge"><i class="fa-solid fa-check text-red"></i> ${product.condition}</span>
                                    <span class="lot-bids-count">Stock: ${product.stockQuantity}</span>
                                </div>

                                <div class="bid-time-row">
                                    <div class="bid-col">
                                        <span class="bid-label">Price</span>
                                        <span class="bid-amount text-red">£${pricePounds}</span>
                                    </div>
                                    <div class="time-col">
                                        <span class="time-label">Status</span>
                                        <span class="time-value" style="font-size: 0.72rem;"><i class="fa-solid fa-circle-check text-success"></i> In Stock</span>
                                    </div>
                                </div>

                                <div class="lot-card-actions">
                                    <a href="/shop/${product.slug}" class="btn btn-primary btn-block btn-bid-action">
                                        <i class="fa-solid fa-bag-shopping"></i> View Details & Buy
                                    </a>
                                </div>
                            </div>
                        </article>
                    <#else>
                        <div class="empty-results-box">
                            <i class="fa-solid fa-store empty-icon"></i>
                            <h3>No Store Products Found</h3>
                            <p>Try adjusting your search query or filter checkboxes.</p>
                            <button type="button" class="btn btn-outline" id="empty-reset-btn">Clear Filters</button>
                        </div>
                    </#list>
                </div>
            </main>
        </div>
    </div>
</@layout.mainLayout>
