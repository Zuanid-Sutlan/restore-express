<#import "layout.ftl" as layout>
<@layout.mainLayout title="Shop">
    <h1>Refurbished Devices</h1>
    <div class="product-grid" style="display: grid; grid-template-columns: repeat(auto-fill, minmax(250px, 1fr)); gap: 2rem; margin-top: 2rem;">
        <#list products as product>
            <div class="product-card" style="border: 1px solid #eee; padding: 1rem; border-radius: 8px; background: #fff; box-shadow: 0 2px 4px rgba(0,0,0,0.05);">
                <h3>${product.brand} ${product.modelName}</h3>
                <p>Condition: <strong>${product.condition}</strong></p>
                <p style="font-size: 1.25rem; color: #007bff; font-weight: bold;">£${(product.pricePence / 100)?string["0.00"]}</p>
                <a href="/shop/${product.slug}" class="btn" style="width: 100%; text-align: center; box-sizing: border-box;">View Details</a>
            </div>
        <#else>
            <p>No products available at the moment. Check back soon!</p>
        </#list>
    </div>
</@layout.mainLayout>
