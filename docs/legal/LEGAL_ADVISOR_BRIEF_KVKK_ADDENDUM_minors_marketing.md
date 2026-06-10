# Pod B Addendum — Minors & Marketing (KVKK Legal-Advisor Package)

**Prepared by:** Pod B (Architecture, Logic & Risk)
**In response to:** Pod A Product Intent Response v0.1 (provisional)
**Companion to:** `LEGAL_ADVISOR_BRIEF_KVKK.md`
**Status:** Recommendations and questions — *not* legal conclusions, *not* implementation requirements. Pod A's positions are treated as provisional product intent. The advisor is the legal authority; all of this is `[NEEDS KEREM APPROVAL]` before becoming project policy.

---

## 0. Bottom line for Kerem

Pod A's intent is internally coherent and aligns with KVKK/İYS best practice (minors allowed but constrained; wallet off for minors in MVP; loyalty conditional; Phase 1 transactional-only; marketing as a separate future consent track). **No locked decision is re-opened and no stop condition is triggered.** Three *bounded tensions* need the advisor to reconcile (not contradictions — they have clean resolutions), and one new architecture decision (consent + age-gating model) should be opened as an ADR. Details below.

---

## 1. Tensions to put in front of the advisor (with Pod B's proposed resolution)

**T1 — "Minimize minor data" vs. statutory duties.** Pod A wants minimal collection and no profiling of minors. But two laws *require* data about minors:
- **5651** requires identifying *every* café user (incl. minors) and retaining access logs 2 years — minors are not exempt from the identity/log duty.
- The **İnternet Toplu Kullanım Sağlayıcıları Yönetmeliği** imposes **age-banded** access rules: under-12 only with a guardian (all hours); under-15 not admitted after 20:00 without a guardian; plus province-level **school-hours bans** for students that vary by governorate.
- *Resolution to confirm with advisor:* collecting **date of birth** (not just a minor flag) for minors is **necessary and proportionate** because it is required to enforce the 12/15/18 bands and the statutory child-protection duty. Minimization is satisfied by limiting *use* of that data to access-gating and legal compliance — not by refusing to collect it. **`[PRODUCT IMPLICATION — POD A ALIGNMENT NEEDED]`** Pod A's "minimize" intent must be read as "minimize beyond what 5651/age-gating require," not "avoid age data."

**T2 — Loyalty for minors vs. profiling / parental consent.** Loyalty accrual processes a minor's transaction history and builds a benefit profile — even if non-monetary, it is still personal-data processing about a child, on an **append-only** ledger. *Resolution to confirm:* (a) loyalty **enrollment** must be **decoupled from café access** — a minor denied/lacking parental consent can still use the café (service basis) but simply does not accrue points; (b) the advisor rules whether parental consent is a precondition to loyalty enrollment for minors.

**T3 — Append-only ledgers vs. minor erasure rights.** Minors enjoy heightened protection and are more likely to later exercise erasure. The wallet/loyalty ledgers are append-only. This **amplifies** the existing (deferred) KVKK pseudonymisation question rather than creating a new one — the pseudonymisation ADR must explicitly cover minor-data handling and a "right to be forgotten on reaching majority / on request" path.

None of T1–T3 re-opens a locked decision. They are reconciliations for the advisor + Kerem.

---

## 2. Legal-basis matrix — additions (advisor confirms grounds)

| Processing activity | Provisional product intent | Likely basis (advisor confirms) | Pod B note |
|---|---|---|---|
| Minor account creation | Allowed | Contract + legal obligation (5651) | DOB required for age-gating |
| Minor age-gating / access control | Configurable by law | Legal obligation | Drives 12/15/18 + province rules |
| Minor wallet | Disabled in MVP | n/a (feature off) | Re-assess if enabled → consumer-law + consent |
| Minor loyalty enrollment | Allowed, conditional | **Consent (likely parental)** — advisor confirms | Decouple from access |
| Transactional messaging (OTP, reservation, wallet/loyalty *status*) | Phase 1 default | Contract / legitimate interest | İYS-exempt if purely service (confirm) |
| Marketing messaging | Out of MVP scope | **Explicit consent + İYS** | Separate track; not at account creation |
| Marketing consent record | Required if marketing launches | — (this *is* the consent evidence) | Versioned, auditable, revocable |

---

