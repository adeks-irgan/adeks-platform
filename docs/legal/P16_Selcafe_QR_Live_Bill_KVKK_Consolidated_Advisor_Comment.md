<!--
  ARTIFACT TYPE: External legal-advisor input (KVKK), recorded verbatim. Pod B provenance wrapper only.
  CANONICAL REPO PATH: /docs/legal/P16_Selcafe_QR_Live_Bill_KVKK_Consolidated_Advisor_Comment.md
  RECORDED BY: Pod B — Architecture, Logic & Risk (evidence capture).
  SOURCE: Kerem-provided consolidated KVKK / legal-advisor comment on activity P16.
  STATUS: Legal INPUT for project analysis — NOT project policy, NOT a checkpoint pass, and does NOT
    authorize implementation. Each "basis"/"determination" below is the advisor's position for the
    project to act on with Kerem approval; the binding compliance artifacts (KVKK_LEGAL_BASIS.md,
    DATA_RETENTION_POLICY.md, PRIVACY_NOTICE_TR.md, DATA_PROCESSING_INVENTORY.md, and any
    CROSS_BORDER_TRANSFER_ASSESSMENT.md) remain to be produced and Kerem-approved.
  ADR-005 v1.2 remains a later, separate, Kerem-approved ADR change. Merge is Kerem-only.
  DATA: No real customer/staff/transaction/Selcafe row data. Synthetic examples only.
  The advisor note is reproduced verbatim below this comment; the wrapper adds no legal conclusion.
-->

# P16 — Selcafe QR-Linked Live Bill Read
## Consolidated KVKK / Legal Advisor Comment

**Date:** 2026-07-01  
**Project:** Adeks Platform  
**Activity:** P16 — Selcafe-derived live-bill / active order-line read through a desk-side one-time QR-linked PWA session  
**Prepared for:** Internal product, engineering, and legal review  

---

## 1. Executive Summary

My consolidated view is that **P16 should be treated as legally viable for a controlled pilot**.

The correct posture is not to say that the live bill is anonymous or outside KVKK. It is better to accept that the live bill and order lines are **personal data**, but to process them under a practical and defensible basis:

> **The QR-linked customer/session may be shown the current active bill because this is directly connected to performance of the café service relationship.**

The other AI memo correctly identifies important controls: the QR handshake removes the earlier enumeration problem, column-level identity exclusion is necessary but not enough, and the discount reflection record must remain narrow. However, that memo is **too restrictive** on the "guest is not the Selcafe member" point. In a café / internet café environment, the legally relevant user is often the **physical session participant or table participant**, not necessarily the Selcafe member identifier attached to the bill. That residual mismatch risk can be accepted for a pilot if the projection remains current, session-bound, non-identity, and revocable.

**Recommended decision:** proceed with P16 pilot, subject to the controls in this memo. Do not block the pilot merely because the QR-linked guest may not be the Selcafe member attached to the bill.

---

## 2. Consolidated Advisor Position

### 2.1 What I accept from the other AI memo

The following points are legally and technically useful and should be retained:

1. **The one-time QR handshake materially changes the risk profile.**  
   A customer no longer types or guesses a raw bill number. The QR token becomes the practical authorization factor.

2. **The live bill remains personal data.**  
   Removing `adisyon.uye_no` and member profile fields does not anonymize the bill row.

3. **Selecting the bill row is processing.**  
   Column-level minimization does not eliminate the need for a lawful basis.

4. **The discount reflection pattern is acceptable if narrow.**  
   A dedicated Adeks transaction type, pseudorandom one-time code, and discount amount is a reasonable minimization design.

5. **Retention must be tiered.**  
   Live display data, QR session records, audit logs, discount mappings, and fiscal records should not all inherit the same retention period.

6. **Cross-border assessment is infrastructure-dependent.**  
   The local read itself is not the transfer. Downstream hosting, logging, monitoring, backups, or support access may be.

### 2.2 Where I would soften the other AI memo

The other memo frames the "QR guest ≠ Selcafe member" case as a near-blocker. I would not treat it that way for this pilot.

A practical legal advisor position is:

> If the QR is physically issued at the desk/station/table, is one-time and short-lived, and only exposes the current active bill without Selcafe member identity or history, then displaying the active bill to the QR-linked session participant is acceptable for a controlled pilot.

This is not risk-free. It is a manageable, ordinary-service disclosure risk. The right control is not to require strict proof that the QR holder is the Selcafe member. The right control is to prevent exposure of **member identity, member history, unrelated transferred bills, and durable account data**.

---

## 3. Facts and Product Assumptions

This memo assumes the following P16 design:

- The customer links their phone/PWA session through a **desk-side, one-time QR handshake**.
- The QR token is short-lived, non-guessable, session-bound, and revocable.
- Adeks reads only a minimized projection of the current Selcafe bill:
  - station/session context;
  - running or settled total;
  - itemized F&B lines;
  - discount verification fields if applicable.
- Adeks does **not** read or display:
  - Selcafe member identity/profile;
  - `adisyon.uye_no`;
  - `kullanici_no`;
  - staff identifiers;
  - member points/balance;
  - visit history;
  - previous bills;
  - free-text fields likely to contain incidental personal data.
- Guests may view the bill and order F&B without an Adeks account.
- Adeks account login is required only for discounts, coupons, points, and account-linked history.
- The Selcafe read is local/direct unless the architecture separately routes data into foreign-hosted infrastructure.

If any of these assumptions changes, the conclusion should be revisited.

---

## 4. Question-by-Question Legal Determination

### Q1 — Lawful basis for reading and showing the QR-linked customer's own live bill

**Determination:**  
The primary lawful basis should be **KVKK Article 5/2(c): processing necessary for the establishment or performance of a contract**.

The customer is receiving café / PC / F&B service. Showing the active bill, itemized order lines, and payable total is part of performing that service. An Adeks account is not required for this basis; the service relationship exists at the venue/session level.

**Secondary bases:**

| Processing | Basis |
|---|---|
| Live bill display | Contract performance |
| QR link security, anti-abuse, short audit logs | Legitimate interest |
| Dispute, complaint, fraud, chargeback evidence | Establishment, exercise, or protection of a right |
| Fiscal/accounting discount records | Legal obligation / rights protection, depending on record type |

**Do not use explicit consent for core bill viewing.**  
It is unnecessary and weaker. If the processing is needed to provide the service, consent may look artificial or bundled with core functionality. Consent should be reserved for optional activities such as marketing, not live bill display.

---

### Q2 — Is the live bill / itemized order-line data personal data?

**Determination:**  
Yes. Treat the live bill and itemized F&B lines as **personal data**, even when member identity fields are excluded.

Reasons:

- The data relates to a real person's current visit/session.
- It is linked to a station/table/PC session.
- It is linked to a browser/PWA session after QR pairing.
- Order lines reveal consumption behavior.
- Totals and discounts may reveal spending behavior.
- In a small venue, station + time + items may be enough to identify the person.

This does **not** make the data high-risk by default. It is ordinary transactional/customer service data, not special-category data, unless the product intentionally infers sensitive information from order behavior.

**Legal position:**  
Do not argue that this is anonymous data. Argue that it is **minimized, low-sensitivity, service-context personal data**.

---

### Q3 — If the QR-linking guest is not the Selcafe member on the bill, is displaying that bill legally acceptable?

**Determination:**  
Generally yes for the pilot, if the product model is **QR-linked physical session participant**, not **Selcafe member account viewer**.

The project should not require that the QR-linked guest be the Selcafe member on the bill. That would make the guest path impractical and would not reflect ordinary café usage, where one person may open the session, another may scan the QR, and several people may share the same table or tab.

The display is acceptable where:

- the QR was physically obtained at the relevant station/table/session;
- the token is one-time and short-lived;
- the bill is the current active bill for that physical session;
- no member identity or profile data is displayed;
- no member history, points, balance, or past orders are displayed;
- the link expires when the bill closes or the session changes;
- staff can revoke the link.

**Residual risk accepted for pilot:**  
The QR holder may see order lines entered under another person's Selcafe member session. In the current design, that is an acceptable minor-to-moderate risk because the disclosure is limited to the current shared service context and excludes identity/profile fields.

