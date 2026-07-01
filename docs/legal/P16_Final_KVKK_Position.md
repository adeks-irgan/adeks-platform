<!--
  ARTIFACT TYPE: External legal-advisor input (KVKK), recorded verbatim. Pod B provenance wrapper only.
  CANONICAL REPO PATH: /docs/legal/P16_Final_KVKK_Position.md
  RECORDED BY: Pod B — Architecture, Logic & Risk (evidence capture).
  SOURCE: Kerem-provided final KVKK / legal-advisor position on the P16 residual items,
    responding to the Pod B residual legal packet.
  STATUS: Legal INPUT for project analysis — NOT project policy, NOT a checkpoint pass, and does NOT
    authorize implementation. Each "position"/"determination" below is the advisor's stance for the
    project to act on with Kerem approval.
  RELATION TO PRIOR EVIDENCE: Companion to docs/legal/P16_Selcafe_QR_Live_Bill_KVKK_Consolidated_Advisor_Comment.md
    (recorded in PR #128). This file records the confirmatory answers to the six residual points.
  KEY CONFIRMATIONS (advisor): controller = Adeks Bilişim Hizmetleri Ltd. Şti. (single-entity, same-controller
    internal processing); lawful basis = KVKK Art. 5/2(c) contract performance; live bill = minimized,
    low-sensitivity, service-context personal data; guest≠member current-bill display acceptable for pilot;
    operational gates + staff-mediated-only guest payment sufficient; retention tiered (Adeks discount mapping
    90–180 days); cross-border conditional on foreign-hosted infra / Selcafe→GCP replication (factual check pending).
  STILL REQUIRED before implementation/checkpoint pass (NOT cleared by this input): compliance artifacts
    (KVKK_LEGAL_BASIS.md, DATA_PROCESSING_INVENTORY.md update, PRIVACY_NOTICE_TR.md, DATA_RETENTION_POLICY.md,
    CROSS_BORDER_TRANSFER_ASSESSMENT.md conditional, SECURITY_REVIEW.md access-control, pilot risk register)
    drafted + signed off + Kerem-approved; infrastructure fact-finding incl. Selcafe→GCP pipeline; accounting/tax
    confirmation of the Selcafe-side discount fiscal-retention category; detay/siparis schema elicitation;
    Operating Slice Checkpoint pass; Kerem approval. ADR-005 v1.2 (merged #130) already matches this position;
    no ADR-005 change is implied. Merge is Kerem-only.
  DATA: No real customer/staff/transaction/Selcafe row data. Synthetic examples only.
  The advisor note is reproduced verbatim below this comment; the wrapper adds no legal conclusion.
-->

# P16 — Selcafe QR Live-Bill Residual KVKK Position

## Scope

This document records the final position for the residual KVKK items concerning **P16: Selcafe-derived live-bill / active order-line read through a QR-linked session**.

The position is based on the current P16 design:

- A customer links their phone/PWA session to the active PC/session through a desk-side, one-time QR handshake.
- Adeks reads a minimized, non-identity projection of the linked Selcafe bill.
- The projection may include station/session context, running or settled total, and itemized F&B lines.
- Adeks does not read or display Selcafe member identity/profile data, including `adisyon.uye_no`.
- Guests may link, view the current bill, and order F&B without an Adeks account.
- An Adeks account is required only for discounts, coupons, points, and account-linked history.
- Guest payment in the pilot is add-to-tab only and staff-mediated.

The current legal entity fact is:

> **Adeks Bilişim Hizmetleri Ltd. Şti.** is the single entity operating the café/Selcafe environment and the Adeks Platform P16 pilot.

---

## Executive Summary

P16 is legally viable for a controlled pilot, provided the controls already identified in the project documents are implemented and the remaining compliance artifacts are completed before implementation/pilot operation.

The key conclusions are:

1. **Controller role**  
   Adeks Bilişim Hizmetleri Ltd. Şti. is the data controller for the current P16 pilot. This is same-controller internal processing, not a processor, joint-controller, or separate-controller arrangement.

2. **Lawful basis**  
   The primary lawful basis for showing the QR-linked active bill is **contract performance** under KVKK Article 5/2(c), because the bill view is directly connected to the café/PC/F&B service relationship.

3. **Personal-data status**  
   The live bill and itemized order lines should be treated as personal data, even when Selcafe member identity fields are excluded. The correct position is not anonymity; it is minimized, low-sensitivity, service-context personal data.

4. **Guest mismatch risk**  
   It is acceptable for the QR-linked guest to see the current active bill even if that guest is not the Selcafe member attached to the bill, provided the flow remains current-bill-only, session-bound, non-identity, short-lived, and staff-revocable.

5. **Read-surface status**  
   ADR-005 v1.2 has been merged and conditionally permits the QR-session-scoped, memberless active-bill projection. This does not authorize implementation by itself.

6. **Retention**  
   P16 retention must be tiered. The Adeks-side discount mapping should be retained for 90–180 days unless a specific dispute/accounting reason requires longer. Selcafe-side fiscal/commercial records follow the applicable accounting/tax/commercial retention category.

7. **Cross-border**  
   The local Selcafe read is not a cross-border transfer by itself. Cross-border assessment is required if P16 data is processed by foreign-hosted backend, database, logs, monitoring, analytics, backups, support, CDN/WAF, debugging, or AI/support tooling, or if a Selcafe-to-GCP replication pipeline exists.

8. **Guest payment**  
   For the pilot, guest payment should remain add-to-tab only and staff-mediated. No in-app guest payment should be enabled for guests.

---

## 1. Controller / Processor Role Allocation

### Final Position

For the current P16 pilot, there is only one relevant legal entity:

> **Adeks Bilişim Hizmetleri Ltd. Şti.**

The same entity operates the café/Selcafe environment and determines the purposes and means of the Adeks Platform P16 processing.

Therefore:

> **Adeks Bilişim Hizmetleri Ltd. Şti. is the data controller for the P16 pilot.**

This is same-controller internal processing.

It is not:

- a processor arrangement between Selcafe-side operations and Adeks Platform;
- a joint-controller arrangement;
- a separate-controller data transfer between two legal persons.

### Practical Consequences

| Issue | Position |
|---|---|
| Data controller | Adeks Bilişim Hizmetleri Ltd. Şti. |
| Selcafe-side café operation vs Adeks Platform | Same-controller internal processing |
| Processor relationship between café/Selcafe and Adeks Platform | No |
| Joint controller relationship | No |
| Separate controller relationship | No |
| Need for internal controller-to-controller transfer wording | No |
| Need for external processor/vendor assessment | Yes, for hosting, SMS, monitoring, analytics, backups, support, CDN/WAF, and similar vendors |

### Future Boundary

This conclusion applies to the current single-entity pilot.

If Adeks Platform is later offered to other café operators, operated by a separate platform entity, or expanded into a SaaS/multi-tenant commercial model, the role allocation must be reassessed. In that future model, Adeks may become a processor, separate controller, or joint controller depending on who determines the purposes and means of processing.

---

## 2. Lawful Basis for QR-Linked Live-Bill Display

### Final Position

The primary lawful basis is:

> **KVKK Article 5/2(c): processing necessary for the establishment or performance of a contract.**

The customer is receiving café, PC/session, and F&B service. Showing the active bill, itemized order lines, and payable total is directly connected to performance of that service.

An Adeks account is not required for this basis. The service relationship exists at the venue/session level.

### Processing-Basis Mapping

| Processing activity | Lawful basis |
|---|---|
| QR-linked active bill display | Contract performance |
| Showing current total and itemized F&B lines | Contract performance |
| QR token security, anti-abuse controls, short technical logs | Legitimate interest |
| Dispute, complaint, fraud, chargeback evidence | Establishment, exercise, or protection of a right |
| Fiscal/accounting discount records | Legal obligation and/or rights protection, depending on record type |
| Optional marketing | Explicit consent, separate from P16 core bill viewing |

### Consent Position

Explicit consent should **not** be used as the primary basis for core live-bill viewing.

Consent would be weaker and artificial where the processing is necessary to provide the service. Consent should be reserved for optional activities such as marketing, not the QR-linked active-bill display.

---

## 3. Personal-Data Status of Live Bill and Order Lines

### Final Position

The live bill and itemized F&B order lines should be treated as **personal data**, even if member identity fields are excluded.

The correct legal position is:

> KVKK applies. The processing is lawful because it is necessary to show the customer/session participant the active bill, and the projection excludes unnecessary identity fields.

The project should not argue:

> We exclude `uye_no`, therefore KVKK does not apply.

### Why the Data Remains Personal Data

The data remains personal data because it relates to an identifiable or potentially identifiable person in a live service context.

Relevant factors:

- The bill relates to a real customer/session participant.
- It is linked to a station/table/PC session.
- It is linked to a browser/PWA session after QR pairing.
- Order lines reveal consumption behavior.
- Totals and discounts may reveal spending behavior.
- In a small venue, station + time + items may be enough to identify the person.

### Sensitivity Level

This does not make the data high-risk by default.

The correct classification is:

> **Minimized, low-sensitivity, service-context personal data.**

It should not be treated as anonymous data.

It should also not be treated as special-category data unless the product intentionally infers sensitive information from order behavior.

---

## 4. QR-Linked Guest Is Not the Selcafe Member on the Bill

### Final Position

For the controlled pilot, it is legally acceptable to show the current active bill to the QR-linked physical session participant, even if that person is not the Selcafe member attached to the bill.

The legally relevant concept for the pilot is:

> **QR-linked physical session participant**, not **Selcafe member-account viewer**.

In a café/internet-café environment, the person using or participating in the session may not be the same person as the Selcafe member identifier attached to the bill. One person may open the session, another may scan the QR, and multiple people may share a table or tab.

This mismatch risk is acceptable for the pilot if the projection remains:

- current-bill-only;
- session-bound;
- non-identity;
- short-lived;
- staff-revocable;
- limited to the live service context.

### Allowed for Pilot

| Scenario | Position |
|---|---|
| Current active bill for the QR-linked station/session | Allow |
| Shared active tab at the same station/table/session | Allow for pilot |
| Guest sees current itemized F&B lines on that active bill | Allow |
| Guest orders F&B add-to-tab | Allow |
| Guest uses discounts/coupons/points without account | Do not allow |
| Account-linked history without account | Do not allow |

### Not Allowed

| Scenario | Position |
|---|---|
| Historical bill in guest mode | Do not show |
| Member profile, name, phone, email, points, balance, history | Do not show |
| Raw `adisyon_no` exposed to client | Do not expose |
| Customer-supplied raw bill-number lookup | Do not allow |
| Automatic following of transferred/merged bills | Do not allow in pilot |
| General member-bill viewer through QR | Do not allow |
| Suspicious or disputed QR link | Staff manual handling / revoke |

### Residual Risk

The QR holder may see order lines entered under another person's Selcafe member session.

This is an accepted minor-to-moderate pilot risk because:

- the view is limited to the current shared service context;
- Selcafe member identity/profile data is excluded;
- historical and transferred bills are excluded;
- the link is short-lived;
- staff can revoke or manually handle disputes.

If identity, profile, history, or transferred bills are exposed, this acceptance no longer applies.

---

## 5. Column-Level Exclusion and Row Selection

### Final Position

Column-level exclusion is necessary but not sufficient.

Selecting the bill row is itself a processing operation. Linking it to an Adeks session, rendering it in the PWA, and logging evidence are also processing operations.

The lawful basis remains available, primarily contract performance, but it must be documented explicitly.

### Correct Structure

| Layer | Compliance role |
|---|---|
| Server-internal active-bill row selection | Processing under contract performance |
| Column-level exclusion | Data minimization |
| DB/query-layer deny grants | Technical enforcement of minimization |
| QR token | Authorization / access control |
| Short technical logs | Legitimate interest / rights protection |
| No member profile read | Purpose limitation |
| No historical bills | Data minimization and expectation management |
| No transfer/merge following | Session-scope protection |

### Required Enforcement

The exclusion of member, staff, and free-text identity-risk fields must be enforced at the DB grant/query layer, not only in the UI.

The read-only login should physically be unable to select excluded fields such as:

- `adisyon.uye_no`;
- `kasaislem.uye_no`;
- `kuyruk.uye_no`;
- `kullanici_no`;
- `iptal_kullanici_no`;
- member profile fields;
- member points/balance/history;
- staff identifiers;
- password-like fields;
- unnecessary free-text fields likely to contain personal data.

---

## 6. ADR-005 v1.2 Read-Surface Status

### Final Position

ADR-005 v1.2 has been merged and conditionally permits the P16 QR-session-scoped live-bill read surface.

The permitted class is:

> A memberless, session-scoped projection of the active `adisyon`, `detay` / `siparis` where applicable, and the single Adeks-reflected discount `kasaislem` row.

### What Is Permitted

| Selcafe object | Permitted projection |
|---|---|
| `dbo.adisyon` | Active bill total/status fields only, no member identity, no free-text, no historical access |
| `dbo.detay` / `dbo.siparis` where applicable | Item reference, quantity, line amount for the active bill |
| `dbo.kasaislem` | Single Adeks-reflected discount row using dedicated transaction type + pseudorandom one-time code + amount + timestamp |

### What Remains Forbidden

- Reading or deriving `adisyon.uye_no`;
- reading Selcafe member profile data;
- reading staff identity fields;
- propagating raw `adisyon_no` or `aktif_adisyon_no` to the client;
- customer-supplied raw bill lookup;
- historical bill access in guest mode;
- transfer/merge-link following;
- use of Selcafe member balance or points;
- direct writes to Selcafe by Adeks.

### Implementation Boundary

ADR-005 v1.2 does not authorize implementation by itself.

Before implementation or pilot operation, the following remain required:

- P16 legal-basis matrix row(s);
- P16 data-processing inventory entry;
- QR/guest Aydınlatma Metni paragraph;
- P16 retention entries;
- conditional cross-border transfer assessment;
- security/access-control follow-up;
- `detay` / `siparis` schema elicitation;
- implementation-ready issue approval.

---

## 7. Discount Reflection and Retention

### Final Position

The discount reflection pattern is acceptable if kept narrow.

The Selcafe-side record and the Adeks-side mapping must be treated separately.

---

### 7.1 Selcafe-Side Discount Record

The Selcafe-side discount record should contain only:

- dedicated Adeks transaction type;
- pseudorandom one-time code;
- discount amount;
- timestamp if needed for reconciliation;
- no Adeks account ID;
- no Selcafe member ID;
- no coupon ID if avoidable;
- no phone, name, email, or profile data;
- no free-text notes beyond the fixed code format.

This record should follow the applicable Turkish accounting, tax, and commercial retention rule for the café's fiscal/commercial records.

The exact classification should be confirmed by accounting/tax review.

---

### 7.2 Adeks-Side Mapping

The Adeks-side mapping may link:

- one-time code;
- Adeks session/account reference where applicable;
- expected discount amount;
- linked bill/session reference;
- reconciliation status.

Recommended retention:

> **90–180 days**, unless a specific legal, accounting, dispute, or chargeback reason requires longer.

This mapping should not automatically inherit the longer retention period of Selcafe fiscal/commercial records.

### Retention Principle

> Do not apply one long fiscal-retention period to every P16 technical record.

P16 retention must be tiered.

---

## 8. Recommended P16 Retention Schedule

| Data category | Recommended retention | Notes |
|---|---:|---|
| Live bill projection rendered in UI | Do not persist | Read/display from live source |
| Order-line visibility cache | Session only; delete at bill close; hard TTL 15–60 minutes | Avoid duplicating Selcafe data |
| QR token | Until used/expired; usually seconds/minutes | One-time token |
| Active session-link state | Until bill/session closes; hard TTL same business day | Needed for continuity |
| Session-link metadata | 30 days for pilot | Security and complaint handling |
| Live-bill view evidence | 30 days; metadata only | Avoid full order-line persistence |
| Discount code mapping | 90–180 days | Reconciliation/dispute window |
| Selcafe fiscal/accounting discount record | Per applicable accounting/tax/commercial retention | Confirm exact category |
| Security/audit logs | 6–12 months | Pseudonymize where feasible |
| Incident/dispute records | Until dispute/investigation closes | Rights protection |

---

## 9. Cross-Border Transfer

### Final Position

The direct local Selcafe read is not a cross-border transfer by itself.

A cross-border issue may arise downstream if P16 data is processed outside Türkiye by any of the following:

- Adeks backend;
- application database;
- logs;
- error monitoring;
- analytics;
- crash reporting;
- backups;
- CDN/WAF logs;
- remote support;
- developer debugging tools;
- AI-assisted log analysis or support tooling.

### Separate Replica Risk

If any Selcafe-to-GCP or similar replication pipeline exists, that pipeline creates a separate cross-border-transfer issue independent of the P16 adapter read.

This must be confirmed factually.

### Required Position

Before implementation or pilot operation, Adeks should identify:

| Area | Required information |
|---|---|
| Backend hosting | Provider, region, data processed |
| Database | Provider, region, data categories |
| Logs | Provider, region, fields captured |
| Monitoring / error tracking | Provider, region, payload minimization |
| Analytics | Whether P16 data is included |
| Backups | Region, retention, encryption |
| CDN/WAF | Whether request logs include P16 identifiers |
| Support/debugging | Who can access P16 data and from where |
| AI/support tooling | Whether P16 logs or tickets are processed by AI tooling |

If any P16 data leaves Türkiye, the cross-border transfer mechanism must be documented before rollout.

---

## 10. Operational Gates for Pilot

### Final Position

The proposed operational gates are sufficient for a controlled pilot if combined with the mandatory ADR-005 v1.2 controls.

### Required Pilot Gates

| Gate | Position |
|---|---|
| No automatic following of transferred/merged bills | Required |
| Current bill only to guests | Required |
| Age-restricted F&B blocked or staff-confirmed | Required |
| Guest payment staff-mediated only | Required |
| No in-app guest payment | Required |
| Staff revoke action | Required |
| Suspicious/wrong QR scan manual handling | Required |
| No customer-supplied bill-number lookup | Required |
| No raw `adisyon_no` exposed to client | Required |
| No member profile/history/points/balance | Required |
| No full order-line persistence in logs | Required |

### Mandatory Technical Controls

| Control | Requirement |
|---|---|
| QR token | Crypto-random, single-use, short TTL, bound to one station/session, burned on first scan |
| DB/query-layer deny | Excluded identity/staff/free-text columns physically not selectable |
| Session-scoped selector | Only the directly linked active bill |
| Read-as-display | Do not recompute Selcafe pricing |
| Float handling | Coerce money values safely; use tolerance-based comparison |
| Discount reflection | Dedicated transaction type + pseudorandom code + fixed format + amount |
| Logging minimization | Metadata only where possible |
| Current-bill-only | No historical bills in guest mode |
| Transfer/merge exclusion | Do not follow transfer/merge targets |
| Age-restricted ordering | Block in guest mode or require staff confirmation |

---

## 11. Guest Payment

### Final Position

For the pilot, guest payment should remain:

> **Add-to-tab only, with staff-mediated payment.**

No in-app guest payment should be enabled for guests.

This is the correct posture because:

- guests may include minors;
- guest mode deliberately avoids DOB/profile collection;
- payment handling remains under staff supervision;
- it avoids creating unnecessary payment, consent, chargeback, and minor-capacity complexity;
- it is more privacy-preserving than forcing account signup.

### Guest Mode Boundaries

| Feature | Guest mode |
|---|---|
| QR-link session | Allowed |
| View current active bill | Allowed |
| View itemized current F&B lines | Allowed |
| Order F&B add-to-tab | Allowed |
| In-app guest payment | Not allowed |
| Discounts/coupons/points | Account required |
| Account-linked history | Account required |
| Wallet/loyalty | Account required |
| Marketing | Not allowed without separate lawful basis/consent model |

---

## 12. Required Compliance Artifacts

Before implementation or pilot operation, the following should be completed.

| Artifact | Required P16 content |
|---|---|
| Legal-basis matrix | P16 rows for live bill display, QR session-link management, discount verification, security/audit logging, account-linked benefits |
| Data-processing inventory | Active bill projection, QR token/session link, order lines, discount mapping, audit/logging metadata |
| Aydınlatma Metni | QR/guest paragraph, data categories, purposes, legal bases, recipients, retention, cross-border status |
| Retention policy | P16-specific TTLs; fiscal vs technical retention separation |
| Cross-border transfer assessment | Conditional on foreign-hosted infrastructure, logs, backups, support, analytics, AI tooling, or Selcafe replication |
| Security/access-control documentation | QR TTL, single-use token, staff revocation, DB deny grants, logging minimization, rate limits, regression tests |
| Pilot risk register | Shared-tab/session-participant residual risk, mis-link complaints, operational incidents |

---

## 13. Final Position

P16 may proceed as a controlled pilot if the remaining compliance and technical gates are completed.

The legally accurate description is:

> Adeks reads and displays a minimized, current, session-scoped projection of the active Selcafe bill to the QR-linked physical session participant, without reading or displaying Selcafe member identity, profile, points, balance, history, staff identifiers, or transferred/historical bills.

The lawful basis is strongest as:

> **Contract performance under KVKK Article 5/2(c)** for live bill display.

Secondary bases:

| Processing | Basis |
|---|---|
| QR security and abuse prevention | Legitimate interest |
| Short technical logs | Legitimate interest |
| Dispute/fraud/chargeback evidence | Rights protection |
| Fiscal/accounting discount records | Legal obligation and/or rights protection |

The pilot should not require proof that every QR-linked guest is the Selcafe member. The accepted legal theory is physical-session authorization through a short-lived, one-time, staff-revocable QR link.

The accepted risk is conditional. It remains acceptable only while the product preserves:

- current-bill-only scope;
- no member identity/profile/history;
- no transferred/merged bill following;
- no raw bill-number lookup;
- no guest in-app payment;
- age-restricted F&B blocking or staff confirmation;
- DB/query-layer exclusion of identity/staff/free-text fields;
- short retention and minimized logging;
- staff revocation and manual handling for disputes.

If these conditions are weakened, the P16 pilot position must be reassessed.

---

## 14. Immediate Next Steps

1. Record the controller position:
   - **Adeks Bilişim Hizmetleri Ltd. Şti. = data controller**.

2. Finalize the P16 compliance artifacts:
   - legal-basis rows;
   - inventory entries;
   - privacy notice paragraph;
   - retention entries;
   - cross-border assessment status.

3. Confirm infrastructure facts:
   - hosting region;
   - database region;
   - logs/monitoring vendors;
   - analytics usage;
   - backup region;
   - support/debugging access;
   - AI/support tooling;
   - whether any Selcafe-to-GCP replication exists.

4. Confirm fiscal/accounting retention:
   - exact treatment of the Selcafe-side discount reflection record.

5. Complete technical prerequisites:
   - `detay` / `siparis` schema elicitation;
   - DB/query-layer deny grants;
   - security-regression tests;
   - staff revoke flow;
   - logging minimization;
   - QR token TTL/single-use enforcement.

6. Keep guest payment staff-mediated:
   - no in-app guest payment during pilot.