## 3. Aydınlatma Metni (notice) — content recommendations

Add to the notice content list for the advisor to review:
- A **minors section** stating what data is collected from under-18 customers, the age-gating purpose, the 5651 basis, and that loyalty enrollment for minors may require guardian consent.
- A plain-language statement that the platform **does not market to minors** and **does not behaviorally segment** them (matches Pod A intent).
- A clear **transactional-vs-marketing** statement: account/service messages are sent as part of the service; marketing is sent **only** with separate consent.
- The **Art. 11 rights** block including how a guardian exercises rights on a minor's behalf.
- *Question for advisor:* is a **separate, simpler child-facing notice** advisable, or one notice with a minors clause?

---

## 4. Minor-data processing assessment (Pod B)

- **Necessary minor data:** identity + DOB (age-gating, 5651), phone (SMS auth), session/seat + access logs (5651). All have statutory/contractual basis.
- **Conditional minor data:** loyalty transaction history (only if enrolled with required consent).
- **Excluded by design (MVP):** wallet/stored value for minors; any behavioral profiling, segmentation, or marketing targeting of minors (aligns with Pod A).
- **Architectural seam needed:** an **age/policy gate** that, given DOB + current time + branch province config, returns an access decision (admit / admit-with-guardian / deny-by-hour) and a feature decision (wallet off, loyalty requires-consent). This is a clean, testable seam Pod C can implement once the policy values are legally fixed.
- **Majority transition:** logic to re-evaluate status when a customer turns 18 (lift minor gates; revisit consent basis). Flag to advisor: does turning 18 change the lawful basis or trigger a re-consent?

---

## 5. Parent/guardian consent — analysis (questions for advisor)

- Is parental/guardian consent **required** for: (a) a minor account, (b) loyalty enrollment, (c) processing beyond the 5651 minimum?
- **Capture method** (Pod A open question): Pod B recommends **staff-assisted, in-store** capture for minors at first registration — it lets staff verify ID/age (also serving the 5651 identity duty) and witness guardian consent. Pure self-service kiosk registration for minors is **not recommended** (cannot reliably verify age or guardian). Advisor confirms whether a digital path is acceptable.
- **Verifiable consent:** what evidence standard does KVKK expect (signed form, recorded identity of guardian, consent text version)? This dictates the consent-record schema.
- **Revocation:** how a guardian withdraws consent, and the downstream effect (stop loyalty accrual; anonymise per retention policy).

---

## 6. Age-verification recommendations