**Boundary rule:**  
Do not turn the QR into a general member-bill viewer.

The following should remain out of scope:

| Scenario | Recommended treatment |
|---|---|
| Current bill for the QR-linked station/table | Allow |
| Shared active tab at same station/table | Allow for pilot |
| Bill transferred/merged into another bill | Prefer not to follow transfer links automatically |
| Historical bill | Do not show in guest mode |
| Member profile / points / history | Require account authorization; do not expose through QR |
| Suspicious or disputed link | Staff revoke / manual handling |

**Practical advisor comment:**  
This is a reasonable risk to take for a controlled pilot. The stronger legal story is not "the QR holder is definitely the member." The stronger story is "the QR holder is the physically authorized participant in the live service session, and only session-level non-identity data is shown."

---

### Q4 — Is column-level exclusion enough, or does selecting the bill row require a separate lawful basis?

**Determination:**  
Column-level exclusion is not enough by itself.

Selecting the row, linking it to an Adeks session, rendering it in the PWA, and logging evidence are all processing operations. They require a lawful basis. The lawful basis is still available — primarily contract performance — but it should be documented explicitly.

**Correct legal structure:**

| Layer | Legal / compliance role |
|---|---|
| Row selection | Processing under contract performance |
| Column exclusion | Data minimization |
| QR token | Authorization / access control |
| Short logs | Legitimate interest / rights protection |
| No member profile read | Purpose limitation |
| No historical bills | Data minimization and expectation management |

The project should avoid the sentence:  
> "We exclude `uye_no`, therefore KVKK does not apply."

The better sentence is:  
> "KVKK applies; the processing is lawful because it is necessary to show the customer/session participant the active bill, and the projection excludes unnecessary identity fields."

---

### Q5 — Is the cashier-entered Adeks discount reflection record acceptable from a minimization standpoint?

**Determination:**  
Yes, conditionally.

The proposed Selcafe-side discount reflection record is acceptable if it contains only:

- a dedicated Adeks transaction type;
- a pseudorandom one-time code;
- the discount amount;
- a timestamp if needed for reconciliation;
- no Adeks account ID;
- no Selcafe member ID;
- no coupon ID if avoidable;
- no phone, name, email, or profile data;
- no free-text notes beyond the fixed code format.

**Required safeguards:**

| Requirement | Advisor comment |
|---|---|
| Code entropy | Must be non-guessable |
| Single-use | Must not become a durable cross-system identifier |
| Fixed format | Prevent cashier free-text from adding personal data |
| Mapping location | Keep `code → Adeks user/session/discount` mapping in Adeks, not Selcafe |
| Fail-closed reconciliation | If code/type/amount does not match, route to manual check |
| Logs | Log enough to audit abuse, not enough to recreate full customer profiles |

The record remains personal data on the Adeks side because Adeks can map it to a session/account. That is acceptable. The minimization goal is to avoid expanding Selcafe into an Adeks identity store.

---

### Q6 — Does guest access create a minor-data or child-protection issue if the guest skips account signup?

**Determination:**  
Guest access does not itself create a KVKK child-data problem. It is generally more privacy-preserving than forcing signup.

No signup means:

- no DOB collection;
- no account profile;
- no loyalty profile;
- no long-term behavioral history;
- less data retained.

The main risks are product/venue risks, not the mere absence of account signup:

| Risk | Treatment |
|---|---|
| Age-restricted F&B items | Block in guest mode or require staff confirmation |
| In-app payment by minors | Avoid in guest mode for pilot or require staff-mediated checkout |
| Marketing to guests | Do not do it without a separate lawful basis/consent model |
| Guest profiling | Do not create persistent guest profiles |
| Account conversion | Apply normal account, notice, and age-flow checks at signup |

**Advisor position:**  
Do not add age/DOB collection just to solve a theoretical child-data issue. That would increase data collection. For pilot, keep guest mode transient and staff-mediated, and gate age-restricted products operationally.

---

### Q7 — Retention periods

**Determination:**  
Use tiered retention. Do not apply fiscal/accounting retention periods to every technical P16 log.

Recommended pilot retention:

