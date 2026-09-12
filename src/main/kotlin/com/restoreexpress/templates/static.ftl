<#import "layout.ftl" as layout>

<@layout.mainLayout title=title activePage="static" settings=settings!>
    <section class="section">
        <div class="container">
            <#if title == "Track Repair Status">
                <!-- REPAIR TRACKER PAGE -->
                <div class="section-header">
                    <span class="section-subtitle">Real-Time Job Tracking</span>
                    <h1 class="section-title">Track Your Repair Job</h1>
                    <p class="section-desc">Enter your Job Reference code (e.g. RE-2026-8492) to view live lab progress and dispatch status.</p>
                </div>

                <div class="static-content-card">
                    <!-- Search Form -->
                    <form action="/track" method="GET" class="search-form-inline" style="display: flex; gap: 0.5rem; margin-bottom: 2rem;">
                        <input type="text" name="ref" value="${ref!''}" placeholder="Enter Job Reference Code (e.g. RE-2026-8492)..."
                               style="flex-grow: 1; padding: 0.75rem 1rem; border: 1px solid var(--border-grey); border-radius: 2px; font-size: 0.9rem;" required />
                        <button type="submit" class="btn btn-primary"><i class="fa-solid fa-magnifying-glass"></i> Track Job</button>
                    </form>

                    <#if booked?? && booked == "1">
                        <div class="alert alert-success" style="background: #ecfdf5; border: 1px solid #a7f3d0; padding: 1.2rem; border-radius: 4px; margin-bottom: 2rem;">
                            <h3 style="color: #059669; font-size: 1.1rem; font-weight: 800; margin-bottom: 0.3rem;"><i class="fa-solid fa-circle-check"></i> Repair Booking Confirmed!</h3>
                            <p style="color: #065f46; font-size: 0.9rem;">Your Job Reference is <strong>${ref!''}</strong>. Please package your smartphone safely and send it to our Central Repair Lab address below.</p>
                        </div>
                    </#if>

                    <#if trackedRepair?? && trackedRepair?has_content>
                        <!-- Found Repair Job Tracker -->
                        <div class="job-tracker-box" style="background: var(--bg-grey-soft); border: 1px solid var(--border-grey); padding: 1.5rem; border-radius: 4px; margin-bottom: 2rem;">
                            <div style="display: flex; justify-content: space-between; align-items: center; border-bottom: 1px solid var(--border-grey); padding-bottom: 1rem; margin-bottom: 1rem;">
                                <div>
                                    <h2 style="font-size: 1.2rem; font-weight: 800;">Job #${trackedRepair.referenceCode}</h2>
                                    <p style="color: var(--text-muted); font-size: 0.85rem;">Device: <strong>${trackedRepair.deviceModel}</strong> &bull; Customer: ${trackedRepair.customerName}</p>
                                </div>
                                <div>
                                    <span class="badge badge-active" style="font-size: 0.9rem; padding: 0.4rem 0.8rem;">Current Status: ${trackedRepair.status}</span>
                                </div>
                            </div>

                            <!-- 5-Stage Status Lifecycle Pipeline -->
                            <h3 style="font-size: 0.95rem; font-weight: 800; margin-bottom: 1rem;">Repair Status Lifecycle:</h3>
                            <div class="status-pipeline-grid" style="display: grid; grid-template-columns: repeat(5, 1fr); gap: 0.5rem; text-align: center; margin-bottom: 1.5rem;">
                                <div class="status-step <#if trackedRepair.status == 'RECEIVED' || trackedRepair.status == 'REPAIRING' || trackedRepair.status == 'WAITING_FOR_APPROVAL' || trackedRepair.status == 'REPAIRED' || trackedRepair.status == 'DISPATCHED'>active-step</#if>" style="padding: 0.6rem; border: 1px solid var(--border-grey); background: var(--bg-white); border-radius: 2px;">
                                    <i class="fa-solid fa-box" style="color: var(--primary-red); font-size: 1.2rem;"></i>
                                    <span style="display: block; font-size: 0.72rem; font-weight: 700; margin-top: 0.3rem;">1. Device Received</span>
                                </div>
                                <div class="status-step <#if trackedRepair.status == 'REPAIRING' || trackedRepair.status == 'WAITING_FOR_APPROVAL' || trackedRepair.status == 'REPAIRED' || trackedRepair.status == 'DISPATCHED'>active-step</#if>" style="padding: 0.6rem; border: 1px solid var(--border-grey); background: var(--bg-white); border-radius: 2px;">
                                    <i class="fa-solid fa-screwdriver-wrench" style="color: var(--primary-red); font-size: 1.2rem;"></i>
                                    <span style="display: block; font-size: 0.72rem; font-weight: 700; margin-top: 0.3rem;">2. Repairing</span>
                                </div>
                                <div class="status-step <#if trackedRepair.status == 'WAITING_FOR_APPROVAL' || trackedRepair.status == 'REPAIRED' || trackedRepair.status == 'DISPATCHED'>active-step</#if>" style="padding: 0.6rem; border: 1px solid var(--border-grey); background: var(--bg-white); border-radius: 2px;">
                                    <i class="fa-solid fa-clock-rotate-left" style="color: var(--primary-red); font-size: 1.2rem;"></i>
                                    <span style="display: block; font-size: 0.72rem; font-weight: 700; margin-top: 0.3rem;">3. Waiting Approval</span>
                                </div>
                                <div class="status-step <#if trackedRepair.status == 'REPAIRED' || trackedRepair.status == 'DISPATCHED'>active-step</#if>" style="padding: 0.6rem; border: 1px solid var(--border-grey); background: var(--bg-white); border-radius: 2px;">
                                    <i class="fa-solid fa-circle-check" style="color: var(--primary-red); font-size: 1.2rem;"></i>
                                    <span style="display: block; font-size: 0.72rem; font-weight: 700; margin-top: 0.3rem;">4. Repaired</span>
                                </div>
                                <div class="status-step <#if trackedRepair.status == 'DISPATCHED'>active-step</#if>" style="padding: 0.6rem; border: 1px solid var(--border-grey); background: var(--bg-white); border-radius: 2px;">
                                    <i class="fa-solid fa-truck-fast" style="color: var(--primary-red); font-size: 1.2rem;"></i>
                                    <span style="display: block; font-size: 0.72rem; font-weight: 700; margin-top: 0.3rem;">5. Dispatched</span>
                                </div>
                            </div>

                            <p style="font-size: 0.85rem; color: var(--text-muted);">Reported Fault: <strong>${trackedRepair.reportedFault}</strong></p>
                        </div>
                    </#if>

                    <!-- Send-In Delivery Address Box Managed from Admin -->
                    <div class="send-in-address-box" style="background: #fdf2f3; border: 1px solid var(--primary-red); padding: 1.5rem; border-radius: 4px;">
                        <h3 style="color: var(--primary-red); font-size: 1.1rem; font-weight: 800; margin-bottom: 0.5rem; display: flex; align-items: center; gap: 0.5rem;">
                            <i class="fa-solid fa-truck-ramp-box"></i> Device Send-In Delivery Address (Send Devices Here)
                        </h3>
                        <p style="font-size: 0.88rem; color: var(--text-charcoal); margin-bottom: 0.8rem;">
                            Please package your smartphone securely with bubble wrap and send it to our official lab delivery address below. Include your <strong>Job Reference Number</strong> inside the package.
                        </p>
                        <div style="background: var(--bg-white); border: 1px solid var(--border-grey); padding: 1rem; border-radius: 2px; font-weight: 700; font-size: 0.95rem; white-space: pre-line;">
                            ${(settings.deliveryAddress)!'Restore Express Central Repair Lab\nAttn: Inbound Service Dept (Job Ref: {REF})\n120 Tech Boulevard, Suite 400\nCentral City, UK, CC 90210'}
                        </div>
                    </div>
                </div>
            <#else>
                <!-- GENERAL STATIC CONTENT -->
                <div class="section-header">
                    <span class="section-subtitle">Restore Express</span>
                    <h1 class="section-title">${title}</h1>
                    <p class="section-desc">E-commerce store terms, repair service guidelines, and store policies.</p>
                </div>
                <div class="static-content-card">
                    <p>Welcome to the <strong>${title}</strong> page. Detailed guidelines and store policies are maintained here to keep you informed about our certified repairs and e-commerce transactions.</p>
                    <br>
                    <div class="static-info-box">
                        <h3><i class="fa-solid fa-shield-halved text-red"></i> 100% Quality Guarantee</h3>
                        <p>All mobile device sales and repair bookings include a 12-month Restore Express warranty.</p>
                    </div>
                    <br>
                    <a href="/" class="btn btn-primary"><i class="fa-solid fa-arrow-left"></i> Return to Home</a>
                </div>
            </#if>
        </div>
    </section>
</@layout.mainLayout>
