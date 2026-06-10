# Pod B Brief — Engaging the Legal Advisor on KVKK Documents

**Prepared by:** Pod B (Architecture, Logic & Risk)
**For:** Kerem → external legal advisor (KVKK/data protection counsel)
**Scope:** `PRIVACY_NOTICE_TR.md` (Aydınlatma Metni), `KVKK_LEGAL_BASIS.md`, `DATA_RETENTION_POLICY.md`
**Status:** Reference/prep material — *not* legal advice. The advisor is the legal authority; Pod B's role is to assemble the technical facts and frame the questions.

> **`[ASSUMPTION]`** The data inventory below is reconstructed from the domain model and project context. **Confirm it against `/docs/PROJECT_BRIEF.md` and the canonical domain model before sending anything to the advisor.** If a data category is wrong or missing, the advisor's whole analysis shifts.

---

## 1. What the three documents are, and how they relate

These are not three independent deliverables — they are one chain. The legal-basis analysis is the engine; the notice and the retention policy are its two public/operational outputs.

| Document | Turkish anchor | KVKK anchor | Purpose |
|---|---|---|---|
| **`KVKK_LEGAL_BASIS.md`** | Veri işleme hukuki dayanak matrisi | Art. 5 (general), Art. 6 (special categories) | The internal master record: *every* processing activity mapped to a lawful ground. Everything else derives from this. |
| **`PRIVACY_NOTICE_TR.md`** / **Aydınlatma Metni** | Aydınlatma Yükümlülüğü | Art. 10 + the *Aydınlatma Yükümlülüğünün Yerine Getirilmesinde Uyulacak Usul ve Esaslar Hakkında Tebliğ* | The customer-facing notice telling data subjects what is collected, why, on what basis, with whom shared, how long kept, and their Art. 11 rights. Must be **given before/at collection**. |
| **`DATA_RETENTION_POLICY.md`** | Kişisel Veri Saklama ve İmha Politikası | Art. 7 + *Kişisel Verilerin Silinmesi, Yok Edilmesi veya Anonim Hale Getirilmesi Hakkında Yönetmelik* | The retention/destruction schedule: how long each category is kept, the trigger to delete/anonymise, and the destruction method. Required as a written policy for VERBİS-registered controllers. |

**Sequencing for the advisor:** legal basis first → it dictates what the notice must say and what the retention schedule's "keep until" triggers are. Don't let the advisor finalise the notice before the basis matrix is agreed.

---

## 2. The fact that dominates all three: Adeks is a *ticari amaçla internet toplu kullanım sağlayıcı*

A physical internet café (~130 PCs) is a **commercial collective internet-use provider** under **Law No. 5651** and the *İnternet Toplu Kullanım Sağlayıcıları Hakkında Yönetmelik* (Art. 5). This creates **legal obligations** that are themselves a KVKK lawful ground (Art. 5/2 — legal obligation / explicitly mandated by law), and they set a **retention floor** the advisor cannot reduce:

- **Access logs must be recorded electronically and retained for 2 years**, with integrity/accuracy/confidentiality preserved (Yönetmelik Art. 5/1-d).
- **Identity/user-identification** systems (e.g. SMS-based) and **content filtering + güvenli internet** are mandatory; the café holds a **permit (izin belgesi)** from the mülki idare amiri.
- **Family/child-protection** measures are mandatory — directly relevant because internet cafés serve minors, who are a sensitive data-subject group under KVKK.

**Why this matters for the brief:** the PC-seat session data your platform records (which customer used which PC, when) is effectively the personal-data layer of the 5651 log obligation. So part of your processing has a *statutory* basis (no consent needed) and a *fixed* retention period (2 years) — but it also raises the children/minors question front and centre. Make sure the advisor analyses KVKK **and** 5651 together, not in isolation.

---

## 3. Data inventory to hand the advisor `[ASSUMPTION — confirm against repo]`

Give the advisor a per-category table like this (illustrative; correct against the real domain model). Synthetic examples only.