| Data category | Recommended retention | Notes |
|---|---:|---|
| Live bill projection rendered in UI | Do not persist | Read/display from live source |
| Order-line visibility cache | Session only; delete at bill close; hard TTL 15–60 minutes | Avoid duplicating Selcafe data |
| QR token | Until used/expired; usually minutes | One-time token |
| Active session-link state | Until bill/session closes; hard TTL same business day | Needed for continuity |
| Session-link metadata | 30 days for pilot | Security and complaint handling |
| Live-bill view evidence | 30 days; metadata only | Avoid storing full order lines |
| Discount code mapping | 90–180 days | Reconciliation/dispute window |
| Selcafe fiscal/accounting discount record | Per applicable accounting/tax/commercial retention | Confirm exact category with counsel/accountant |
| Security/audit logs | 6–12 months | Pseudonymized where feasible |
| Incident/dispute records | Until dispute/investigation closes | Rights protection |

**Important distinction:**  
The live QR bill-view record is not automatically the same as statutory internet café access logs or accounting records. Do not over-retain P16 data just because other Selcafe or venue records have longer retention duties.

**Recommended pilot choice:**  
Use **30 days** for session-link/view evidence and **180 days** for discount-code mapping unless finance or counsel requires a longer period for a specific accounting record.

---

### Q8 — Which documents must be updated?

**Determination:**  
The following should be updated before broad rollout. For a limited pilot, lightweight versions are acceptable, but the activity should still be recorded.

| Document | Required? | Comment |
|---|---:|---|
| Legal basis matrix | Yes | Add P16 with contract performance, legitimate interest, rights protection, and legal obligation where applicable |
| Data processing inventory | Yes | Add live bill projection, QR session link, order lines, discount mapping, audit logs |
| Privacy notice / Aydınlatma Metni | Yes | Explain QR live bill viewing, guest mode, data categories, purposes, legal bases, recipients, retention |
| Retention policy | Yes | Add P16-specific TTLs and distinguish fiscal records from technical logs |
| Cross-border transfer assessment | Conditional | Required if Adeks backend/logs/backups/support/analytics process P16 data outside Türkiye |
| Security/access-control documentation | Yes | QR TTL, one-time use, revocation, column-deny grants, logging, rate limits |
| Controller/processor allocation | Recommended | Clarify whether the café operator and Adeks are controller/processor, joint controllers, or same controller context |
| Pilot risk register | Recommended | Record accepted residual risk for shared-tab/session-participant display |

**Advisor position:**  
Do not delay the pilot until a perfect legal document set exists. But do not run the pilot with no paper trail. Create a short P16 addendum covering basis, data categories, retention, guest flow, and cross-border status.

---

### Q9 — Does this direct local Selcafe read create a cross-border transfer issue?

**Determination:**  
No, not by itself.

A direct local Selcafe read does not create a cross-border transfer if the read and immediate processing occur inside Türkiye and P16 data is not sent abroad.

However, cross-border transfer may arise downstream if any of the following process P16 data outside Türkiye:

- Adeks backend;
- database;
- logs;
- error monitoring;
- analytics;
- crash reporting;
- backups;
- CDN/WAF logs;
- remote support;
- developer debugging tools;
- AI-assisted log analysis or support tooling.

**Advisor position:**  
The local read can proceed. The project should separately verify whether P16 data appears in foreign-hosted logs, monitoring, backups, or support systems.

---

## 5. Recommended Pilot Conditions

P16 may proceed as a controlled pilot if the following conditions are met.

### 5.1 Must-have controls

1. **One-time QR token**
   - Non-guessable.
   - Short TTL.
   - Single use or tightly session-bound.
   - Revocable by staff.

2. **Session-scoped read**
   - Show only the current active bill linked to the physical station/table/session.
   - Do not expose raw `adisyon_no` to the client.
   - Do not allow customer-supplied raw bill number lookup.

3. **No Selcafe member identity**
   - No `uye_no`.
   - No member name/profile.
   - No phone/email.
   - No points/balance.
   - No visit or bill history.

4. **Column-deny / query-deny enforcement**
   - Prevent accidental selection of member/staff fields.
   - Exclusion should be enforced at the DB grant/query layer, not only in UI.

