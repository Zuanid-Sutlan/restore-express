<#import "layout.ftl" as layout>
<#import "components/hero.ftl" as hero>
<#import "components/how_it_works.ftl" as hiw>
<#import "components/why_choose_us.ftl" as why>
<#import "components/popular_repairs.ftl" as repairs>
<#import "components/reviews.ftl" as reviews>
<#import "components/cta.ftl" as cta>

<@layout.mainLayout title="Fast & Reliable Mobile Phone Repairs" activePage="home" settings=settings!>
    <@hero.heroSection />
    <@hiw.howItWorksSection />
    <@why.whyChooseUsSection />
    <@repairs.popularRepairsSection />
    <@reviews.reviewsSection />
    <@cta.ctaSection />
</@layout.mainLayout>
