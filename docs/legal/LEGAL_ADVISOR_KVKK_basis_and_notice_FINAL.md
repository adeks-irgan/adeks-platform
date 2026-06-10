# Legal-Basis Matrix & Notice-Content Recommendations — KVKK Advisor Package (Finalized for Review)

**Prepared by:** Pod B (Architecture, Logic & Risk)
**Basis:** Pod A Product Intent (confirmed) + Pod B addendum
**Companion to:** `LEGAL_ADVISOR_BRIEF_KVKK.md`, `…_ADDENDUM_minors_marketing.md`
**Status:** Finalized for advisor review. **Confirmed product intent, *not* final project policy** — `[NEEDS KEREM APPROVAL]`. Not implementation tasks. The legal advisor is the authority on all KVKK / 5651 / ETK / İYS conclusions; every "basis" below is a **proposed** ground for the advisor to confirm.

**Locked principles preserved:** KVKK compliance; auditable admin/customer-data actions (appears as activity P14); append-only wallet/loyalty logic (P7–P8, and the consent record P13 follows the same append-only/audit pattern); human approval for customer-data logic (this document is a recommendation gated on Kerem approval, not an instruction to build).

---

## Confirmed product positions folded in

1. **Minor loyalty deferred to post-MVP** — minor accounts may exist; adult loyalty stays in MVP; minor loyalty needs advisor guidance + Kerem approval before activation.
2. **Minor registration staff-assisted, in-store** for all under-18; self-service is adult-only; no digital minor path assumed unless the advisor accepts an equivalent evidence standard.
3. **Loyalty points-expiry reminders = marketing** — excluded from the Phase 1 transactional set; if introduced, separate consent + İYS/ETK.
4. **DOB collection accepted as required** for identity/age-gating; "minimize minor data" read with the **T1 caveat** (minimize beyond legal identity, DOB-based age-gating, statutory logging, and operational compliance); DOB **not** reused for profiling/segmentation/marketing.

---

## 1. Finalized Legal-Basis Matrix

Legend — proposed KVKK Art. 5/2 grounds: **(c)** performance of a contract · **(a/ç)** legal obligation / explicitly provided by law · **(f)** legitimate interest · **consent** = explicit consent (açık rıza). *All subject to advisor confirmation.*

| # | Processing activity | Data categories (synthetic) | Purpose | Proposed basis | Statutory / sector linkage | Confirmed position |
|---|---|---|---|---|---|---|
| P1 | Adult account creation | name, phone, DOB | Membership + service | (c) + (a/ç) | 5651 identity | Self-service allowed (adult) |
| P2 | **Minor** account creation | name, phone, DOB, guardian identity | Membership + service + child protection | (c) + (a/ç); guardian **consent** for processing beyond statutory minimum — *advisor confirms* | 5651 + age-banded rules | **Staff-assisted, in-store only** |
| P3 | DOB collection & age-gating | DOB | Enforce 12/15/18 bands, hour/guardian + province school-hours rules | (a/ç) | İnternet Toplu Kullanım Sağlayıcıları Yön. | **Required; use-limited; no profiling/marketing (T1)** |
| P4 | Phone OTP / SMS auth | phone | Identification + security | (a/ç) + (f) | 5651 güvenli internet | Transactional; İYS-exempt (confirm) |
| P5 | PC-seat session records | customer ref, PC id, timestamps | Service + statutory access log | (c) + (a/ç) | 5651 | Retention floor **2 yr** |
| P6 | Internet/traffic access logs | log records | Statutory logging | (a/ç) | 5651 | Retention **2 yr**; integrity/confidentiality |
| P7 | Wallet ledger (**adult**) | append-only top-up/spend entries | Prepaid balance + financial record | (c) + (a/ç) | tax/commercial (VUK/TTK) | **Minors excluded in MVP** |
| P8 | Loyalty ledger (**adult**) | append-only point entries | Loyalty benefit | (c) **or** consent — *advisor confirms* | — | **Minor loyalty deferred post-MVP** |
| P9 | Reservation data & state machine | reservation records, transitions | Service delivery | (c) | — | In MVP |
| P10 | Payment processing | payment references | Payment + record-keeping | (c) + (a/ç) | tax/commercial | In MVP |
| P11 | Transactional/service messaging | phone/contact | OTP, reservation, order status, wallet/loyalty **status**, account notices | (c) / (f) | İYS-exempt if purely service (confirm) | Phase 1 default set |
| P12 | Marketing messaging | contact + consent ref | Promotions, win-back, birthday, cross-sell, **points-expiry reminders** | **explicit consent + İYS/ETK** | ETK 6563 / İYS | **Out of MVP**; separate track; never at account creation |
| P13 | Marketing consent record | consent type, channel, **text version**, grant/withdraw, actor | Evidence of lawful basis | (a/ç) accountability | KVKK Art. 5 + İYS | **Append-only, versioned, revocable** (if marketing launches) |
| P14 | Audit logs of admin/customer-data actions | actor, action, target, timestamp | KVKK accountability + tamper-evidence | (a/ç) + (f) | KVKK | **Append-only (locked principle)** |
| P15 | Staff individual identity (audit) | staff identity | Individual attribution of actions | (c) employment + (a/ç) | KVKK / labour | Hard requirement; **employee** data — separate subject class |