5. **Current bill only**
   - Guest mode should not show historical bills.
   - Account login required for account-linked history.

6. **Discount reflection discipline**
   - Dedicated Adeks transaction type.
   - Pseudorandom one-time code.
   - Fixed format.
   - Amount only.
   - Mapping stays in Adeks.

7. **Logging minimization**
   - Metadata only where possible.
   - Avoid full order-line persistence.
   - Avoid member identity in logs.
   - Pseudonymize Adeks references where feasible.

8. **Age-restricted ordering control**
   - Block age-restricted items in guest mode or require staff confirmation.

### 5.2 Should-have controls

1. **Do not automatically follow transferred/merged bill links** during pilot.
2. **Show a simple UI notice** such as:
   > "You are viewing the active bill for this station/session."
3. **Add a staff revoke action** for wrong scans or table changes.
4. **Add monitoring for abnormal QR link attempts**.
5. **Add a small pilot risk log** recording any mis-link or complaint.

---

## 6. Risk Register

| Risk | Level | Advisor view |
|---|---:|---|
| Live bill is personal data | Medium | Acceptable with contract basis and minimization |
| QR guest differs from Selcafe member | Medium | Acceptable for pilot as physical-session display; avoid member profile/history |
| Transferred/merged bill exposes unrelated lines | Medium/High | Avoid following transfer links automatically in pilot |
| Member identity leaks through logs/joins | High | Must prevent |
| Raw bill-number enumeration | High | Resolved by QR path; do not reintroduce typed raw lookup |
| Discount code becomes durable identifier | Medium | Use pseudorandom single-use code; mapping in Adeks only |
| Guest minor orders restricted item | Medium/High if menu contains such items | Block/gate operationally |
| Over-retention | Medium | Tiered TTLs |
| Downstream cross-border logs/backups | Medium/High depending on infra | Verify separately |

---

## 7. Final Advisor Recommendation

**Proceed with the P16 pilot.**

The activity is defensible if described accurately:

> Adeks reads and displays a minimized, current, session-scoped projection of the active Selcafe bill to the QR-linked physical session participant, without reading or displaying Selcafe member identity, profile, points, balance, history, or staff identifiers.

The lawful basis is strongest as **contract performance** for the live bill view. Security logs and abuse prevention can rely on **legitimate interest**. Dispute and accounting records can rely on **rights protection** and, where applicable, **legal obligation**.

The project should not overcorrect by requiring every QR-linked guest to be the Selcafe member. That would undermine the guest flow and is not necessary for a controlled pilot. The accepted legal risk should instead be managed through session scoping, non-identity projection, short retention, staff revocation, and excluding transferred/historical/member-profile data.

---

## 8. Proposed P16 Legal Basis Matrix Row

| Processing activity | Data categories | Purpose | Lawful basis | Retention | Notes |
|---|---|---|---|---|---|
| QR-linked active bill display | Station/session context, current bill total, F&B line items | Allow customer/session participant to view active bill | Contract performance | Display-only; no persistence | Guest account not required |
| QR session-link management | QR token metadata, session ID, station/table reference, timestamp | Authenticate/authorize session link | Legitimate interest; contract performance | Active session + 30 days metadata | No raw member identity |
| Discount reflection verification | Dedicated transaction type, pseudorandom code, discount amount, timestamp | Verify cashier-entered Adeks discount | Contract performance; rights protection; legal obligation where fiscal record applies | Mapping 90–180 days; fiscal record per law | Mapping remains in Adeks |
| Security/audit logging | Pseudonymized session/account reference, event timestamps, outcome metadata | Security, abuse prevention, complaint handling | Legitimate interest; rights protection | 6–12 months | Avoid order-line detail unless necessary |
| Account-linked discounts/history | Adeks account, coupon/points activity, account history | Provide account benefits | Contract performance; consent only for optional marketing | Per account/loyalty retention policy | Requires Adeks account |

---

## 9. Short Privacy Notice Addendum Draft

This is a short draft to incorporate into the Adeks privacy notice / Aydınlatma Metni.