- Collect **date of birth** (resolves the 12 / 15 / 18 bands) — a binary minor flag is **insufficient** because rules are age-banded *and* time-of-day *and* province-specific.
- Make **all** age/hour rules **configurable per branch/province** (Pod A's "configurable policy" intent is correct and now justified by the province-varying school-hours bans). The platform must **not** hard-code hours.
- Recommend **staff-assisted ID check** at minor registration (dual-purpose: 5651 identity + age proof).
- Keep DOB **use-limited** to age-gating and legal compliance; do not feed it into marketing/profiling (matches Pod A).

---

## 7. İYS / ETK applicability assessment

Under ETK (Law 6563) + the Commercial Communication regulation, **commercial electronic messages** require prior consent and sender registration in **İYS (İleti Yönetim Sistemi)**. **Transactional/service** messages are exempt. Classification of Pod A's message list:

| Message | Pod B classification | İYS/consent |
|---|---|---|
| OTP / security | Transactional | Exempt |
| Reservation confirm/update | Transactional | Exempt |
| Order status | Transactional | Exempt |
| Wallet transaction notice | Transactional | Exempt |
| Account/service notice | Transactional | Exempt |
| **Loyalty balance update** | Transactional **only if** triggered by the customer's own transaction; **gray** if pushed periodically | Confirm with advisor |
| **Loyalty points-expiry reminder** | **Gray → treat as marketing** unless advisor rules otherwise (Pod A open question) | Likely consent + İYS |
| Promotions / discounts / win-back / birthday / cross-sell | Marketing | **Consent + İYS required** |

*Pod B position:* Phase 1 (transactional only) likely **does not** trigger İYS — but the advisor must confirm the boundary, and the **two gray rows** decide whether İYS is in scope at all for Phase 1. Recommend conservative default: anything with promotional intent = marketing.

---

## 8. Consent-separation recommendations

- **Account creation must never auto-enroll** marketing consent (matches Pod A; KVKK + İYS both require this).
- Model marketing consent as a **separate, versioned, auditable consent record**: consent type, channel (SMS/WhatsApp/email/push), the **version of the consent text** agreed to, grant/withdraw timestamps, and actor. This is effectively an **append-only consent ledger** — same audit pattern as wallet/loyalty, and the same pseudonymisation considerations apply to it.
- Marketing participation **must not gate** account or café usage.
- The consent record must support **easy withdrawal** and propagate withdrawal to İYS.

---

## 9. Risk register — additions

| ID | Risk | Likelihood | Impact | Mitigation |
|---|---|---|---|---|
| R-K1 | Minor served without required age-gating (after-hours / guardian rule breach) | Med | High (admin fine, permit risk) | DOB + configurable age/hour gate; staff verification |
| R-K2 | Minor data over-collected or used for profiling | Low–Med | High (KVKK, child protection) | Use-limit DOB; exclude minors from marketing/segmentation |
| R-K3 | Loyalty enrolled for minor without valid parental consent | Med | High | Decouple enrollment from access; consent precondition |
| R-K4 | Marketing/gray message sent without consent + İYS | Med | High (KVKK + ETK fines) | Conservative classification; consent+İYS before any marketing |
| R-K5 | Consent record not versioned/auditable → can't prove lawful basis | Med | High | Append-only consent ledger w/ text version |
| R-K6 | Minor erasure request vs append-only ledger | Med | Med–High | Pseudonymisation ADR must cover minor data |
| R-K7 | Province-specific school-hour rules not configurable → non-compliance on relocation/expansion | Low | Med | Per-branch policy config seam |
| R-K8 | "Turned 18" status not transitioned → stale gating/consent | Low | Med | Majority re-evaluation logic |

---

## 10. ADR recommendations

1. **Extend the deferred KVKK pseudonymisation ADR** to explicitly cover **minor data** and a majority/erasure path (T3, R-K6).
2. **Open a new ADR — "Consent & Communications Model"** (candidate): covers the separate transactional-vs-marketing consent track, the versioned/auditable consent-record (append-only) schema, the İYS integration seam, and the age/hour **policy-gate seam** (configurable per branch/province). This is architecturally significant and behavior-changing → an ADR is warranted. `[NEEDS KEREM APPROVAL]` to open it. (Kerem's call whether age-gating is folded in or split into its own ADR.)

Pod B will draft both once (a) the advisor returns the consent/minor rulings and (b) Kerem authorizes opening the ADR(s).

---

## 11. Pod B responses to Pod A's open questions (recommendations, not decisions)

- *Min age for self- vs staff-assisted registration?* → **Recommend staff-assisted for all under-18** (ID/age verification + guardian consent witnessing); self-service for adults. Advisor confirms.
- *Parental consent digital / in-store / both?* → **Recommend in-store at minor registration** for MVP (verifiability); a digital path can follow if the advisor accepts an equivalent evidence standard.
- *Minor loyalty in MVP or deferred?* → **Recommend deferring minor loyalty enrollment until the parental-consent ruling is in**; allow adult loyalty in MVP. Low cost to defer, removes the largest minor-consent risk from MVP.
- *Points-expiry reminders — operational or marketing?* → **Recommend classifying as marketing** (conservative) pending advisor ruling; keep out of Phase 1 transactional set.

---

## 12. Additions to the legal-advisor question set

Append to `LEGAL_ADVISOR_BRIEF_KVKK.md` §5:
- Confirm minor account + DOB collection as necessary/proportionate under KVKK given 5651 + age-banded rules.
- Rule on parental consent: required for account? for loyalty? evidence standard? capture method (in-store/digital)?
- Confirm the İYS/ETK boundary for Phase 1 and rule on the two gray message types (loyalty balance update, points-expiry reminder).
- Confirm the consent-record requirements (versioning, revocation, İYS propagation).
- Rule on minor erasure vs append-only ledger and the "turned 18" transition.

---

*Regulatory points (5651 age-banded minor rules: under-12 guardian-only, under-15 no entry after 20:00 without guardian, province-level school-hours bans; ETK/İYS consent regime; 2024 Law 7499 reform) reflect current public sources as of June 2026 and orient the conversation only. Defer to the advisor on all legal conclusions.*
