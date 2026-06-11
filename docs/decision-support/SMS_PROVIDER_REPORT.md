# SMS Provider Report — Phase 1 Customer OTP (Decision Support)

<!--
  DOCUMENT TYPE: Pod B Decision-Support Artifact (Provider comparison + Kerem decision packet)
  VERSION: v0.1
  STATUS: Draft for Kerem review. This document is DECISION SUPPORT — it does NOT
          select a provider and does NOT establish any decision. Provider selection
          is `[NEEDS KEREM APPROVAL]` and is made by Kerem with Pod A on commercial/
          price aspects (KD-B). Resolves nothing until Kerem records a decision.
  AUTHOR: Pod B — Architecture, Logic & Risk
  REVIEWER: Pod B (self) + Kerem (Authentication/authorization + Customer personal data
            handling + Security-sensitive → strictest ADR-009 §3 trigger governs:
            Pod B + Kerem before merge). Pod A reviews commercial/price aspects (KD-B).
  APPROVER: Kerem
  DATE: 2026-06-11
  CANONICAL REPO PATH: /docs/decision-support/SMS_PROVIDER_REPORT.md
                       (acceptable alternative: /docs/architecture/SMS_PROVIDER_REPORT.md —
                       Kerem's choice of home; pick one before commit)
  AUTHORITY: Derives from ADR-015 (Accepted) and AUTH_THREAT_MODEL.md (Accepted, BL-2 closed).
             ADR-015 is authoritative. This document does NOT change any decision. If this
             document and ADR-015 / the decision index ever disagree, those win.
  RESOLVES (on Kerem decision): OQ-CUF-AUTH-005 (CORE_USER_FLOWS.md §3.9) and BL-1
             (AUTH_THREAT_MODEL.md §10). This report INFORMS the decision; it is not the decision.
  RELATED DOCUMENTS:
    - /docs/adr/ADR-015-authentication-strategy.md (Accepted — authoritative; KD-A/KD-B)
    - /docs/architecture/AUTH_THREAT_MODEL.md (v0.4 Accepted — §8 SMS provider, BL-1, IR-25, T-C2/T-C2b/T-C5)
    - /docs/CORE_USER_FLOWS.md (v0.3 — §3.5.3 OTP send failure, §3.9 OQ-CUF-AUTH-005)
    - /docs/KEREM_DECISIONS.md (K-07 VERBİS, K-08 KVKK advisor, K-05 99.9% SLO, K-13/KD-B)
    - /docs/PROJECT_DECISION_INDEX.md (§2 "SMS / email / push provider" = Not locked)
    - /docs/PROJECT_METHODOLOGY.md §20.2 (KVKK process; CROSS_BORDER_TRANSFER_ASSESSMENT.md;
      DATA_PROCESSING_INVENTORY.md), §20.3 (third-party integration security review)
    - /docs/CROSS_BORDER_TRANSFER_ASSESSMENT.md (to be produced — Kerem + legal advisor, K-08)
    - /docs/DATA_PROCESSING_INVENTORY.md (to be produced — Pod A drafts, Pod B reviews, Kerem approves)
  FRESHNESS BASELINE (files read fresh from refs/heads/main, 2026-06-11):
    PROJECT_DECISION_INDEX.md SHA 0bbb3fd · ADR-015 SHA 39e9007 · AUTH_THREAT_MODEL.md SHA df9b30b (v0.4)
    KEREM_DECISIONS.md SHA 47eaa47 (v1.4) · CORE_USER_FLOWS.md SHA 6fe9b2f (v0.3) · PROJECT_METHODOLOGY.md §20 (main)
  SYNTHETIC DATA ONLY: all examples use synthetic references (Customer A, +90 555 000 00 01). No real Adeks data.
-->

## 1. Purpose

ADR-015 (Accepted) selected **Phone OTP (SMS)** as the Phase 1 `CUSTOMER` login method (KD-A) and recorded that **SMS provider selection is deferred to a separate Pod B provider report** (KD-B). The authentication threat model (Accepted, BL-2 closed) carries this forward as blocker **BL-1** and confirms the provider is an external, untrusted **data processor** handling customer phone numbers whose provider-side controls cannot be assessed until a provider is named (§8).

This report supplies that provider report. It exists to let Kerem make an informed provider decision. Its job is to:

- compare viable SMS providers for Phase 1 customer OTP across technical, reliability, abuse-control, cost, operational, and KVKK dimensions;
- make the relevant regulatory and cross-border-transfer picture explicit and current;
- give a **clear Pod B recommendation** without making the decision; and
- specify exactly what must be recorded in the repo after Kerem chooses, and what Pod C must not start until then.

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

- **Netgsm** — long-established Turkish licensed operator (STH/operator licence). Dedicated **OTP SMS** product: API-only, single (non-bulk) sends, one SMS length per message, İYS-integrated, own data centres in Turkey. Notable cost feature: **undelivered domestic SMS are refunded** (only delivered messages are charged). Off-hours support.
- **Verimor** — BTK-authorised Turkish provider with a dedicated **OTP SMS** product, developer-friendly documented REST API (HTTP GET/POST JSON, publicly documented), **real-time delivery reporting**, and **mandatory API source-IP allowlisting** as a built-in security control. İYS-compliant.
- **İleti Merkezi** — BTK-authorised Turkish provider, İYS-integrated, with an explicit KVKK / information-security ("trust & compliance") positioning aimed at regulation-sensitive customers.

**Global providers (data processed outside Turkey — cross-border):**

- **Twilio** (representative exemplar) — mature **Verify** OTP product with built-in OTP orchestration and fraud controls, strong SDK/observability, routes `+90` traffic through the same three Turkish carriers, requires sender-ID registration via signed authorization. Processes message data **outside Turkey** (US-primary). The same cross-border profile applies to **Vonage, AWS SNS / Pinpoint, Sinch, MessageBird/Bird, and Infobip** (Infobip has a regional/Turkey footprint that may soften but does not by itself remove the cross-border analysis — to be confirmed in its DPA).

## 6. Comparison

`[ASSUMPTION]` markers below denote items to confirm during procurement / with the provider's DPA. "Turkish providers" rows hold for Netgsm, Verimor, and İleti Merkezi unless noted.

| Dimension (R#) | Turkish providers (Netgsm / Verimor / İleti Merkezi) | Global (Twilio exemplar) |
|---|---|---|
| **Data location / cross-border (R6)** | Processed **in Turkey** → **no KVKK cross-border transfer** for OTP. Lowest-risk path. `[confirm data-localization in DPA]` | Processed **outside Turkey** → **cross-border transfer**; needs KVKK **standard contract + 5-business-day notification** (no adequacy exists). `[whether vendor will execute the Turkish SCC is uncertain — procurement + legal]` |
| **Regulatory standing (R7)** | **BTK-licensed**, İYS-integrated, Turkish sender-ID (başlık) provisioning native. | Routes via Turkish carriers; sender-ID registration via LOA + carrier process (~2 wks). |
| **Transactional OTP fit (R1)** | **Dedicated OTP products** (single-send, API-only) — a good structural match; bulk/marketing kept separate. | **Verify** product purpose-built for OTP; also raw Programmable SMS. Strong fit. |
| **Turkey delivery reliability (R2)** `[ASSUMPTION]` | Core competency: direct local carrier routing to Turkcell/Vodafone/Türk Telekom. Expected high domestic deliverability. | Reaches the same carriers via an additional routing hop; globally strong, Turkey-specific results to be validated. |
| **Delivery reporting (R3)** | Real-time delivery reports (Verimor explicit; Netgsm refunds undelivered domestic — implies per-message delivery accounting). | Detailed delivery/status callbacks and analytics. |
| **Native abuse / fraud controls (R4)** | OTP product is inherently single-send (a structural anti-flood control); İleti Merkezi/Verimor emphasise compliance tooling. App-side IR-01/IR-25 still required. | Verify **Fraud Guard** + rate limiting at the provider layer, on top of app-side IR-01/IR-25. Richest native controls. |
| **Cost structure (R4 cost)** `[price = Kerem + Pod A, KD-B]` | Prepaid domestic-SMS / OTP packages; generally **lower per Turkish SMS** than global rates; **Netgsm refunds undelivered domestic SMS**. Billed in TRY (no FX exposure). | Per-message + per-verification pricing; generally **higher for Turkey**; **USD billing → FX exposure**. |
| **Operational / support (R3, ops)** | **Turkish-language support**, local business hours (Netgsm off-hours too); IP-allowlisting and credential controls native. | Mature status pages, SDKs, global docs; support in English; provider SLAs published. |
| **Inbound auth surface (R8)** | OTP send is outbound-only; no inbound callback assumed. | Verify can be outbound-only; any webhook is a new inbound surface → separate Pod B review. |
| **99.9% SLO single-point risk (K-05)** | Single-provider dependency; mitigate with app-side circuit-breaker (IR-25) + neutral failure UX (flow §3.5.3). Multi-provider failover is a Phase 2 consideration. | Same single-point consideration; large provider with published uptime, but cross-border + cost trade-offs remain. |

## 7. Dimension notes

- **Technical fit (R1, R8).** All candidates expose a server-to-server REST API consumable from the NestJS auth module. Turkish OTP products are deliberately single-send, which matches the OTP use case and limits blast radius. Twilio Verify offers the most "batteries-included" OTP orchestration; for a single-channel Phase 1 OTP that convenience is real but not decisive. The integration credential stays in secrets configuration outside the user-auth layer (R5 / ADR-015 §4). No inbound webhook is assumed; introducing one (any provider) triggers a separate Pod B auth review (R8).
- **Turkey delivery reliability (R2) — `[ASSUMPTION]`.** Pod B has no measured Adeks delivery data and does not invent it. Local carrier routing is the Turkish providers' core competency; global providers reach the same carriers with an extra hop. Reliability should be validated with a **bounded pilot send test** to synthetic/owned test numbers before go-live, not assumed from marketing claims.
- **OTP abuse controls (R4).** The binding controls are **app-side and provider-independent**: per-IP and per-phone OTP request rate limiting plus per-phone send cap/cooldown (IR-01), verify-side attempt limits (IR-02), and a **global send-volume / spend ceiling with circuit-breaker and anomaly alerting** (IR-25). Provider-native controls (Twilio Fraud Guard; the single-send shape of Turkish OTP products) are **defense-in-depth on top**, not a substitute. **IR-25's ceiling value and operational response-path owner remain `[NEEDS KEREM APPROVAL]`** (threat model §10) and should be settled alongside this decision.
- **Cost and spend control (R4 cost).** Two cost levers matter: unit price (Kerem + Pod A own this, KD-B) and **waste avoidance**. Netgsm's undelivered-domestic-SMS refund and the app-side spend ceiling (IR-25) are the main waste-avoidance mechanisms. TRY billing (Turkish providers) removes FX exposure that USD-billed global providers carry. Pod B does **not** quote per-SMS prices here — they change frequently and depend on volume and negotiation; they belong to the commercial evaluation.
- **Operational failure handling (R3).** The flow already specifies the required behavior on send failure (§3.5.3): neutral "could not send" state, **no registration-status leak**, **phone not retained on failure**, and an audit record using a derived identifier (UUID / phone hash), never the raw phone. Any provider must surface a send-failure signal the backend can map to this state. The 99.9% SLO (K-05) argues for a provider-failure runbook and the IR-25 circuit-breaker; a **dual-provider failover abstraction is a Phase 2 consideration**, not a Phase 1 requirement.
- **KVKK data-processor (R6) and cross-border (§4).** This is where the categories diverge most. A Turkey-hosted provider processing data in Turkey is, subject to legal-advisor confirmation, **not a cross-border transfer** and needs only a standard KVKK processor instrument + data-inventory entry. A global provider **is** a cross-border transfer and, absent any adequacy decision, needs the KVKK standard contract executed in Turkish exactly as published plus five-business-day notification — and it is **uncertain whether a global vendor will execute that specific Turkish instrument** (procurement + legal question). The standard contract path is workable but adds legal, contractual, and ongoing-notification overhead disproportionate to a single-café Phase 1.

## 8. App-side controls required regardless of provider (for completeness)

These are already binding via the threat model and are restated only so the decision is not misread as "the provider handles abuse":

- IR-01 per-phone OTP send cap + cooldown; per-IP and per-phone request rate limiting.
- IR-02 OTP verify-side single-use, short TTL, sufficient entropy, attempt limit, lock/expire on N failures; IR-23 no recoverable plaintext OTP before verification.
- IR-03 no phone/OTP/token/secret in logs or audit; derived identifier only.
- IR-25 global send-volume / spend ceiling + circuit-breaker + anomaly alerting + defined operational response path. **Ceiling value and response-path owner: `[NEEDS KEREM APPROVAL]`.**

## 9. Pod B recommendation

**Recommended direction (high confidence): select a Turkey-based, BTK-licensed, İYS-integrated SMS provider that processes phone-number data inside Turkey, for Phase 1 customer OTP.** The decisive reason is KVKK cross-border avoidance (§4.2): with no adequacy decision in force, a Turkey-hosted provider removes the standard-contract-plus-notification obligation and the larger fine surface, which is the proportionate posture for a single-café Phase 1 whose entire design is KVKK-first. Local carrier routing (deliverability), TRY billing (no FX), and Turkish-language support reinforce the choice; the main thing given up is Twilio Verify's batteries-included OTP orchestration, which app-side IR-01/IR-02/IR-25 already cover.

**Shortlist for Kerem + Pod A commercial evaluation (Pod B does not rank on price):**

- **Lead candidate — Verimor:** dedicated OTP product, publicly documented developer-friendly REST API, real-time delivery reporting, and mandatory API source-IP allowlisting (a useful built-in credential/abuse control). Best-documented integration path of the three.
- **Co-lead — Netgsm:** largest/most-established, BTK operator licence, own Turkish data centres, **undelivered-domestic-SMS refund** (direct spend-control benefit), off-hours support. Strongest on reliability heritage and cost-waste avoidance.
- **Third compliant option — İleti Merkezi:** strong explicit KVKK / information-security positioning; viable if its commercial terms or compliance tooling are preferred.

The choice between these three turns on **commercial terms, support experience, and a short delivery pilot** — which Kerem + Pod A own (KD-B). Pod B's position is that **any of the three is architecturally and KVKK-acceptable**; the global option (Twilio et al.) is **not recommended for Phase 1** purely because the cross-border overhead is disproportionate, not because it is technically weak. Global providers remain a reasonable **Phase 2/3** reconsideration if multi-region scale or a failover tier is wanted, at which point the cross-border instrument can be put in place deliberately.

**Deferred (not part of this decision):** multi-provider failover abstraction (Phase 2); whether to record the selection as a standalone ADR vs. a KD-B sub-decision (Kerem's call — see §11).

## 10. Items requiring legal-advisor confirmation (K-08)

Pod B flags these explicitly; they are **legal determinations, not Pod B's to make**, and several gate the cross-border assessment:

| # | Item to confirm with the legal/privacy advisor |
|---|---|
| L1 | **OTP is a transactional/service message exempt from İYS opt-in and the commercial-SMS time window** (§4.3) — confirm classification and reflect in the data inventory. |
| L2 | **Legal basis for processing the phone number** for OTP delivery (KVKK Art. 5) and its reflection in `KVKK_LEGAL_BASIS.md` and the Aydınlatma Metni (ties to BL-4). |
| L3 | If a **Turkey-hosted provider** is chosen: confirm the **data-processing agreement** is sufficient and that processing genuinely stays in Turkey (so **no cross-border transfer** is triggered). |
| L4 | If a **global provider** is chosen: confirm the lawful **cross-border mechanism** — the KVKK **standard contract** (executed in Turkish exactly as published, notified within 5 business days), and whether the vendor will execute it; or an applicable exception. |
| L5 | **VERBİS** declaration covers the SMS-processing activity and the chosen processor (K-07). |
| L6 | The provider must appear as a **data processor in `DATA_PROCESSING_INVENTORY.md`** with the phone number as the processed data category (§20.2). |

## 11. What must be recorded in the repo after Kerem decides

Selecting a provider is a status transition **into Locked** on a product/business-impacting row and therefore requires Kerem's approval (already the decision itself). On that decision, update:

| File | Change |
|---|---|
| `/docs/PROJECT_DECISION_INDEX.md` §2 | Move the **"SMS / email / push provider"** row from **Not locked** to **Locked** (or **Locked (ADR pending)** if an ADR is opened), naming the chosen provider and canonical source. Update §3 backlog if a new ADR is created. |
| `/docs/KEREM_DECISIONS.md` | Record the decision (new **K-17**, or close out **KD-B**): chosen provider + the cross-border instrument decision (Turkey-hosted → no transfer / DPA only; or global → standard contract + notification). Update the Decision Summary Table, the Open Actions row "Produce SMS provider comparison report" → done, and the revision log. |
| `/docs/CORE_USER_FLOWS.md` §3.9 | Mark **OQ-CUF-AUTH-005** resolved with the provider + a pointer to `CROSS_BORDER_TRANSFER_ASSESSMENT.md`; update Review Routing. |
| `/docs/architecture/AUTH_THREAT_MODEL.md` §8 + §10 | Close **BL-1** **only once** (a) a provider is recorded **and** (b) provider-side OTP threats are assessed and the cross-border assessment is complete. Expect a **follow-on Pod B provider-specific threat addendum** for §8 provider-side controls (delivery integrity, sender authentication, the provider's own abuse handling, API-credential storage). Also settle **IR-25** ceiling value + response-path owner. |
| `/docs/CROSS_BORDER_TRANSFER_ASSESSMENT.md` | **Create/populate** (Kerem + legal advisor, §20.2): for a Turkey-hosted provider, record the conclusion of no cross-border transfer (subject to L3); for a global provider, record the standard-contract + 5-business-day-notification path (L4). |
| `/docs/DATA_PROCESSING_INVENTORY.md` | **Add the SMS provider as a processor** (phone number), Pod A drafts → Pod B reviews → Kerem approves (§20.2; L6). |
| ADR (optional) | If Kerem wants a durable standalone record, open **ADR-016 "SMS provider selection"**; otherwise record as a **KD-B sub-decision** under ADR-015. Either is acceptable — Kerem's choice. |

**No pod-instruction re-paste is required for this decision** — selecting a provider does not change Pod behavior, gates, or methodology, so no ADR-013 §7 instruction-update / snapshot re-paste is triggered. (Committing **this report** is documentation-only under ADR-009 §2; the §4 behavior-change gate does not fire, but under §3 the strictest applicable trigger — Authentication/authorization + Customer personal data handling + Security-sensitive — governs, so **Pod B + Kerem review before merge** applies.)

## 12. What Pod C must NOT start until the decision is recorded

Pod C remains blocked. Specifically, **no** OTP-provider work may begin until the conditions below hold:

- **No SMS-provider integration code** — no provider SDK/API client, no OTP send/dispatch implementation, no provider-credential/secrets wiring, no sender-ID-dependent send flow.
- This holds **until BL-1 is recorded** (provider chosen + provider-side threats assessed + cross-border assessment complete).
- Even after provider selection, **the other blockers still gate all auth implementation**: BL-3 (retention periods), BL-4 (KVKK legal basis), BL-5 (Aydınlatma Metni legal text), and **BL-6 (no separate Pod B + Kerem approved Pod C auth issues exist)**. ADR-015 and the threat model **do not authorize Pod C work**; implementation requires separately approved issues derived from the threat model §9, not from this document.
- IR-25 (app-side spend controls) is implementable independently of provider selection, **but** still requires its ceiling value + response-path owner (`[NEEDS KEREM APPROVAL]`) and a separately approved Pod C issue.

In short: **provider selection unblocks BL-1 only.** It does not start the build.

## 13. Kerem Decision Packet — SMS provider for Phase 1 customer OTP

**Decision needed:** Which SMS provider (category and named provider) for Phase 1 customer OTP, and the corresponding KVKK cross-border instrument. Resolves OQ-CUF-AUTH-005 and unblocks BL-1.

**Why now:** Customer OTP is on the Phase 1 critical path (ADR-015 KD-B); sender-ID registration alone is ~2 weeks of lead time (§4.4); VERBİS and the cross-border assessment depend on this choice.

| Option | What it means | Pros | Cons / trade-offs |
|---|---|---|---|
| **A — Turkey-hosted provider (RECOMMENDED).** Shortlist: Verimor (lead), Netgsm (co-lead), İleti Merkezi. Final pick on commercial terms + pilot. | Phone numbers processed in Turkey; standard KVKK processor DPA; data inventory entry. | **No cross-border transfer** (no standard contract, no 5-day notification, smaller fine surface); local carrier deliverability; TRY billing (no FX); Turkish-language support; per-Turkish-SMS cost generally lower; Netgsm refunds undelivered domestic SMS. | Single-provider dependency (mitigated by IR-25 + failure UX; failover is Phase 2); less "batteries-included" OTP orchestration than Twilio Verify (covered by app-side IRs). |
| **B — Global provider** (Twilio Verify exemplar; or Vonage/Infobip/AWS/Sinch/MessageBird). | Phone numbers processed outside Turkey → cross-border transfer. | Mature Verify OTP product + native Fraud Guard; strong SDK/observability; large-scale reliability heritage. | **Cross-border:** needs KVKK standard contract (Turkish, exact text, 5-day notification) — **and it is uncertain a global vendor will execute it**; USD/FX exposure; higher per-Turkish-SMS cost; disproportionate legal overhead for single-café Phase 1. |
| **C — Defer.** No selection now. | Customer OTP, BL-1, and the cross-border assessment stay open. | None for delivery. | Blocks the Phase 1 customer login path; sender-ID lead time not started; keeps BL-1 open. |

**Pod B recommendation:** **Option A** — select a Turkey-hosted provider from the shortlist; Kerem + Pod A choose the named provider on commercial terms and a short delivery pilot. Settle IR-25's ceiling value and response-path owner in the same decision.

**Default if no action is taken:** **Status quo = Option C.** No provider is selected, customer OTP and BL-1 remain blocked, and the Phase 1 customer login path cannot proceed. There is no silent fallback: ADR-015 did **not** adopt the phone + PIN alternative, so deferral simply blocks customer login until a provider is chosen.

**Routing after decision:** Pod B records the repo updates in §11 (write authorization required) and produces the provider-specific threat addendum + cross-border assessment inputs; Pod A drafts the data-inventory entry and supplies commercial evaluation; legal advisor confirms L1–L6 (K-08).

## 14. Assumptions and open items

- `[ASSUMPTION]` Turkey-hosted providers process and retain phone-number data within Turkey — standard for BTK-licensed operators; **confirm in each provider's DPA** (L3).
- `[ASSUMPTION]` OTP is transactional and exempt from İYS opt-in / time-window rules (§4.3; L1).
- `[ASSUMPTION]` Per-SMS pricing and volume discounts are not quoted here; they belong to the Kerem + Pod A commercial evaluation (KD-B).
- `[NEEDS KEREM APPROVAL]` Provider selection (Option A/B/C) and the named provider.
- `[NEEDS KEREM APPROVAL]` IR-25 global spend ceiling value + operational response-path owner (threat model §10).
- Open: whether to record the selection as ADR-016 or a KD-B sub-decision (§11).

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

*All KVKK conclusions are subject to legal-advisor confirmation (K-08). This document is decision support; it establishes no decision and does not authorize Pod C work.*

## 16. Revision history

| Version | Date | Author | Change |
|---|---|---|---|
| v0.1 | 2026-06-11 | Pod B | Initial SMS provider comparison + Kerem decision packet. Resolves (on Kerem decision) OQ-CUF-AUTH-005 / BL-1. No decision established; no Pod C work authorized; provider selection `[NEEDS KEREM APPROVAL]`. |
