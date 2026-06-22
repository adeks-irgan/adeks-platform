# SMS Provider Report — Phase 1 Customer OTP (Decision Support)

<!--
  DOCUMENT TYPE: Pod B Decision-Support Artifact (Provider comparison + Kerem decision packet)
  VERSION: v0.3
  STATUS: v0.3 Draft for Kerem review — narrow re-review incorporating Pod A post-v0.2
          delta findings (2026-06-22); İleti Merkezi re-assessed (technical/commercial vs KVKK
          separated); Verimor R8 refined (polling preferred; webhook conditional). Awaiting
          Kerem review and Pod A commercial overlay before joint decision packet.
          This document is DECISION SUPPORT — it does NOT select a provider and does NOT
          establish any decision. Provider selection is `[NEEDS KEREM APPROVAL]` and is
          made by Kerem with Pod A on commercial/price aspects (KD-B). Resolves nothing
          until Kerem records a decision.
  AUTHOR: Pod B — Architecture, Logic & Risk
  REVIEWER: Pod B (self) + Kerem (Authentication/authorization + Customer personal data
            handling + Security-sensitive → strictest ADR-009 §3 trigger governs:
            Pod B + Kerem before merge). Pod A reviews commercial/price aspects (KD-B).
  APPROVER: Kerem
  DATE: 2026-06-22
  CANONICAL REPO PATH: /docs/decision-support/SMS_PROVIDER_REPORT.md
  AUTHORITY: Derives from ADR-015 (Accepted) and AUTH_THREAT_MODEL.md (Accepted, BL-2 closed).
             ADR-015 is authoritative. This document does NOT change any decision. If this
             document and ADR-015 / the decision index ever disagree, those win.
  RESOLVES (on Kerem decision): OQ-CUF-AUTH-005 (CORE_USER_FLOWS.md §3.9) and BL-1
             (AUTH_THREAT_MODEL.md §10). This report INFORMS the decision; it is not the decision.
  RELATED DOCUMENTS:
    - /docs/adr/ADR-015-authentication-strategy.md (Accepted — authoritative; KD-A/KD-B)
    - /docs/architecture/AUTH_THREAT_MODEL.md (v0.5 Accepted — §8 SMS provider, §10 BL-1,
      §15 IR-25 ceiling values; IR-25 decided Kerem 2026-06-19)
    - /docs/CORE_USER_FLOWS.md (v0.3 — §3.5.3 OTP send failure, §3.9 OQ-CUF-AUTH-005)
    - /docs/KEREM_DECISIONS.md (K-07 VERBİS, K-08 KVKK advisor, K-05 99.9% SLO, K-13/KD-B)
    - /docs/PROJECT_DECISION_INDEX.md (§2 "SMS / email / push provider" = Not locked)
    - /docs/PROJECT_METHODOLOGY.md §20.2 (KVKK process; CROSS_BORDER_TRANSFER_ASSESSMENT.md;
      DATA_PROCESSING_INVENTORY.md), §20.3 (third-party integration security review)
    - /docs/CROSS_BORDER_TRANSFER_ASSESSMENT.md (to be produced — Kerem + legal advisor, K-08)
    - /docs/DATA_PROCESSING_INVENTORY.md (to be produced — Pod A drafts, Pod B reviews, Kerem approves)
  KVKK DOCUMENTS REVIEWED (v0.2 pass, 2026-06-22):
    - Netgsm KVKK.09 Rev.02 (01.11.2025) — Kişisel Verilerin İşlenmesi Protokolü (Müşteri/Abone)
    - Netgsm KVKK.07 Rev.02 (01.11.2025) — Müşteri/Abone–Müşteri Adayı/Abone Adayı Aydınlatma Metni
    - Verimor Veri İşleme Kapsamı (HİZMETE ÖZEL) — SMS hizmeti kapsamında veri işleme bildirimi
    - İleti Merkezi: no DPA or data-residency materials received — see §18.3
  FRESHNESS BASELINE (files read fresh from refs/heads/main, HEAD b43de0d, 2026-06-22):
    PROJECT_DECISION_INDEX.md · ADR-015 · AUTH_THREAT_MODEL.md v0.5 (SHA bb1f270) ·
    KEREM_DECISIONS.md · CORE_USER_FLOWS.md v0.3 · PROJECT_METHODOLOGY.md §20
  SYNTHETIC DATA ONLY: all examples use synthetic references (Customer A, +90 555 000 00 01). No real Adeks data.
-->

## 1. Purpose

ADR-015 (Accepted) selected **Phone OTP (SMS)** as the Phase 1 `CUSTOMER` login method (KD-A) and recorded that **SMS provider selection is deferred to a separate Pod B provider report** (KD-B). The authentication threat model (Accepted, BL-2 closed) carries this forward as blocker **BL-1** and confirms the provider is an external, untrusted **data processor** handling customer phone numbers whose provider-side controls cannot be assessed until a provider is named (§8).

This report supplies that provider report. It exists to let Kerem make an informed provider decision. Its job is to:

- compare viable SMS providers for Phase 1 customer OTP across technical, reliability, abuse-control, cost, operational, and KVKK dimensions;
- make the relevant regulatory and cross-border-transfer picture explicit and current;
- give a **clear Pod B recommendation** without making the decision; and
- specify exactly what must be recorded in the repo after Kerem chooses, and what Pod C must not start until then.

**v0.2 additions (2026-06-22):** send-rate SLA derivation from AUTH_THREAT_MODEL.md v0.5 §15 IR-25 ceiling values (§17); KVKK document review for Netgsm and Verimor (§18); updated cross-border risk flags, R8 flag, DPA readiness, and legal-advisor addendum (§18 + §10 updates).

**v0.3 additions (2026-06-22):** narrow re-review incorporating Pod A post-v0.2 delta findings. §18.3 (İleti Merkezi) split into technical/commercial assessment (assessed — competitive) and KVKK/DPA assessment (unassessable — blocking); §18.4 Verimor R8 refined from "delivery mechanism unknown" to "polling preferred (R8 not triggered); webhook R8-conditional"; §6 table, §7, §9, §10 (L13), §14, §15 updated accordingly. Verimor public pricing accessibility noted (OTP = standard SMS credits; no separate OTP package required).

## 2. What this report is and is not

| It is | It is not |
|---|---|
| Decision support for KD-B / OQ-CUF-AUTH-005 / BL-1 | A decision. Provider selection is `[NEEDS KEREM APPROVAL]`. |
| Pod B's assessment of **technical fit, security, reliability, and KVKK posture** | A commercial/price negotiation. Per KD-B, **price and business terms are Kerem + Pod A.** |
| A recommendation Kerem can accept, vary, or reject | A re-opening of any locked decision. ADR-015 (Phone OTP) is locked and not reconsidered here. |
| Grounded in current Turkish regulation (2026) and public provider information | A legal opinion. KVKK conclusions below are flagged for **legal-advisor confirmation (K-08)**. |

Per ADR-015, choosing a provider unblocks BL-1 but **does not authorize Pod C work**: implementation remains separately blocked (see §11–§12).

## 3. Requirements the provider must satisfy (derived, not new)

These are drawn from ADR-015, the threat model, and CORE_USER_FLOWS.md. They are the lens for the comparison — they are not new decisions.

| # | Requirement | Source |
|---|---|---|
| R1 | **Transactional / one-time-password SMS via server-to-server API** (single send per request; not a bulk marketing channel). | ADR-015 §1; flow §3.4 |
| R2 | Delivery to all three Turkish mobile networks (Turkcell, Vodafone, Türk Telekom) for `+90` numbers. | flow §3.4 (Turkish customer base) |
| R3 | **Delivery status / failure reporting** so the backend can render the neutral "could not send" state without leaking registration status. | flow §3.5.3; CUF-AUTH-006 |
| R4 | Compatible with **app-side OTP rate limiting and abuse/cost controls** (per-IP, per-phone, and a global spend ceiling / circuit-breaker). | ADR-015 §1; IR-01, IR-25 |
| R5 | **No phone number or OTP exposure** beyond what delivery requires; API credentials held in secrets configuration, not in the user-auth layer. | ADR-015 §4; threat model B2, §8 |
| R6 | Available as a **KVKK data processor** with a written data-processing instrument; data-location and cross-border posture clear and contractible. | §20.2; threat model §8 |
| R7 | **Registered sender ID (başlık)** capability for `+90` A2P traffic. | Turkish A2P market rule (see §4) |
| R8 | No inbound webhook/callback assumed; if the provider integration introduces one, it is a **new inbound auth surface requiring a separate Pod B review**. | ADR-015 §4; threat model §8 |