**Cross-cutting notes for the advisor:**
- **TC Kimlik No** (if collected at P1/P2) is *not* an Art. 6 special category but is subject to special-care handling — advisor confirms treatment.
- P15 is **employee** personal data — a distinct data-subject category needing its own notice/basis; flag whether it belongs in this package or a separate employee-facing one.
- The **append-only** items (P7, P8, P13, P14) all intersect the deferred **pseudonymisation ADR** (erasure vs. immutability), and P2/P3 mean that ADR must cover **minor** data explicitly.

---

## 2. Notice-Content Recommendations (Aydınlatma Metni)

The Turkish notice must satisfy the *Aydınlatma Yükümlülüğü Tebliği* mandatory elements, plus Adeks-specific clauses. Recommended content for the advisor to draft/approve:

**A. Mandatory Tebliğ elements**
- Identity of the **veri sorumlusu** (Adeks) and a representative/contact if applicable.
- **Purposes** of processing (membership, service delivery, statutory 5651 logging, security, payment/financial record, loyalty for adults).
- **Recipients & transfer purposes** — disclose processors: Selcafe (via adapter), SMS gateway, payment processor, any hosting/backup. State if any processing occurs **abroad** (then the 2024 cross-border mechanism applies).
- **Method & legal basis** of collection, mapped to the matrix above (identity/log = legal obligation; service = contract; marketing = consent).
- **Art. 11 rights** and how to exercise them.

**B. Adeks-specific clauses**
- **Minors clause** — what is collected from under-18 customers (incl. DOB), the **age-gating / child-protection purpose**, the 5651 basis, that registration is **staff-assisted in-store**, and that **loyalty for minors is not offered in MVP**.
- **DOB purpose statement** — DOB is collected to enforce statutory age/hour rules and is **not** used for profiling, segmentation, or marketing (reflects T1).
- **Transactional-vs-marketing statement** — service/account messages are part of the service; **marketing is sent only with separate, explicitly given consent**, and **never** as a condition of account creation. (Points-expiry reminders fall under marketing.)
- **No-marketing-to-minors statement.**
- **Guardian rights** — how a parent/guardian exercises Art. 11 rights on a minor's behalf, and how guardian consent (if required) is withdrawn.
- **Retention reference** — point to the Saklama ve İmha Politikası; note the 5651 **2-year** log floor and longer tax/commercial retention for financial records.

**C. Delivery & evidence (advisor confirms)**
- **When/how** the notice is presented (membership signup vs. first login vs. in-store posting) and **how delivery is evidenced**.
- Whether a **separate açık rıza metni** is needed alongside the notice (notice ≠ consent), and whether a **separate/simpler child-facing notice** is advisable.

---

## 3. Carried-forward items for the advisor & Kerem

**Advisor must still rule on:** parental-consent requirement (account vs. loyalty) and evidence standard; the İYS/ETK boundary for Phase 1 incl. the two gray rows; consent-record requirements; minor erasure vs. append-only and the "turned 18" transition; cross-border mechanism if any processing leaves Turkey; VERBİS determination.

**`[NEEDS KEREM APPROVAL]`**
- Approve this matrix + notice content as the **advisor question set** (not policy).
- Authorize opening the **Consent & Communications Model** ADR and **extending the KVKK pseudonymisation** ADR to cover minor data (per addendum §10).

---

*Regulatory references (5651 logging + age-banded minor rules; ETK 6563 / İYS; 2024 Law 7499 reform) reflect current public sources as of June 2026 and orient the conversation only. The advisor is the authority on all legal conclusions.*
