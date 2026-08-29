<#import "../admin_layout.ftl" as layout>

<#assign isEdit = product??>
<#assign title = isEdit?then("Edit Product #" + product.id, "Add New Product")>

<@layout.adminLayout title=title activeTab="products">
    <div class="admin-page-header">
        <div>
            <h1>${title}</h1>
            <p>${isEdit?then("Update existing device catalog entry, upload lossless images, or remove product", "Create a new refurbished listing with lossless database image uploads")}</p>
        </div>
        <div class="header-actions" style="display: flex; gap: 0.8rem;">
            <a href="/admin/products" class="btn btn-alt">&larr; Back to Products</a>
            <#if isEdit>
                <form action="/admin/products/${product.id}/delete" method="POST" style="display:inline;" onsubmit="return confirm('Are you sure you want to permanently delete this product from the database?');">
                    <button type="submit" class="btn btn-danger"><i class="fa-solid fa-trash"></i> Delete Product</button>
                </form>
            </#if>
        </div>
    </div>

    <#if msg??>
        <div class="alert alert-success">
            <#if msg == "updated"><i class="fa-solid fa-circle-check"></i> Product saved successfully!</#if>
            <#if msg == "img_deleted"><i class="fa-solid fa-trash"></i> Image removed from database!</#if>
        </div>
    </#if>

    <div class="admin-form-container">
        <form action="<#if isEdit>/admin/products/${product.id}/edit<#else>/admin/products/new</#if>" method="POST" enctype="multipart/form-data" class="admin-form">
            <div class="form-row">
                <div class="form-group">
                    <label for="brand">Brand *</label>
                    <input type="text" id="brand" name="brand" value="${isEdit?then(product.brand, '')}" placeholder="e.g. Apple, Samsung, Google" required>
                </div>
                <div class="form-group">
                    <label for="modelName">Model Name *</label>
                    <input type="text" id="modelName" name="modelName" value="${isEdit?then(product.modelName, '')}" placeholder="e.g. iPhone 13 Pro" required>
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label for="slug">URL Slug</label>
                    <input type="text" id="slug" name="slug" value="${isEdit?then(product.slug, '')}" placeholder="Leave blank to auto-generate from model name">
                    <small class="form-hint">Unique URL identifier (e.g. iphone-13-pro)</small>
                </div>
                <div class="form-group">
                    <label for="condition">Condition *</label>
                    <select id="condition" name="condition" required>
                        <#list conditions as cond>
                            <option value="${cond}" <#if isEdit && product.condition == cond>selected</#if>>${cond}</option>
                        </#list>
                    </select>
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label for="storageVariant">Storage Variant</label>
                    <input type="text" id="storageVariant" name="storageVariant" value="${isEdit?then(product.storageVariant!, '')}" placeholder="e.g. 128GB, 256GB">
                </div>
                <div class="form-group">
                    <label for="color">Color</label>
                    <input type="text" id="color" name="color" value="${isEdit?then(product.color!, '')}" placeholder="e.g. Space Gray, Sierra Blue">
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label for="price">Price (£) *</label>
                    <input type="number" step="0.01" min="0" id="price" name="price" value="${isEdit?then((product.pricePence / 100)?string["0.00"], '')}" placeholder="299.99" required>
                </div>
                <div class="form-group">
                    <label for="stockQuantity">Stock Quantity *</label>
                    <input type="number" min="0" id="stockQuantity" name="stockQuantity" value="${isEdit?then(product.stockQuantity, '1')}" required>
                </div>
            </div>

            <div class="form-group checkbox-group">
                <label>
                    <input type="checkbox" name="isActive" value="true" <#if !isEdit || product.active>checked</#if>>
                    <span>Make this product active & visible in shop</span>
                </label>
            </div>

            <div class="form-group">
                <label for="description">Product Description</label>
                <textarea id="description" name="description" rows="4" placeholder="Enter full specifications, warranty info, condition details...">${isEdit?then(product.description!, '')}</textarea>
            </div>

            <hr style="margin: 2rem 0; border: none; border-top: 1px solid var(--border-color);">

            <div class="form-group">
                <label><i class="fa-solid fa-images"></i> Upload Multiple Product Images (Stored Losslessly in Database)</label>
                <input type="file" name="images" multiple accept="image/*" style="padding: 0.5rem; border: 1px dashed var(--primary-red); border-radius: 8px; background: var(--primary-red-soft);">
                <small class="form-hint">Select one or multiple full-quality image files. Original resolution and quality will be preserved in the database without compression.</small>
            </div>

            <div class="form-group">
                <label for="imageUrls"><i class="fa-solid fa-link"></i> Or Add Image URLs (Comma Separated)</label>
                <input type="text" id="imageUrls" name="imageUrls" placeholder="https://example.com/image1.jpg, https://example.com/image2.jpg">
            </div>

            <#if isEdit && product.images?has_content>
                <div class="form-group">
                    <label>Existing Product Images (${product.images?size}):</label>
                    <div class="image-gallery-grid">
                        <#list product.images as img>
                            <div class="image-thumb-card">
                                <img src="${img.url}" alt="Product Image #${img.id}">
                                <button type="submit" class="btn-delete-img" formaction="/admin/products/${product.id}/images/${img.id}/delete" formmethod="POST" title="Delete Image" onclick="return confirm('Delete this image from database?');">
                                    <i class="fa-solid fa-xmark"></i>
                                </button>
                            </div>
                        </#list>
                    </div>
                </div>
            </#if>

            <div class="form-actions">
                <button type="submit" class="btn btn-primary"><i class="fa-solid fa-floppy-disk"></i> ${isEdit?then("Save Changes", "Create Product")}</button>
                <a href="/admin/products" class="btn btn-alt">Cancel</a>
            </div>
        </form>
    </div>
</@layout.adminLayout>
