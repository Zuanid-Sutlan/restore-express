<#import "layout.ftl" as layout>
<@layout.mainLayout title="Error">
    <h1>Error ${status}</h1>
    <p>${message}</p>
    <a href="/" class="btn">Back to Home</a>
</@layout.mainLayout>