| Data category | Example | Purpose | Likely basis (advisor confirms) | Likely retention driver |
|---|---|---|---|---|
| Identity (name, possibly TC Kimlik No) | Customer A | Membership + 5651 identification | Legal obligation / contract | 5651 (2 yr); TC Kimlik may be special-handling |
| Phone number | +90 555 000 00 01 | SMS auth (güvenli internet), notifications | Legal obligation / contract | 5651-linked |
| PC-seat session records | Customer A on PC-042, 14:00–15:30 | Service delivery + 5651 access log | Legal obligation (5651) | **2 years (statutory floor)** |
| Internet/traffic access logs | per-session log | 5651 mandated | Legal obligation | **2 years** |
| Wallet ledger (append-only) | top-up / spend entries | Prepaid balance, financial record | Contract; also commercial/tax law | Tax/commercial law (long — e.g. years) |
| Loyalty ledger (append-only) | points earned/redeemed | Loyalty programme | Contract or **consent** (advisor decides) | Programme lifetime |
| Reservation data | seat reservation, state transitions | Service delivery | Contract | Short / service lifetime |
| Payment data | card/cash references | Payment processing | Contract / legal obligation | Tax/commercial law |
| **Minors' data** | customer under 18 | service to minors | special handling — parental consent? | needs explicit ruling |

Also tell the advisor, for data-flow mapping:
- **Where data is stored** (on-prem PostgreSQL vs. any cloud/hosting). If anything is hosted or processed **abroad** (cloud DB, SMS gateway, analytics, backups), say so explicitly — the 2024 cross-border regime applies.
- **Third parties / processors:** the **Selcafe** legacy system (via the adapter), the **SMS gateway**, any **payment processor**, any **backup/cloud** provider. Each is a data-sharing / processor relationship the notice must disclose.
- **Who internally** can access what (staff roles).

---

## 4. The five issues most likely to bite — flag each to the advisor

1. **`[PRODUCT IMPLICATION — POD A ALIGNMENT NEEDED]` Append-only ledger vs. right-to-erasure (Art. 7 / Art. 11).** The wallet and loyalty ledgers are **append-only by design** (immutable audit integrity). KVKK gives data subjects a right to erasure when the purpose ends. These collide. **Ask the advisor whether pseudonymisation/anonymisation of the identity fields — while preserving the financial ledger rows — is an acceptable erasure approach, and which fields may be detached vs. must be retained for tax/commercial law.** This answer directly unblocks the deferred KVKK pseudonymisation ADR.

2. **Minors.** Internet cafés serve under-18s; 5651 imposes child-protection duties and there are hour restrictions for minors. KVKK treats children as needing heightened protection. **Ask: can minors be members, what consent (parental) is required, and what are the hour/access constraints?**

3. **2024 reform (Law 7499) — legal bases & cross-border.** The reform (in force 1 Jun 2024) **expanded the lawful grounds for special-category data** and replaced the old explicit-consent-heavy cross-border model with a **three-tier regime** (adequacy decision / appropriate safeguards incl. KVKK standard contractual clauses / narrow derogations), with a **5-business-day notification** when SCCs are signed. Explicit consent is **no longer valid** for regular/repeated transfers abroad. **Only relevant if any data leaves Turkey — confirm the hosting/SMS/payment footprint.**

4. **VERBİS registration.** Whether Adeks must register in VERBİS depends on thresholds (employee count / annual balance / activity). **Ask the advisor to make the determination** — it dictates whether the written Saklama ve İmha Politikası and periodic destruction cycle are legally mandatory vs. good practice.

5. **`[PRODUCT IMPLICATION — POD A ALIGNMENT NEEDED]` Loyalty/marketing messaging.** If the loyalty programme or SMS sends *marketing* (not transactional/auth) messages, that likely needs **separate explicit consent** and **İYS (İleti Yönetim Sistemi)** registration under the e-commerce (ETK) regime — a distinct track from KVKK. **Ask the advisor to separate transactional vs. commercial messaging consent.**

---

## 5. What to ASK the advisor (organised by deliverable)