> When you connect your phone to an active station/table session through a one-time QR code, Adeks may read and display limited information from the active Selcafe bill, such as the station/session context, current or settled total, and food and beverage order lines. This is done so that you can view the active bill and use related service features during your visit. Adeks does not display Selcafe member profile information, Selcafe member number, staff identifiers, member balance, points, or historical Selcafe bills through the guest QR bill-view flow.  
>
> If you use Adeks discounts, coupons, points, or account-linked history, an Adeks account is required and additional account-related data may be processed for those features. Limited technical records may be kept for security, reconciliation, dispute handling, and audit purposes. These records are retained only for the periods defined in the applicable retention policy.

---

## 10. Implementation Checklist

Before pilot:

- [ ] Confirm QR token is non-guessable, one-time/short-lived, and revocable.
- [ ] Confirm there is no raw `adisyon_no` customer lookup.
- [ ] Enforce DB/query-level exclusion for `uye_no`, `kullanici_no`, staff IDs, profile fields, and free-text fields.
- [ ] Confirm guest mode cannot view historical bills.
- [ ] Confirm account login is required for discounts, coupons, points, and history.
- [ ] Implement discount reflection as dedicated transaction type + pseudorandom one-time code + amount.
- [ ] Keep discount identity mapping in Adeks only.
- [ ] Define 30-day session-link/view-evidence retention for pilot.
- [ ] Define 90–180-day discount-code mapping retention.
- [ ] Check whether P16 data appears in foreign-hosted logs, monitoring, analytics, backups, or support tools.
- [ ] Add a short P16 entry to the legal basis matrix and processing inventory.
- [ ] Add a P16 paragraph to the privacy notice.
- [ ] Gate or block age-restricted products in guest mode.

---

## 11. Open Points for Counsel / Kerem

These points do not need to block the controlled pilot unless the facts are unfavorable, but they should be closed before broad rollout:

1. Does the QR binding ever follow transferred/merged bill links?
2. Does the guest menu include age-restricted products?
3. Is guest ordering only added to the tab, or can the guest pay in-app?
4. Are Adeks logs, monitoring, backups, or support tools hosted outside Türkiye?
5. Is the café operator the same controller as Adeks, a separate controller, a joint controller, or a processor relationship?
6. Which exact fiscal/commercial retention rule applies to the Selcafe-side discount record?

---

## 12. Source Notes

This memo consolidates:

- the prior Adeks P16 KVKK analysis;
- the uploaded second-agent memo titled `P16_Selcafe_QR_Live_Bill_KVKK_Legal_Determination.md`;
- repository-facing P16 / Selcafe reconciliation assumptions, especially the conditional inclusion of `adisyon` / `detay` / discount `kasaislem` under controls;
- official KVKK guidance on processing conditions, transparency/notice, deletion/destruction/anonymization, and cross-border transfer.

Official KVKK references consulted:

- KVKK — Personal Data Processing Conditions: https://www.kvkk.gov.tr/Icerik/4190/Kisisel-Verilerin-Islenme-Sartlari
- KVKK — Personal Data: https://www.kvkk.gov.tr/Icerik/2050/Kisisel-Veriler
- KVKK — Obligation to Inform: https://www.kvkk.gov.tr/Icerik/2033/Aydinlatma-Yukumlulugu-
- KVKK — Public announcement on notice deficiencies: https://www.kvkk.gov.tr/Icerik/6765/AYDINLATMA-YUKUMLULUGUNUN-YERINE-GETIRILMESI-HAKKINDA-KAMUOYU-DUYURUSU
- KVKK — Deletion, destruction, anonymization regulation: https://www.kvkk.gov.tr/Icerik/5441/KISISEL-VERILERIN-SILINMESI-YOK-EDILMESI-VEYA-ANONIM-HALE-GETIRILMESI-HAKKINDA-YONETMELIK
- KVKK — Cross-border transfer: https://www.kvkk.gov.tr/Icerik/2053/Yurtdisina-Aktarim
- KVKK — Standard contracts for cross-border transfers: https://www.kvkk.gov.tr/Icerik/7929/Standart-Sozlesmeler
- KVKK — Service conditional on explicit consent: https://www.kvkk.gov.tr/Icerik/5412/Acik-Rizanin-Hizmet-Sartina-Baglanmasi