App-side controls R4 (IR-01/IR-25) are **provider-independent** and are implemented by Adeks regardless of provider; they reduce but do not remove the provider dependency.

## 4. Regulatory and KVKK framing (current as of June 2026)

This is the decisive context for the comparison. The single largest differentiator between candidates is **where the customer phone number is processed**, because that determines whether a KVKK **cross-border transfer** occurs.

**4.1 Cross-border transfer regime (Law No. 7499; in force 1 June 2024; Regulation 10 July 2024).** Turkey replaced its old explicit-consent model with a GDPR-style three-tier structure: (1) a KVKK **adequacy decision**; (2) **appropriate safeguards** — most practically the KVKK-published **standard contract (standart sözleşme / SCC)**, or binding corporate rules, or a Board-approved written undertaking; (3) a narrow set of **incidental exceptions** (e.g. explicit consent, contractual necessity). The explicit-consent route was permitted only until 1 September 2024 and is no longer a routine basis. The standard contract must be used **exactly as the KVKK publishes it, in Turkish, and notified to the Authority within five business days of signing**; deviations expose the controller to investigation and fines. *(Source: KVKK Cross-Border Transfer Regulation / KVKK Guide on Cross-Border Transfers, Jan 2025; see §15.)*

**4.2 No adequacy decisions exist (2026).** As of 2026 the KVKK has **not issued any adequacy decision** for any country, sector, or organization. Consequently a transfer to a provider that processes data **outside Turkey cannot rely on tier 1** and must rest on tier-2 safeguards (the standard contract) or a tier-3 exception — a legal determination owned by the advisor (K-08). *(Source: §15.)* **Practical effect:** a provider that keeps phone-number processing **inside Turkey** avoids the cross-border-transfer obligation entirely; a provider that processes outside Turkey triggers the standard-contract-plus-notification path.

**4.3 İYS / commercial-message rules do not apply to OTP.** İYS (İleti Yönetim Sistemi) consent/opt-in and the 08:00–21:00 commercial-SMS time window apply to **commercial electronic messages (ticari elektronik ileti)**. A login OTP is a **service / transactional message initiated by the user**, not marketing, and is recognized as exempt from prior-consent and İYS opt-in requirements. `[ASSUMPTION — legal-advisor confirmation, K-08]` This is the standard treatment, but the OTP-vs-commercial classification should be confirmed by the advisor and reflected in the data inventory. *(Source: Turkish Commercial Electronic Messages Regulation / industry guidance; §15.)*