**On `KVKK_LEGAL_BASIS.md`:**
- For each processing activity, confirm the Art. 5 (or Art. 6) ground, and where **explicit consent (açık rıza)** is genuinely required vs. avoidable via contract performance / legal obligation / legitimate interest.
- Confirm the 5651-driven activities can rest on *legal obligation* (no consent).
- Is TC Kimlik No (if collected) handled as special category or under special rules?

**On `PRIVACY_NOTICE_TR.md` / Aydınlatma Metni:**
- Review/approve the **content** against the Tebliğ's mandatory elements.
- Confirm **when and how** it must be presented (kiosk on first login? membership signup? posted in-store?) and **how delivery is evidenced**.
- Confirm whether a **separate açık rıza metni** is needed alongside the notice (notice ≠ consent).

**On `DATA_RETENTION_POLICY.md`:**
- Confirm the **retention period per category**, reconciling three pressures: 5651 (2-yr log floor), tax/commercial law (VUK/TTK — long retention for financial records), and KVKK (delete when purpose ends).
- Confirm the **destruction obligation cadence** (periodic destruction cycle) and acceptable **methods** (deletion / destruction / anonymisation).
- Rule on the **ledger anonymisation approach** from §4.1.

**Cross-cutting:**
- VERBİS determination (§4.4).
- Whether a **veri sorumlusu temsilcisi / contact person / DPO-equivalent** is required.
- **Breach-notification** procedure and timelines to the Authority and data subjects.
- Cross-border mechanism if data leaves Turkey (§4.3).
- İYS/ETK for marketing messaging (§4.5).

---

## 6. What to EXPECT back (deliverables checklist)

A complete engagement should return:

- ☐ **Reviewed/approved Aydınlatma Metni** (Turkish), Tebliğ-compliant, with prescribed delivery method.
- ☐ **Açık rıza metni** (separate consent text) *if* required.
- ☐ **Legal-basis matrix** — every activity → confirmed Art. 5/6 ground.
- ☐ **Retention & destruction schedule** (Saklama ve İmha Politikası), per-category periods + triggers + methods, reconciling 5651 / tax / KVKK.
- ☐ **VERBİS determination** (register: yes/no, and if yes, the obligations that follow).
- ☐ **Written opinion on the append-only ledger vs. erasure** question (which fields anonymise, which must persist, and how that satisfies Art. 7).
- ☐ **Minors handling ruling** (membership eligibility, parental consent, hour limits).
- ☐ **Cross-border / processor guidance** (Selcafe, SMS, payment, hosting) — DPAs/SCCs as needed.
- ☐ **Breach-response procedure.**

Practical asks: request **Turkish-language final texts** (the notice and consent must be in Turkish), an indication of **review cadence** (when these need re-checking, e.g. on regulatory change), and a note on **2026 fine exposure** so you can size the risk.

---

## 7. How this feeds the architecture (for Pod B follow-up)

- The advisor's **ledger-anonymisation ruling** is the missing input for the deferred **KVKK pseudonymisation ADR** — once received, Pod B can draft it (which fields carry the FK to identity, how anonymisation preserves balance derivation and audit integrity, and the destruction job design).
- The **retention periods** become concrete constraints on schema (audit fields, soft-delete/anonymise columns) and on the destruction job Pod C will build.
- The **legal-basis matrix** maps onto the consent/notice capture points in the customer onboarding flow (a product surface — Pod A alignment).

`[NEEDS KEREM APPROVAL]` Confirm the data inventory in §3 against the repo before this brief is used externally.
`[NEEDS KEREM APPROVAL]` Confirm the hosting/processor footprint (on-prem vs. cloud, SMS/payment providers, any non-Turkey processing) — it decides whether §4.3 applies at all.

---

*Regulatory points (2024 Law 7499 reform; 5651 / Toplu Kullanım Sağlayıcı 2-year log obligation) reflect current public sources as of June 2026 and are provided to orient the conversation, not as legal advice. Defer to the advisor on all legal conclusions.*
