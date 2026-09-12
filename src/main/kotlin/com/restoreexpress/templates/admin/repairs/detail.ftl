<#import "../admin_layout.ftl" as layout>

<#assign repair = detailedRepair.repair>
<#assign events = detailedRepair.events>

<@layout.adminLayout title="Repair #" + repair.referenceCode activeTab="repairs">
    <div class="admin-page-header">
        <div>
            <h1>Manage Repair Job #${repair.referenceCode}</h1>
            <p>Device: <strong>${repair.deviceModel}</strong> &bull; Current Status: <span class="badge badge-active">${repair.status}</span></p>
        </div>
        <div class="header-actions">
            <a href="/admin/repairs" class="btn btn-alt">&larr; Back to Repairs List</a>
        </div>
    </div>

    <#if msg??>
        <div class="alert alert-success">
            <#if msg == "updated"><i class="fa-solid fa-circle-check"></i> Repair job status updated successfully!</#if>
        </div>
    </#if>

    <div class="detail-grid">
        <div class="detail-column main-col">
            <div class="dashboard-card">
                <h2><i class="fa-solid fa-screwdriver-wrench text-red"></i> Fault Details & Customer Device Info</h2>
                <div class="info-group">
                    <label>Reported Fault / Diagnostic Request:</label>
                    <p style="background: var(--bg-light); padding: 1rem; border-radius: 4px; border: 1px solid var(--border-color);">${repair.reportedFault}</p>
                </div>
                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1rem; margin-top: 1.5rem;">
                    <div class="info-group">
                        <label>Quoted Price (Advance Stripe Paid):</label>
                        <p><strong style="font-size: 1.2rem; color: var(--primary-red);">£${(repair.quotedPricePence / 100)?string["0.00"]}</strong></p>
                    </div>
                    <div class="info-group">
                        <label>IMEI / Serial Number:</label>
                        <p>${repair.imeiSerial!"Not specified"}</p>
                    </div>
                </div>
            </div>

            <div class="dashboard-card">
                <h2><i class="fa-solid fa-clock-rotate-left"></i> Repair Status Progress Log</h2>
                <div class="timeline" style="margin-top: 1rem;">
                    <#list events as ev>
                        <div style="display: flex; gap: 1rem; padding-bottom: 1rem; border-bottom: 1px solid var(--border-color); margin-bottom: 1rem;">
                            <div><span class="badge badge-active">${ev.status}</span></div>
                            <div style="flex: 1;">
                                <small class="text-muted" style="display: block;">${ev.createdAt}</small>
                                <p style="margin-top: 0.2rem;">${ev.note!"Status updated by technician"}</p>
                            </div>
                        </div>
                    <#else>
                        <p class="empty-state">No status updates logged yet.</p>
                    </#list>
                </div>
            </div>
        </div>

        <div class="detail-column side-col">
            <div class="dashboard-card">
                <h2><i class="fa-solid fa-pen-to-square text-red"></i> Update Repair Status</h2>
                <form action="/admin/repairs/${repair.id}/status" method="POST" class="admin-form">
                    <div class="form-group">
                        <label for="status">Select New Status:</label>
                        <select id="status" name="status" style="width: 100%; padding: 0.6rem; border: 1px solid var(--border-color); border-radius: 4px;" required>
                            <#list statuses as st>
                                <option value="${st}" <#if repair.status == st>selected</#if>>${st}</option>
                            </#list>
                        </select>
                        <small class="form-hint">Status choices: RECEIVED (Device Received), REPAIRING (Repairing), WAITING_FOR_APPROVAL (Waiting for Approval), REPAIRED (Repaired), DISPATCHED (Dispatched).</small>
                    </div>

                    <div class="form-group">
                        <label for="note">Technician Progress Note</label>
                        <textarea id="note" name="note" rows="3" placeholder="e.g. Device received at central lab. Diagnostic testing passed. Replacing screen module."></textarea>
                    </div>

                    <button type="submit" class="btn btn-primary" style="width:100%;"><i class="fa-solid fa-floppy-disk"></i> Save Status Update</button>
                </form>
            </div>

            <div class="dashboard-card">
                <h2><i class="fa-solid fa-user"></i> Customer Information</h2>
                <div class="info-group">
                    <label>Customer Name:</label>
                    <p><strong>${repair.customerName}</strong></p>
                </div>
                <div class="info-group">
                    <label>Email Address:</label>
                    <p><a href="mailto:${repair.email}">${repair.email}</a></p>
                </div>
                <div class="info-group">
                    <label>Phone Number:</label>
                    <p><a href="tel:${repair.phone}">${repair.phone}</a></p>
                </div>
            </div>
        </div>
    </div>
</@layout.adminLayout>