**4.4 Sender ID (başlık) registration — a lead-time item for any provider.** Turkish A2P SMS requires a **pre-registered alphanumeric sender ID containing the legitimate business name** (generic terms disallowed). Registration takes on the order of **~2 weeks** and is required before live OTP sending — whether the provider is Turkish (operator başlık registration) or global (e.g. Twilio's letter-of-authorization + carrier registration). This is a Phase-1-readiness scheduling dependency independent of the provider chosen. *(Source: Twilio Turkey sender-ID documentation; Turkey SMS compliance guidance; §15.)*

**4.5 Adjacent obligations (already tracked).** VERBİS registration before processing (K-07; go-live blocker), the 72-hour breach-notification clock (ROLLBACK_POLICY T-2 / §20.2), and the data-processing inventory / legal-basis records (§20.2) all apply regardless of provider. 2026 KVKK fines for data-security failures (including unlawful transfer) run into the tens of millions of lira; this raises the stakes of getting the cross-border instrument right.

> **Net regulatory read:** A **Turkey-hosted, BTK-licensed provider that keeps phone-number data in Turkey** is materially the lower-KVKK-risk option for Phase 1, because it removes the cross-border-transfer obligation (no standard contract, no five-business-day notification, smaller fine surface). All KVKK conclusions in this report are subject to **legal-advisor confirmation (K-08)**.

## 5. Candidate landscape

Two structural categories, distinguished primarily by data location and therefore cross-border exposure.

**Turkish, BTK-licensed providers (data processed in Turkey):**

- **Netgsm** — long-established Turkish licensed operator (STH/operator licence). Dedicated **OTP SMS** product: API-only, single (non-bulk) sends, one SMS length per message, İYS-integrated, own data centres in Turkey. Notable cost feature: **undelivered domestic SMS are refunded** (only delivered messages are charged). Off-hours support. KVKK: KVKK.09 DPA template and KVKK.07 aydınlatma metni reviewed in v0.2 — see §18.1.
- **Verimor** — BTK-authorised Turkish provider with a dedicated **OTP SMS** product, developer-friendly documented REST API (HTTP GET/POST JSON, publicly documented), **real-time delivery reporting**, and **mandatory API source-IP allowlisting** as a built-in security control. İYS-compliant. KVKK: Veri İşleme Kapsamı reviewed in v0.2 — see §18.2. Strongest explicit data-residency declaration of the three.
- **İleti Merkezi** — BTK-authorised Turkish provider, İYS-integrated, with an explicit KVKK / information-security ("trust & compliance") positioning aimed at regulation-sensitive customers. **No DPA or data-residency materials received as of v0.2 — see §18.3.**

**Global providers (data processed outside Turkey — cross-border):**

- **Twilio** (representative exemplar) — mature **Verify** OTP product with built-in OTP orchestration and fraud controls, strong SDK/observability, routes `+90` traffic through the same three Turkish carriers, requires sender-ID registration via signed authorization. Processes message data **outside Turkey** (US-primary). The same cross-border profile applies to **Vonage, AWS SNS / Pinpoint, Sinch, MessageBird/Bird, and Infobip** (Infobip has a regional/Turkey footprint that may soften but does not by itself remove the cross-border analysis — to be confirmed in its DPA).

## 6. Comparison

`[ASSUMPTION]` markers below denote items to confirm during procurement / with the provider's DPA. "Turkish providers" rows hold for Netgsm, Verimor, and İleti Merkezi unless noted. v0.2 KVKK document findings are reflected in the data-residency and DPA rows; full detail in §18.

| Dimension (R#) | Turkish providers (Netgsm / Verimor / İleti Merkezi) | Global (Twilio exemplar) |
|---|---|---|
| **Data location / cross-border (R6)** | Processed **in Turkey** → **no KVKK cross-border transfer** for OTP. Lowest-risk path. **Verimor: explicitly confirmed** in Veri İşleme Kapsamı (§18.2). **Netgsm: credible, unconfirmed at DPA level** — data-residency clause needed in KVKK.09 (§18.1, L7). **İleti Merkezi: KVKK/DPA unassessable** — no materials received; technical/commercial evidence separately assessed (§18.3). `[confirm per-provider in DPA — see §18.5 cross-border flags]` | Processed **outside Turkey** → **cross-border transfer**; needs KVKK **standard contract + 5-business-day notification** (no adequacy exists). `[whether vendor will execute the Turkish SCC is uncertain — procurement + legal]` |
| **Regulatory standing (R7)** | **BTK-licensed**, İYS-integrated, Turkish sender-ID (başlık) provisioning native. | Routes via Turkish carriers; sender-ID registration via LOA + carrier process (~2 wks). |
| **Transactional OTP fit (R1)** | **Dedicated OTP products** (single-send, API-only) — a good structural match; bulk/marketing kept separate. | **Verify** product purpose-built for OTP; also raw Programmable SMS. Strong fit. |
| **Turkey delivery reliability (R2)** `[ASSUMPTION]` | Core competency: direct local carrier routing to Turkcell/Vodafone/Türk Telekom. Expected high domestic deliverability. | Reaches the same carriers via an additional routing hop; globally strong, Turkey-specific results to be validated. |
| **Delivery reporting (R3)** | Real-time delivery reports (Verimor explicit; Netgsm refunds undelivered domestic — implies per-message delivery accounting). **Verimor: both polling (outbound API query) and webhook (push callback) delivery reporting available per public API docs; polling preferred (outbound-only; R8 not triggered); webhook R8-conditional — see §18.4.** | Detailed delivery/status callbacks and analytics. |
| **Native abuse / fraud controls (R4)** | OTP product is inherently single-send (a structural anti-flood control); Verimor has mandatory API source-IP allowlisting. App-side IR-01/IR-25 still required. | Verify **Fraud Guard** + rate limiting at the provider layer, on top of app-side IR-01/IR-25. Richest native controls. |
| **Cost structure (R4 cost)** `[price = Kerem + Pod A, KD-B]` | Prepaid domestic-SMS / OTP packages; generally **lower per Turkish SMS** than global rates; **Netgsm refunds undelivered domestic SMS**. Billed in TRY (no FX exposure). **v0.3:** Verimor public 5k/10k/25k package pricing accessible; OTP uses standard SMS credits — no separate OTP-only package required (simpler cost model than Netgsm's OTP-vs-normal pricing split). İleti Merkezi strongest apparent pricing on available offer. | Per-message + per-verification pricing; generally **higher for Turkey**; **USD billing → FX exposure**. |
| **Operational / support (R3, ops)** | **Turkish-language support**, local business hours (Netgsm off-hours too); IP-allowlisting and credential controls native. | Mature status pages, SDKs, global docs; support in English; provider SLAs published. |
| **Inbound auth surface (R8)** | OTP send is outbound-only; no inbound callback assumed. **Verimor: R8 CONDITIONAL** — polling preferred (outbound API query; R8 not triggered); webhook chosen triggers R8 review before Pod C integration (§18.4). | Verify can be outbound-only; any webhook is a new inbound surface → separate Pod B review. |
| **99.9% SLO single-point risk (K-05)** | Single-provider dependency; mitigate with app-side circuit-breaker (IR-25) + neutral failure UX (flow §3.5.3). Multi-provider failover is a Phase 2 consideration. | Same single-point consideration; large provider with published uptime, but cross-border + cost trade-offs remain. |
| **DPA instrument** | **Netgsm:** pre-existing KVKK.09 template (Rev.02, 2025) — Netgsm brings it, Adeks signs; gaps: no data-residency clause, no retention period (§18.1). **Verimor:** Adeks drafts DPA, Verimor signs; more legal prep, more drafting control (§18.2). **İleti Merkezi:** not received — KVKK-blocking (L13). Public subscription contract accessible for commercial terms; does not constitute a data-processing instrument. | DPA availability and willingness to execute Turkish standard contract uncertain — procurement + legal. |
| **Retention period (R6)** | **Verimor: explicitly 5 years** per BTK electronic-comms law, secure destruction — see §18.2. **Netgsm: not stated** in KVKK.09 — must be negotiated (§18.1). **İleti Merkezi: unknown.** | Provider-dependent; likely outside Turkish BTK framework. |

## 7. Dimension notes

- **Technical fit (R1, R8).** All candidates expose a server-to-server REST API consumable from the NestJS auth module. Turkish OTP products are deliberately single-send, which matches the OTP use case and limits blast radius. Twilio Verify offers the most "batteries-included" OTP orchestration; for a single-channel Phase 1 OTP that convenience is real but not decisive. The integration credential stays in secrets configuration outside the user-auth layer (R5 / ADR-015 §4). No inbound webhook is assumed; introducing one (any provider) triggers a separate Pod B auth review (R8). **Verimor: both polling (outbound API query for delivery status) and webhook (push callback) delivery reporting are available per public API docs. Polling is the preferred integration path (outbound-only; R8 not triggered). Webhook choice triggers a Pod B inbound auth surface review before Pod C integration — R8 CONDITIONAL for Verimor (§18.4).**
- **Turkey delivery reliability (R2) — `[ASSUMPTION]`.** Pod B has no measured Adeks delivery data and does not invent it. Local carrier routing is the Turkish providers' core competency; global providers reach the same carriers with an extra hop. Reliability should be validated with a **bounded pilot send test** to synthetic/owned test numbers before go-live, not assumed from marketing claims. The pilot test should be bounded at < 300 sends/run (§17.4).
- **OTP abuse controls (R4).** The binding controls are **app-side and provider-independent**: per-IP and per-phone OTP request rate limiting plus per-phone send cap/cooldown (IR-01), verify-side attempt limits (IR-02), and a **global send-volume / spend ceiling with circuit-breaker and anomaly alerting** (IR-25). Provider-native controls (Twilio Fraud Guard; the single-send shape of Turkish OTP products; Verimor's mandatory IP allowlisting) are **defense-in-depth on top**, not a substitute. **IR-25 ceiling values and operational response-path owner are decided (Kerem 2026-06-19): soft-alert 150/hr, hard-stop 300/hr, +100 override, ADMIN response-path owner — see AUTH_THREAT_MODEL.md v0.5 §15 and §17 below.**
- **Cost and spend control (R4 cost).** Two cost levers matter: unit price (Kerem + Pod A own this, KD-B) and **waste avoidance**. Netgsm's undelivered-domestic-SMS refund and the app-side spend ceiling (IR-25) are the main waste-avoidance mechanisms. TRY billing (Turkish providers) removes FX exposure that USD-billed global providers carry. Pod B does **not** quote per-SMS prices here — they change frequently and depend on volume and negotiation; they belong to the commercial evaluation.
- **Operational failure handling (R3).** The flow already specifies the required behavior on send failure (§3.5.3): neutral "could not send" state, **no registration-status leak**, **phone not retained on failure**, and an audit record using a derived identifier (UUID / phone hash), never the raw phone. Any provider must surface a send-failure signal the backend can map to this state. The 99.9% SLO (K-05) argues for a provider-failure runbook and the IR-25 circuit-breaker; a **dual-provider failover abstraction is a Phase 2 consideration**, not a Phase 1 requirement.
- **KVKK data-processor (R6) and cross-border (§4).** This is where the categories diverge most. A Turkey-hosted provider processing data in Turkey is, subject to legal-advisor confirmation, **not a cross-border transfer** and needs only a standard KVKK processor instrument + data-inventory entry. A global provider **is** a cross-border transfer and, absent any adequacy decision, needs the KVKK standard contract executed in Turkish exactly as published plus five-business-day notification — and it is **uncertain whether a global vendor will execute that specific Turkish instrument** (procurement + legal question). The standard contract path is workable but adds legal, contractual, and ongoing-notification overhead disproportionate to a single-café Phase 1. **v0.2 update:** Verimor's Veri İşleme Kapsamı provides the strongest explicit Turkey-only declaration of the three candidates reviewed; Netgsm's KVKK.09 is a solid DPA framework with a data-residency gap to be negotiated; İleti Merkezi remains unassessable. Full detail in §18.

## 8. App-side controls required regardless of provider (for completeness)

These are already binding via the threat model and are restated only so the decision is not misread as "the provider handles abuse":

- IR-01 per-phone OTP send cap + cooldown; per-IP and per-phone request rate limiting.
- IR-02 OTP verify-side single-use, short TTL, sufficient entropy, attempt limit, lock/expire on N failures; IR-23 no recoverable plaintext OTP before verification.
- IR-03 no phone/OTP/token/secret in logs or audit; derived identifier only.
- IR-25 global send-volume / spend ceiling + circuit-breaker + anomaly alerting + defined operational response path. **Values decided (Kerem 2026-06-19): soft-alert 150/hr, hard-stop 300/hr, +100 cashier-unilateral override (effective 400), ADMIN response-path owner. See AUTH_THREAT_MODEL.md v0.5 §15 and §17 below.**

## 9. Pod B recommendation

**Recommended direction (high confidence): select a Turkey-based, BTK-licensed, İYS-integrated SMS provider that processes phone-number data inside Turkey, for Phase 1 customer OTP.** The decisive reason is KVKK cross-border avoidance (§4.2): with no adequacy decision in force, a Turkey-hosted provider removes the standard-contract-plus-notification obligation and the larger fine surface, which is the proportionate posture for a single-café Phase 1 whose entire design is KVKK-first. Local carrier routing (deliverability), TRY billing (no FX), and Turkish-language support reinforce the choice; the main thing given up is Twilio Verify's batteries-included OTP orchestration, which app-side IR-01/IR-02/IR-25 already cover.

**Shortlist for Kerem + Pod A commercial evaluation (Pod B does not rank on price):**

- **Lead candidate — Verimor:** dedicated OTP product, publicly documented developer-friendly REST API, real-time delivery reporting, mandatory API source-IP allowlisting (a useful built-in credential/abuse control). Best-documented integration path of the three. **v0.2 update: strongest explicit KVKK data-residency declaration of all candidates reviewed** (§18.2). DPA prep falls to Adeks (Verimor signs a presented DPA); R8 delivery-mechanism check needed before integration.
- **Co-lead — Netgsm:** largest/most-established, BTK operator licence, own Turkish data centres, **undelivered-domestic-SMS refund** (direct spend-control benefit), off-hours support. Pre-existing KVKK.09 DPA template (Netgsm brings it). **v0.2 update: data-residency clause and retention period must be added via DPA negotiation** (§18.1, L7, L9).
- **Third compliant option — İleti Merkezi:** strongest apparent commercial pricing of the three; technical/API readiness confirmed via public documentation (§18.3). **v0.3 update: commercial and technical candidacy assessed; KVKK/DPA still blocking** — no DPA or data-residency materials received; cannot be confirmed as a KVKK-compliant final candidate without them (§18.3, L13). If İleti Merkezi supplies DPA + data-residency + retention/destruction evidence, it is a competitive option on commercial terms and API fit.

The choice between Verimor and Netgsm turns on **commercial terms, support experience, and a short delivery pilot** — which Kerem + Pod A own (KD-B). Pod B's position is that **both Verimor and Netgsm are architecturally and KVKK-acceptable** (with the DPA negotiation steps noted); the global option (Twilio et al.) is **not recommended for Phase 1** purely because the cross-border overhead is disproportionate, not because it is technically weak. Global providers remain a reasonable **Phase 2/3** reconsideration if multi-region scale or a failover tier is wanted, at which point the cross-border instrument can be put in place deliberately.

**Deferred (not part of this decision):** multi-provider failover abstraction (Phase 2); whether to record the selection as a standalone ADR vs. a KD-B sub-decision (Kerem's call — see §11).

## 10. Items requiring legal-advisor confirmation (K-08)

Pod B flags these explicitly; they are **legal determinations, not Pod B's to make**, and several gate the cross-border assessment. Items L1–L6 were in v0.1; items L7–L13 were added in v0.2 based on the KVKK document review.

| # | Item to confirm with the legal/privacy advisor | Added |
|---|---|---|
| L1 | **OTP is a transactional/service message exempt from İYS opt-in and the commercial-SMS time window** (§4.3) — confirm classification and reflect in the data inventory. | v0.1 |
| L2 | **Legal basis for processing the phone number** for OTP delivery (KVKK Art. 5) and its reflection in `KVKK_LEGAL_BASIS.md` and the Aydınlatma Metni (ties to BL-4). | v0.1 |
| L3 | If a **Turkey-hosted provider** is chosen: confirm the **data-processing agreement** is sufficient and that processing genuinely stays in Turkey (so **no cross-border transfer** is triggered). | v0.1 |
| L4 | If a **global provider** is chosen: confirm the lawful **cross-border mechanism** — the KVKK **standard contract** (executed in Turkish exactly as published, notified within 5 business days), and whether the vendor will execute it; or an applicable exception. | v0.1 |
| L5 | **VERBİS** declaration covers the SMS-processing activity and the chosen processor (K-07). | v0.1 |
| L6 | The provider must appear as a **data processor in `DATA_PROCESSING_INVENTORY.md`** with the phone number as the processed data category (§20.2). | v0.1 |
| L7 | **Netgsm KVKK.09 DPA must be augmented** with an explicit data-residency clause stating that phone numbers and SMS content are processed and stored in Turkey only. KVKK.09 Rev.02 is silent on data location in the operative processor instrument; without this clause L3 is not satisfied. `[DPA negotiation — see §18.1]` | v0.2 |
| L8 | **Confirm Verimor Turkey-only data-residency** in the DPA that Adeks drafts. The Veri İşleme Kapsamı declaration (KVKK m.9, Turkey-only data centres) is strong supporting evidence; the binding commitment must be in the DPA. `[DPA drafting — see §18.2]` | v0.2 |
| L9 | **Retention period must be explicit in the Netgsm DPA.** KVKK.09 Rev.02 does not state the retention duration for OTP/SMS traffic data. Confirm: what data, how long, legal basis, and secure destruction method. `[DPA negotiation — see §18.1]` | v0.2 |
| L10 | **Verimor 5-year log retention (BTK):** Confirm whether the BTK-mandated 5-year log retention (covering recipient phone numbers and SMS/OTP text content) must be disclosed in the Aydınlatma Metni (OQ-CUF-AUTH-001 / BL-5) and in DATA_PROCESSING_INVENTORY.md. Adeks cannot reduce Verimor's BTK-mandated retention; confirm disclosure obligations. `[see §18.2]` | v0.2 |
| L11 | **OTP code in Verimor SMS text content:** Confirm the DATA_PROCESSING_INVENTORY.md entry for Verimor correctly categorises OTP codes (as "İşlem Güvenliği" data, processed and logged by Verimor for delivery, short-lived at source, provider-retained per BTK) and that the legal basis for this processor activity is complete. `[see §18.2]` | v0.2 |
| L12 | **Turkish carrier routing characterisation:** Netgsm and Verimor both share the recipient GSM number and SMS content with Turkcell/Vodafone/Türk Telekom for delivery. Confirm this constitutes inherent service delivery (not a KVKK Art. 8/9 "aktarım" requiring a separate instrument), consistent with BTK licensing framework. `[applies to any Turkish provider chosen]` | v0.2 |
| L13 | **İleti Merkezi DPA/data-residency materials** needed before KVKK cross-border assessment is possible. v0.3: technical/commercial evidence has been assessed (§18.3); KVKK/DPA materials remain the blocking condition. Without them İleti Merkezi cannot be confirmed as a KVKK-compliant final candidate. `[see §18.3]` | v0.2 |

## 11. What must be recorded in the repo after Kerem decides

Selecting a provider is a status transition **into Locked** on a product/business-impacting row and therefore requires Kerem's approval (already the decision itself). On that decision, update:

| File | Change |
|---|---|
| `/docs/PROJECT_DECISION_INDEX.md` §2 | Move the **"SMS / email / push provider"** row from **Not locked** to **Locked** (or **Locked (ADR pending)** if an ADR is opened), naming the chosen provider and canonical source. Update §3 backlog if a new ADR is created. |
| `/docs/KEREM_DECISIONS.md` | Record the decision (new **K-17**, or close out **KD-B**): chosen provider + the cross-border instrument decision (Turkey-hosted → no transfer / DPA only; or global → standard contract + notification). Update the Decision Summary Table, the Open Actions row "Produce SMS provider comparison report" → done, and the revision log. |
| `/docs/CORE_USER_FLOWS.md` §3.9 | Mark **OQ-CUF-AUTH-005** resolved with the provider + a pointer to `CROSS_BORDER_TRANSFER_ASSESSMENT.md`; update Review Routing. |
| `/docs/architecture/AUTH_THREAT_MODEL.md` §8 + §10 | Close **BL-1** **only once** (a) a provider is recorded **and** (b) provider-side OTP threats are assessed and the cross-border assessment is complete. Expect a **follow-on Pod B provider-specific threat addendum** for §8 provider-side controls (delivery integrity, sender authentication, the provider's own abuse handling, API-credential storage). |
| `/docs/CROSS_BORDER_TRANSFER_ASSESSMENT.md` | **Create/populate** (Kerem + legal advisor, §20.2): for a Turkey-hosted provider, record the conclusion of no cross-border transfer (subject to L3/L8); for a global provider, record the standard-contract + 5-business-day-notification path (L4). |
| `/docs/DATA_PROCESSING_INVENTORY.md` | **Add the SMS provider as a processor** (phone number + SMS text content including OTP codes — see L11), Pod A drafts → Pod B reviews → Kerem approves (§20.2; L6). |
| ADR (optional) | If Kerem wants a durable standalone record, open **ADR-016 "SMS provider selection"**; otherwise record as a **KD-B sub-decision** under ADR-015. Either is acceptable — Kerem's choice. |

**No pod-instruction re-paste is required for this decision** — selecting a provider does not change Pod behavior, gates, or methodology, so no ADR-013 §7 instruction-update / snapshot re-paste is triggered. (Committing **this report** is documentation-only under ADR-009 §2; the §4 behavior-change gate does not fire, but under §3 the strictest applicable trigger — Authentication/authorization + Customer personal data handling + Security-sensitive — governs, so **Pod B + Kerem review before merge** applies.)

## 12. What Pod C must NOT start until the decision is recorded

Pod C remains blocked. Specifically, **no** OTP-provider work may begin until the conditions below hold:

- **No SMS-provider integration code** — no provider SDK/API client, no OTP send/dispatch implementation, no provider-credential/secrets wiring, no sender-ID-dependent send flow.
- This holds **until BL-1 is recorded** (provider chosen + provider-side threats assessed + cross-border assessment complete).
- Even after provider selection, **the other blockers still gate all auth implementation**: BL-3 (retention periods), BL-4 (KVKK legal basis), BL-5 (Aydınlatma Metni legal text), and **BL-6 (no separate Pod B + Kerem approved Pod C auth issues exist)**. ADR-015 and the threat model **do not authorize Pod C work**; implementation requires separately approved issues derived from the threat model §9, not from this document.
- IR-25 (app-side spend controls) is implementable independently of provider selection, **but** still requires a separately approved Pod C issue.

In short: **provider selection unblocks BL-1 only.** It does not start the build.

## 13. Kerem Decision Packet — SMS provider for Phase 1 customer OTP

**Decision needed:** Which SMS provider (category and named provider) for Phase 1 customer OTP, and the corresponding KVKK cross-border instrument. Resolves OQ-CUF-AUTH-005 and unblocks BL-1.

**Why now:** Customer OTP is on the Phase 1 critical path (ADR-015 KD-B); sender-ID registration alone is ~2 weeks of lead time (§4.4); VERBİS and the cross-border assessment depend on this choice.

| Option | What it means | Pros | Cons / trade-offs |
|---|---|---|---|
| **A — Turkey-hosted provider (RECOMMENDED).** Shortlist: Verimor (lead), Netgsm (co-lead), İleti Merkezi (pending KVKK docs). Final pick on commercial terms + pilot. | Phone numbers processed in Turkey; standard KVKK processor DPA; data inventory entry. | **No cross-border transfer** (no standard contract, no 5-day notification, smaller fine surface); local carrier deliverability; TRY billing (no FX); Turkish-language support; per-Turkish-SMS cost generally lower; Netgsm refunds undelivered domestic SMS; Verimor has explicit data-residency declaration. | Single-provider dependency (mitigated by IR-25 + failure UX; failover is Phase 2); less "batteries-included" OTP orchestration than Twilio Verify (covered by app-side IRs); DPA gaps to negotiate (Netgsm) or draft (Verimor). |
| **B — Global provider** (Twilio Verify exemplar; or Vonage/Infobip/AWS/Sinch/MessageBird). | Phone numbers processed outside Turkey → cross-border transfer. | Mature Verify OTP product + native Fraud Guard; strong SDK/observability; large-scale reliability heritage. | **Cross-border:** needs KVKK standard contract (Turkish, exact text, 5-day notification) — **and it is uncertain a global vendor will execute it**; USD/FX exposure; higher per-Turkish-SMS cost; disproportionate legal overhead for single-café Phase 1. |
| **C — Defer.** No selection now. | Customer OTP, BL-1, and the cross-border assessment stay open. | None for delivery. | Blocks the Phase 1 customer login path; sender-ID lead time not started; keeps BL-1 open. |

**Pod B recommendation:** **Option A** — select a Turkey-hosted provider from the shortlist; Kerem + Pod A choose the named provider on commercial terms and a short delivery pilot.

**Default if no action is taken:** **Status quo = Option C.** No provider is selected, customer OTP and BL-1 remain blocked, and the Phase 1 customer login path cannot proceed. There is no silent fallback: ADR-015 did **not** adopt the phone + PIN alternative, so deferral simply blocks customer login until a provider is chosen.

**Routing after decision:** Pod B records the repo updates in §11 (write authorization required) and produces the provider-specific threat addendum + cross-border assessment inputs; Pod A drafts the data-inventory entry and supplies commercial evaluation; legal advisor confirms L1–L13 (K-08).

## 14. Assumptions and open items

- `[ASSUMPTION]` Turkey-hosted providers process and retain phone-number data within Turkey. **Verimor: explicitly confirmed** in Veri İşleme Kapsamı (KVKK m.9, Turkey-only data centres — §18.2). **Netgsm: credible, unconfirmed at DPA level** — data-residency clause and retention period required in KVKK.09 DPA negotiation (§18.1, L7, L9). **İleti Merkezi: unassessable** — no materials (§18.3). In all cases, confirm in the executed DPA (L3).
- `[ASSUMPTION]` OTP is transactional and exempt from İYS opt-in / time-window rules (§4.3; L1).
- `[ASSUMPTION]` Per-SMS pricing and volume discounts are not quoted here; they belong to the Kerem + Pod A commercial evaluation (KD-B).
- `[ASSUMPTION]` Verimor supports both polling (outbound API query) and webhook (push callback) delivery reporting per public API docs. Polling is preferred (outbound-only; R8 not triggered); webhook triggers R8 review. Integration design must specify which is used — R8 flag is CONDITIONAL on webhook choice (§18.4).
- `[ASSUMPTION]` International SMS feature must be disabled at the Verimor account level for Phase 1 (§18.2); confirm during provisioning.
- `[ASSUMPTION]` İleti Merkezi technical/API items require written confirmation from İleti Merkezi before integration design if selected: IP restriction behaviour, OTP-vs-normal-SMS pricing equivalence (confirm OTP uses same credits), failure-reason granularity.
- `[NEEDS KEREM APPROVAL]` Provider selection (Option A/B/C) and the named provider.
- Open: whether to record the selection as ADR-016 or a KD-B sub-decision (§11).
- Open: İleti Merkezi KVKK/DPA materials — pending Pod A outreach result.

## 15. Sources consulted (regulatory and provider landscape)

Regulatory (KVKK / cross-border / İYS), paraphrased — not quoted:
- KVKK Guide on Cross-Border Transfers of Personal Data (published 2 Jan 2025) and the Regulation on the Transfer of Personal Data Abroad (Official Gazette 10 July 2024).
- Law No. 7499 amendments to Law No. 6698 (Art. 9), in force 1 June 2024; explicit-consent route permitted until 1 Sept 2024.
- Commentary confirming no KVKK adequacy decision issued as of 2026 and the standard-contract + five-business-day notification mechanism (Şengün Law; Istanbul Attorneys 2026 guide; ITIF Knowledge Base; Mondaq/Lexology summaries).
- Turkish Commercial Electronic Messages (İYS) framework and the transactional-message exemption (Law 6563; industry guidance, e.g. Mysoft/İleti Merkezi).
- Turkey SMS sender-ID registration (~2 weeks) and market/operator share (Twilio Turkey sender-ID documentation; Turkey SMS compliance guidance).

Provider landscape (public product pages), paraphrased:
- Netgsm OTP SMS product and pricing/terms pages (BTK licence, single-send OTP, undelivered-domestic refund, İYS integration, own data centres).
- Verimor OTP SMS product page and public SMS-API developer guide (REST API, delivery reporting, IP allowlisting).
- İleti Merkezi product/compliance pages (BTK authorisation, İYS integration, KVKK/info-security positioning).
- Twilio Verify / Programmable SMS and Turkey sender-ID registration documentation (representative global provider).
- Verimor SMS package/pricing page (public 5k/10k/25k package prices; OTP-as-standard-SMS-credits framing — reviewed v0.3).
- Verimor SMS API documentation (delivery report fields; polling and webhook delivery-reporting mechanisms — reviewed v0.3).
- Verimor Ses ve SMS Hizmetleri Abonelik Sözleşmesi (public subscription contract; incident action/solution windows — reviewed v0.3).
- Verimor SMS başlığı izin dilekçesi (sender-title application form and process documentation — reviewed v0.3).
- İleti Merkezi SMS API documentation (API structure, delivery reporting, IP restriction behaviour — reviewed v0.3).
- İleti Merkezi abonelik sözleşmesi (public subscription contract; commercial terms, high-level review — reviewed v0.3).

Provider KVKK documents reviewed (v0.2 pass, 2026-06-22):
- Netgsm KVKK.09 Rev.02 (01.11.2025) — Kişisel Verilerin İşlenmesi Protokolü (Müşteri/Abone). Supplied by Kerem.
- Netgsm KVKK.07 Rev.02 (01.11.2025) — Müşteri/Abone–Müşteri Adayı/Abone Adayı Kişisel Verilerinin Korunması ve İşlenmesi Aydınlatma Metni. Supplied by Kerem.
- Verimor Veri İşleme Kapsamı (HİZMETE ÖZEL) — SMS hizmeti kapsamında veri işleme bildirimi. Supplied by Kerem.

*All KVKK conclusions are subject to legal-advisor confirmation (K-08). This document is decision support; it establishes no decision and does not authorize Pod C work.*

## 16. Revision history

| Version | Date | Author | Change |
|---|---|---|---|
| v0.1 | 2026-06-11 | Pod B | Initial SMS provider comparison + Kerem decision packet. Resolves (on Kerem decision) OQ-CUF-AUTH-005 / BL-1. No decision established; no Pod C work authorized; provider selection `[NEEDS KEREM APPROVAL]`. |
| v0.3 | 2026-06-22 | Pod B | **Narrow re-review incorporating Pod A post-v0.2 delta findings.** §18.3 split into technical/commercial assessment (assessed — competitive) and KVKK/DPA assessment (unassessable — blocking). §18.4 Verimor R8 refined: both polling and webhook available per public API docs; polling preferred (R8 not triggered); webhook R8-conditional. §6 table (data-residency, delivery reporting, inbound surface, DPA instrument, cost structure rows), §7 R8 note, §9 İleti Merkezi paragraph, §10 L13, §14 assumptions, §15 sources updated. Verimor public pricing noted (OTP = standard SMS credits). No provider selected; no Pod C authorized; BL-1 remains open. |
| v0.2 | 2026-06-22 | Pod B | **KVKK document review pass.** Added §17 (send-rate SLA derivation from AUTH_THREAT_MODEL.md v0.5 §15 IR-25 ceiling values) and §18 (KVKK document review: Netgsm KVKK.09/KVKK.07 and Verimor Veri İşleme Kapsamı; İleti Merkezi unassessable — no materials). Updated §6 table (data-residency row with per-provider document findings; DPA and retention period rows added); §7 KVKK dimension note; §9 recommendation (Verimor KVKK posture strengthened; Netgsm DPA gaps noted; İleti Merkezi reduced to pending); §10 legal items (L7–L13 added); §14 assumptions (Turkey-residency updated per-provider). IR-25 values noted as decided (Kerem 2026-06-19). No provider selected; no Pod C authorized; BL-1 remains open. |

---

## 17. Send-Rate SLA Derivation (OQ-PILOT-1 Bounded Derivation)

> **Purpose.** This section auditably derives the minimum provider API send-rate requirement from the IR-25 ceiling values decided by Kerem (2026-06-19) and specified in AUTH_THREAT_MODEL.md v0.5 §15. The goal is to ensure the provider's own API rate limits sit above the app's aggregate ceiling, so the provider never becomes the hidden binding constraint before the app's circuit-breaker engages.

### 17.1 Source values (AUTH_THREAT_MODEL.md v0.5 §15.2)

| Signal | Value | Rolling window |
|---|---|---|
| Soft-alert threshold | 150 backend-approved sends | 60 minutes |
| Hard-stop (base ceiling) | 300 backend-approved sends | 60 minutes |
| Effective ceiling with +100 cashier-unilateral override active | 400 backend-approved sends | 60 minutes |
| Base-ceiling raise (ADMIN-only, no auto-expiry) | Administrator-defined | ADMIN-managed |

Counter unit (v0.5 §15.2): **backend-approved OTP sends** — sends the backend authorises after IR-01 per-IP / per-phone rate-limiting has already passed. These are the requests the backend will actually emit to the provider API.

### 17.2 Derivation logic

1. **Worst-case throughput the app will emit.** The app emits to the provider only what it authorises. The maximum authorised throughput when a +100 override is active is **400 sends / rolling 60-minute window** (v0.5 §15.2, §15.3). ADMIN base-ceiling raises sit above this band but are ADMIN-managed and rare; 400/hr is the operationally realistic maximum during normal cashier-authorised overrides.

2. **Provider must not throttle below the app ceiling.** If the provider's own API rate limit sits below 400/hr, the provider becomes the binding constraint before the app's IR-25 circuit-breaker can engage. This produces a failure mode where sends fail silently at the provider layer while the app believes it is below ceiling — undermining the cost/abuse control the circuit-breaker is designed to provide. Therefore: **the provider's API must support a sustained rate of at least 400 sends per rolling 60-minute window without provider-side throttling.**

3. **Expressed as a sustained rate.** 400 / 60 min ≈ 6.67 sends/min → rounding up: **≥ 7 sends/minute sustained.** This is a trivially low bar for any commercial SMS provider. The derivation confirms that API rate limiting is not a provider-differentiation factor at Phase 1 volumes; all shortlisted candidates are expected to satisfy it.

4. **Per-send latency.** The ceiling is a volume constraint, not a latency constraint. However, the customer-facing OTP flow requires that a send either succeeds and the user receives the code within a few seconds, or fails visibly (flow §3.5.3). A target of **≤ 2s API response time per individual send at p99** is appropriate. `[ASSUMPTION — confirm via pilot test]`

### 17.3 Provider SLA minimum summary

| Requirement | Minimum | Source |
|---|---|---|
| API send throughput | ≥ 400 sends / rolling 60-min (≥ 7/min sustained) | v0.5 §15.2–§15.3 |
| Provider must not throttle below app ceiling | Provider API rate limit ≥ 400/hr | Derived above |
| API response latency per send | ≤ 2s at p99 | `[ASSUMPTION]` — pilot validation |
| Delivery status reportable | Must expose a send-failure signal mappable to neutral "could not send" state | flow §3.5.3; R3 |

### 17.4 Pilot test bound

The bounded pilot send test (§7 reliability note; §14) should be bounded at **< 300 sends per test run** (the IR-25 hard-stop baseline). Sends must use synthetic or Adeks-owned test numbers only. The pilot measures: API call-to-delivery latency (end-to-end); delivery success rate per Turkish operator (Turkcell/Vodafone/Türk Telekom); provider error-code taxonomy for failure states (needed to map to the flow §3.5.3 neutral failure UX). The pilot is provider-selection dependent (no provider selected yet) and inherently bounded by the IR-25 app-side ceiling during any production pilot.

---

## 18. KVKK Document Review (v0.2 Pass — 2026-06-22)

> All KVKK conclusions in this section are `[ASSUMPTION]` pending legal-advisor confirmation (K-08). This section is Pod B's technical assessment, not a legal opinion. Synthetic data only.

### 18.1 Netgsm — KVKK.09 (Data Processing Protocol) and KVKK.07 (Aydınlatma Metni)

**Document roles (important distinction).**
- **KVKK.09 Rev.02 (01.11.2025):** Kişisel Verilerin İşlenmesi Protokolü — the operative **DPA instrument** governing the processor relationship between Adeks (veri sorumlusu) and Netgsm (veri işleyen) for end-user data Adeks sends Netgsm to deliver OTPs. This is the document Adeks and Netgsm would sign.
- **KVKK.07 Rev.02 (01.11.2025):** Müşteri/Abone Aydınlatma Metni — Netgsm's notice to its **own direct business customers** (i.e., Adeks as a subscriber), explaining how Netgsm processes Adeks's own business data (contact details, account info, financials, call logs). This governs Adeks's data as a customer, **not** Adeks's end-users' phone numbers flowing through the OTP service. Its relevance is as **secondary evidence** of Netgsm's general data-residency posture.

**Processor status (KVKK.09 §3).** Explicit and correct: Müşteri (Adeks) = veri sorumlusu; Netgsm = veri işleyen. Sub-processor scenario also covered. **✅ Confirmed.**

**Purpose limitation (KVKK.09 §4).** Netgsm commits to process Müşteri Verileri only per customer instructions and only for service delivery. Additional processing requires written consent or Turkish legal mandate. **✅ Adequate.**

**Cross-border transfer.** KVKK.09 does **not contain an explicit data-residency clause** for the data it processes on Adeks's behalf — the operative DPA instrument is silent on where phone numbers and SMS content are physically stored. This is a material gap. Secondary evidence from KVKK.07: for every data category in Netgsm's subscriber relationship, the cross-border field states "Yurt dışına aktarım yapılmıyor." While that notice covers Adeks-as-subscriber rather than Adeks's end-user OTP data, it is consistent with a Turkey-only posture and Netgsm's BTK operator-class licence (Ankara HQ). **Assessment: Turkey-only credible, unconfirmed at DPA level. An explicit data-residency clause must be added in DPA negotiation (L7). `[ASSUMPTION]`**

**Breach notification (KVKK.09 §9).** Netgsm commits to notify within 1 business day of learning of a security breach, without contacting data subjects first. Faster than the 72-hour KVKK clock that starts on Adeks's side. **✅ Adequate.**

**Retention period.** KVKK.09 does **not state a retention duration** for OTP/SMS traffic data while the service is active. It commits to return or delete data on contract termination (§4) but provides no retention period or BTK-regulatory grounding for that period. **This is a material gap.** Must be negotiated: what data is retained, for how long, legal basis, and destruction method (L9). `[ASSUMPTION]`

**Technical measures (KVKK.09 §9).** Mentioned but not detailed in the document. Commits to appropriate measures, staff confidentiality, role-based access, training. Lower disclosure depth than Verimor. A technical annex or separate security attestation should be requested in DPA negotiation. `[ASSUMPTION]`

**Third-party sharing (KVKK.09 §7).** No transfer without customer consent except to technology/infrastructure partners, subsidiaries, affiliates, or legal mandate. Inherent carrier routing (sharing GSM number + SMS content with Turkish operators to deliver the message) is implicit in service delivery. Confirm characterisation with legal advisor (L12).

**DPA instrument status.** KVKK.09 is a pre-existing standardised DPA template Netgsm brings to the relationship. Convenient — Netgsm does the heavy lifting on document structure. However, two material gaps need resolution before it satisfies L3: (1) no explicit Turkey-only data-residency clause (L7); (2) no retention period (L9). A DPA addendum or negotiated revision addresses both.

**KVKK.07 role clarification.** KVKK.07 covers categories including Kimlik, İletişim, Müşteri İşlem, Finans, İşlem Güvenliği, Görsel/İşitsel data — all from the Netgsm-subscriber relationship. For every category: "Yurt dışına aktarım yapılmıyor." Legal bases cited include Art. 5/2(c) (sözleşme kurulması/ifası), Art. 5/2(ç) (hukuki yükümlülük), Art. 5/2(f) (meşru menfaat), and Art. 5/1 (açık rıza). This is evidence of Netgsm's general processing posture, not the governing instrument for end-user OTP data.

**Summary — Netgsm KVKK posture: Medium-High, conditional on DPA negotiation.**

| Item | Status |
|---|---|
| Processor status | ✅ Confirmed (KVKK.09 §3) |
| Purpose limitation | ✅ Confirmed (KVKK.09 §4) |
| Data-residency claim | Credible, unconfirmed at DPA level — clause needed (L7) |
| Retention period | ❌ Not stated — must be negotiated (L9) |
| Breach notification | ✅ 1 business day (KVKK.09 §9) |
| Technical measures | Stated, not detailed — annex recommended |
| Third-party sharing | ✅ Constrained (KVKK.09 §7) |
| DPA instrument | Pre-existing template; two gaps to negotiate |

### 18.2 Verimor — Veri İşleme Kapsamı (HİZMETE ÖZEL)

**Document role.** This document is Verimor's declaration of its SMS-service-specific data processing scope, sent directly in response to a KVKK / VERBİS compliance request. It governs the exact use case (SMS delivery as veri işleyen). It is not itself a signed DPA instrument; it is supporting evidence for the DPA that Adeks would draft for Verimor to sign.

**Processor status.** Explicit: "Şirketimiz... 'Veri İşleyen' sıfatına haiz olup, paylaştığınız veri envanterindeki kurallara, sürelere ve mevzuata tam uyum sağlamaktadır." Notably, Verimor commits to comply with the customer's own data inventory rules and timelines — a stronger commitment than a generic compliance statement. **✅ Confirmed.**

**Data categories processed.** Two categories:
- İletişim Bilgisi: recipient GSM/telefon numaraları. Expected. ✅
- Müşteri İşlem / İşlem Güvenliği: SMS text content including "doğrulama şifreleri vb." (OTP codes), sending IP address, date/time, and delivery report logs.

**OTP code visibility flag.** Verimor explicitly processes OTP codes as SMS text content. This is structurally unavoidable for any SMS delivery provider — the OTP is the message body. It does not conflict with IR-23 (which governs the app's own storage). It confirms that Verimor's delivery infrastructure has visibility into OTP codes in transit. The relevant mitigation is app-side (short TTL, single-use — IR-02) and is already required. No new risk; consistent with T-C5 accepted residual in AUTH_THREAT_MODEL.md v0.5 §11. OTP codes as İşlem Güvenliği data must appear correctly in DATA_PROCESSING_INVENTORY.md (L11). `[No new risk beyond what the threat model accepts]`

**Purpose of processing.** Contractual fulfilment, SMS delivery, delivery report tracking, information security, BTK compliance. **✅ Purpose limitation adequate.**

**Operator routing.** For domestic delivery (Phase 1 relevant): GSM number and SMS content shared with Turkish GSM operators to deliver the message — inherent and expected. For international SMS: data shared with the recipient's foreign operator — international SMS must remain **disabled** for Phase 1. `[ASSUMPTION — confirm disabled at account level during provisioning]`

**Cross-border transfer.** The strongest declaration of the three candidates: "SMS altyapımızda ve sunucularımızda KVKK m.9 kapsamında yurt dışına herhangi bir veri aktarımı yapılmamakta, tüm veriler Türkiye sınırları içerisindeki yüksek güvenlikli veri merkezlerinde muhafaza edilmektedir." Unambiguous: no transfer abroad under KVKK Art. 9; all data in high-security data centres within Turkey. **✅ Best data-residency evidence of all candidates reviewed. Must be carried into the executed DPA (L8). `[ASSUMPTION — legal-advisor confirmation K-08]`**

**Retention period.** Explicit: SMS traffic and communication logs retained for **5 years** aligned to Turkish electronic-communications legislation and the customer's own data inventory; secure and irreversible destruction at end of retention. **✅ Explicit, legally grounded, with destruction commitment.** Adeks cannot reduce this BTK-mandated retention; implications for the Aydınlatma Metni and data inventory must be confirmed by the legal advisor (L10).

**Technical measures.** Most detailed of the three:
- Technical: end-to-end SSL/TLS on API and panel connections; network security / firewall; IP-restriction / strong-credential account management; **immutable access logs; periodic penetration testing.**
- Administrative: staff data-security and confidentiality agreements; **role-based authorisation (need-to-know)**; regular cybersecurity awareness training.
These measures substantively address the B2 trust-boundary risk surface (AUTH_THREAT_MODEL.md §3.3). **✅ Disclosure depth adequate for Phase 1.** `[ASSUMPTION — confirm in DPA; request penetration-test schedule evidence]`

**DPA instrument status.** Verimor does not supply a pre-prepared template; it will review and sign a DPA presented by Adeks. More legal preparation effort for Adeks; more drafting control over content (allowing explicit data-residency, retention, and security-attestation clauses to be included directly). The Veri İşleme Kapsamı document, once its commitments are incorporated into the DPA, provides a strong basis.

**Summary — Verimor KVKK posture: High, pending DPA formalisation.**

| Item | Status |
|---|---|
| Processor status | ✅ Confirmed, with inventory-compliance commitment |
| Purpose limitation | ✅ Confirmed |
| Data-residency claim | ✅ **Explicit, unambiguous** (KVKK m.9, Turkey-only data centres) — carry into DPA (L8) |
| Retention period | ✅ **5 years** (BTK), secure destruction — carry into DPA; legal implications to confirm (L10) |
| Breach notification | Not stated in this document — include in DPA |
| Technical measures | ✅ Most detailed: TLS, firewall, IP restriction, **immutable logs**, **pen testing**, RBAC |
| Third-party sharing | ✅ Turkish carriers only for domestic; international SMS to be disabled (L12) |
| DPA instrument | Adeks drafts; Verimor signs — more prep, more control |
| OTP code in logs | Inherent (İşlem Güvenliği); no new risk; data inventory entry required (L11) |

### 18.3 İleti Merkezi — v0.3 Re-Assessment

> **v0.3 note:** Pod A's delta update (2026-06-22) supplied evidence from İleti Merkezi's public API documentation, offer, and subscription contract. This section now separates technical/commercial assessability from KVKK/DPA assessability. These are independent assessments.

#### 18.3.1 Technical and Commercial Evidence (Post-v0.2 Pass — Assessed)

Based on public API documentation, offer pricing, and subscription contract reviewed in the post-v0.2 delta pass:

| Item | Evidence | Assessment |
|---|---|---|
| API / OTP send capability | Public SMS API docs confirm OTP-capable server-to-server API sending | ✅ Confirmed — R1 satisfied |
| Delivery reporting | Report API and webhook-style report mechanisms documented | ✅ Confirmed — R3 addressed; failure-reason granularity to confirm in writing |
| IP restriction | API docs indicate fixed-IP behaviour/error handling | ✅ Likely — needs written confirmation if selected |
| Test / pilot feasibility | Test account and free test credits available | ✅ Confirmed |
| Pricing position | 10k = 879 TL; 25k = 2,149 TL; 50k = 4,199 TL (offer pricing, KDV/ÖİV included) | Strongest apparent commercial pricing of the three |
| Subscription contract | Public abonelik sözleşmesi accessible for commercial-terms review | ✅ Commercial terms reviewable before selection |
| Turkish operator delivery (R2) | BTK STH licensed; İYS-integrated | ✅ Expected — validate via pilot |
| Sender-ID path | Required documents and originator setup path supplied | Approval lead time: confirm |

**Summary:** İleti Merkezi's technical/API readiness and commercial positioning are assessed and competitive. The technical profile is sufficient to retain İleti Merkezi as a shortlist candidate, subject to KVKK/DPA clearance below.

`[ASSUMPTION]` Items requiring written confirmation from İleti Merkezi before integration design if selected: IP restriction, OTP-vs-normal-SMS pricing equivalence (confirm OTP uses same package credits), failure-reason granularity, sender-title average approval time.

#### 18.3.2 KVKK/DPA Assessment (Unassessable — Blocking)

**No DPA or data-residency materials have been received for İleti Merkezi.** The following remain unassessable:

- Cross-border posture and data-residency (Turkey-only processing vs transfer abroad)
- Processor status (veri işleyen confirmation and commitment scope)
- Data categories processed, retention periods, and destruction methods
- Technical and administrative security measures for OTP/SMS data
- Breach notification commitment and timeline

A public subscription contract covering commercial terms does **not** constitute a DPA or data-processing instrument and does not satisfy the KVKK items above. İleti Merkezi **cannot be confirmed as a KVKK-compliant final candidate** without: (a) a formal DPA confirming processor status and data-handling obligations, (b) an explicit Turkey-data-residency commitment, and (c) retention periods and destruction methods (L13).

If Pod A's continued outreach yields DPA or data-residency materials, they should be shared for a follow-on Pod B KVKK pass.

**Summary — İleti Merkezi v0.3 status:**

| Dimension | Status |
|---|---|
| Technical/API readiness | ✅ Assessed — competitive; written confirmations needed before integration |
| Commercial terms | ✅ Assessed — strongest apparent pricing |
| KVKK / DPA / data-residency | ❌ Unassessable — blocking (L13) |
| Shortlist candidacy | Retained — conditional on KVKK/DPA evidence |

### 18.4 R8 Flag — Verimor Webhook / Inbound Surface

R8 (§3) requires a separate Pod B review if any provider integration introduces an inbound webhook surface. Verimor offers "real-time delivery reporting" (§5, §6). This can be implemented as:

- **Pull (polling):** app queries Verimor API for delivery status → outbound request only → **R8 not triggered.**
- **Push (webhook callback):** Verimor calls an Adeks-owned endpoint on delivery event → inbound surface → **R8 triggered; separate Pod B inbound auth surface review required before Pod C integrates.**

**v0.3 update:** Verimor's public SMS API documentation shows that both pull (polling — outbound API query for delivery status) and push (webhook callback — Verimor calls an Adeks-owned endpoint) delivery-reporting mechanisms are available. The delivery-reporting mechanism is no longer unknown; the choice is a design decision for Pod C integration.

**R8 status: CONDITIONAL for Verimor.** Polling is the preferred design (outbound-only; R8 not triggered). If webhook is chosen instead, a Pod B review of the inbound auth surface (webhook source validation, IP-pinning or HMAC signature, replay prevention) is required before Pod C integration. This does **not** require a standalone ADR — it is a discrete implementation concern within the existing B2 trust-boundary model (AUTH_THREAT_MODEL.md §3.3, §8). Scope as a requirement within the relevant Pod C issue when the integration design is confirmed.

**R8 for Netgsm and İleti Merkezi:** Assumed outbound-only (Netgsm); unknown (İleti Merkezi). Confirm for each provider during integration planning.

### 18.5 Cross-Border Risk Flags (per provider, v0.2)

| Provider | Cross-Border Risk | Evidence | Gate |
|---|---|---|---|
| **Netgsm** | **Low — credible, unconfirmed at DPA level** | KVKK.07: "Yurt dışına aktarım yapılmıyor" for all subscriber categories; BTK operator licence consistent with Turkey-based infrastructure. KVKK.09 operative DPA is silent on data location. | L7: explicit data-residency clause required in DPA negotiation. If confirmed: no standard contract, no 5-day notification. `[K-08 confirmation]` |
| **Verimor** | **Low — explicitly documented, strongest evidence** | Veri İşleme Kapsamı: unambiguous KVKK m.9 compliance, Turkey-only data centres, no transfer abroad. | L8: binding commitment to be carried into the DPA Adeks drafts. If confirmed: no standard contract, no 5-day notification. `[K-08 confirmation]` |
| **İleti Merkezi** | **Unknown — cannot assess** | No DPA or data-residency materials. | L13: materials required before any conclusion. |
| **Global (Twilio et al.)** | **High — cross-border certain** | Data processed outside Turkey; no KVKK adequacy decision exists. Needs Turkish standard contract + 5-day notification; uncertain vendor will execute it. | Not recommended for Phase 1 (§9). |
