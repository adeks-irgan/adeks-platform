# Session Linking — QR Handshake Design (Phase 1 Operating Slice) — v0.1

<!--
  ARTIFACT TYPE : Pod B design/analysis (architecture, logic & risk). Pre-implementation.
  CANONICAL HOME: TBD by Kerem (candidate: docs/planning/SESSION_LINKING_QR_HANDSHAKE_DESIGN_v0.1.md).
                  NOT YET COMMITTED — command-keyword gated (gitpp/gitpcc/gitcc).
  STATUS        : Does NOT authorize Pod C, schema/API work, ADR-005 edits, SelcafeAdapter
                  implementation, direct Selcafe writes, Selcafe reads, real data, or replica
                  provisioning. It is Operating Slice Checkpoint EVIDENCE for this slice, not a pass.
  GROUNDING     : Drafted against repo HEAD pinned bb0a732 (2026-06-30). To be re-pinned and
                  re-verified at push time.
  DATA RULE     : Synthetic data only (Customer A, Station 12, fiş 100045, code DSC-7Q2X-…).
-->

## Status

| Field | Value |
|---|---|
| Document | `SESSION_LINKING_QR_HANDSHAKE_DESIGN_v0.1.md` |
| Project | Adeks Platform |
| Owner | Pod B — Architecture, Logic & Risk |
| Reviewer / Approver | Kerem (sole merge authority) |
| Status | v0.1 draft — design/analysis; checkpoint evidence |
| Canonical repo path | TBD by Kerem (candidate `/docs/planning/…`) |
| Implementation status | Does **not** authorize Pod C |
| Selcafe posture | Read-only (ADR-005 D-1); no Adeks writes to Selcafe |
| Pinned HEAD (grounding) | `bb0a732` — re-pin/re-verify at push |

---

## 1. Purpose

Define the Phase-1 flow by which a customer's Adeks app **binds to a PC session that the cashier created in Selcafe**, for the approved operating slice (Selcafe-linked customer visibility and ordering, K-21).

The binding is established by a **desk-side, one-time QR handshake** — not by the customer typing a receipt number. This **supersedes the typed-`fiş` linking path** in `CORE_USER_FLOWS.md` §4 (steps 4–7) and the "`fiş numarası` is the customer-facing visit link" framing in K-21/K-OS.

Pre-implementation. This artifact is design + risk analysis and Operating Slice Checkpoint **evidence**; it does not itself satisfy the checkpoint (§9) and authorizes no build.

---

## 2. Why the linking method changed (context)

The original spine had the customer **type or scan the printed `fiş numarası`** to link (`CORE_USER_FLOWS.md` §4 step 4; K-21). Round-0 elicitation in this session confirmed two operational facts that make a typed-`fiş` link unsafe:

- The `fiş` is the **plain `adisyon.adisyon_no`** — a monotonic `int` PK over ~1.8M rows (spike §6.2/§9). This is **FINDING A** (reconciliation v0.3 §1/§5, SR-003-5): a typed bill number is a **cross-customer enumeration surface**. The bills most worth targeting (customers in the café *now*) are the most recent numbers, hence the easiest to guess.
- The printed receipt **includes the PC number**, and Selcafe's receipt format **cannot be changed** by Adeks (read-only legacy). So the `fiş` cannot be made unguessable at source, and the scannable receipt **barcode is the same plain number** (not a QR) — scanning adds no secrecy.

A typed/scanned-`fiş` link therefore could not be made safe at the entry point. The QR handshake **removes the typed entry point entirely**: there is no bill-number field to attack, so the FINDING A enumeration surface is **eliminated**, not merely mitigated.

> Note: the printed receipt still exists in the café workflow. What is removed is **typed-`fiş` entry as the app linking key**, not the receipt itself.

---

## 3. Decisions recorded this session (Kerem-decided)

These were decided by Kerem during the session-opening elicitation. They are recorded here as the design basis; **canonical capture is pending** in the Pod-A-owned product flow and Kerem's decision log (§10). Marked `[NEEDS KEREM APPROVAL]` only where the canonical record still needs the formal amendment.

| ID | Decision |
|---|---|
| SL-1 | Linking is **exclusively** via a desk-side **one-time QR handshake**. No typed/scanned-`fiş` entry path exists in the app. |
| SL-2 | **Two scan directions**, both supported for flexibility and error handling: (a) Adeks shows a QR on the **customer-facing desk screen** → customer scans with their phone; (b) customer shows their **own app QR** → cashier scans it at the desk. |
| SL-3 | The QR token is **cryptographically random, single-use, bound to exactly one (PC, Adeks session-link)**, expires in seconds, and is burned on first scan. Re-display mints a fresh token and invalidates the prior one. |
| SL-4 | The **PC↔session association is manual first** (cashier selects the PC, or scans at the PC). **Adeks auto-detecting the PC is a fast-follow, sequenced behind the legal read clearance** (§7), because auto-detect requires reading Selcafe to infer which PC just started. |
| SL-5 | **No late-joiner fallback.** A customer who wants to link later **revisits the cashier** for a fresh QR. The earlier "link within ~10 minutes of session start" window is **dropped** — linking is in-the-moment at the desk. |
| SL-6 | **Guests (no Adeks account) can place F&B orders and see the full live bill, itemized lines included.** An Adeks account (phone OTP, ADR-015) is required **only** for discounts, coupons, and points. Consistent with K-OS-001. |
| SL-7 | A **first-timer** who scans the desk QR lands in the live bill **as a guest**; phone signup is offered **alongside, not in front of,** ordering. |

`[PRODUCT IMPLICATION — POD A ALIGNMENT NEEDED]` SL-1/SL-5/SL-6 change a Pod-A-owned, Kerem-approved product flow (`CORE_USER_FLOWS.md` §4) and the K-21/K-OS decision wording. See §10.

---

## 4. Actors

| Actor | Role in this flow |
|---|---|
| Customer | Arrives, gets a PC session from the cashier, links via QR, views the live bill, orders F&B. |
| Customer app (PWA) | Scans/shows the QR; displays the live bill; offers signup alongside ordering. |
| Customer-facing desk screen | Displays the Adeks QR for the customer to scan (direction a). |
| Cashier | Starts the Selcafe session; starts the matching Adeks session-link for the same PC; can scan the customer's QR (direction b); resolves wrong-PC/order issues. |
| Cashier Adeks UI | Lists **only PCs/sessions not yet linked in Adeks**; lets the cashier pick the PC and trigger/scan the handshake. |
| Selcafe | Creates and owns the session; remains **read-only to Adeks** and the settlement source of truth. |
| Adeks backend | Mints/validates the one-time token; holds the Adeks-native session-link record; reads the live bill (gated). |

---

## 5. Main flow — both scan directions

In **both** directions the binding is established by **physical co-presence at the desk** plus a **one-time token**. No bill number is ever typed; there is no enumeration surface.

### 5.1 Direction A — screen shows QR (default)

| Step | Actor | Action | Note |
|---:|---|---|---|
| 1 | Cashier | Starts the PC session in **Selcafe** (creates the `adisyon` for that station). | Unchanged from the spine; Selcafe owns the session. |
| 2 | Cashier | Starts the matching **Adeks session-link** for the **same PC** in the cashier UI. | The start screen lists **only unlinked** PCs/sessions, so the right one is selected. PC selection is **manual** (SL-4); auto-detect is the gated fast-follow. |
| 3 | Adeks backend | Mints a **one-time token** bound to that one (PC, session-link); renders it as a **QR on the customer-facing screen** with a few-seconds expiry. | Nothing guessable, nothing reusable. |
| 4 | Customer | **Scans the QR** with their phone (or app-install landing). | |
| 5 | Adeks backend | Validates the token (unused, unexpired, bound to that PC/session), **binds the app session to the session-link**, and **burns the token**. | Fail-closed on any validation failure. |
| 6 | Customer app | Shows the **live bill** for that session (PC, start time, running total, F&B item lines — read gated, §7). Guest can order; signup offered alongside. | |

### 5.2 Direction B — cashier scans the customer (fallback / first-timer with app)

| Step | Actor | Action | Note |
|---:|---|---|---|
| 1 | Cashier | Starts the PC session in **Selcafe**. | As above. |
| 2 | Customer app | Displays the customer's **own one-time QR**. | Assumes the app is already open. |
| 3 | Cashier | At the desk for that **specific PC** (manual selection / scan at the PC), **scans the customer's QR** with the desk scanner. | |
| 4 | Adeks backend | **Binds the app session to the session-link** for that PC; **burns the token**. | Fail-closed. |
| 5 | Customer app | Shows the **live bill**; ordering/signup as above. | |

---

## 6. QR handshake design (security spine)

| Property | Rule |
|---|---|
| Token | Cryptographically secure random; **single-use**; bound to exactly **one (PC, Adeks session-link)** pair. |
| Expiry (TTL) | Seconds-scale. `[ASSUMPTION]` candidate ~30–60s; Pod-B-tunable against desk UX. A leaked/photographed QR is dead within the window. |
| Burn | Invalidated on **first successful scan**; re-display mints a fresh token and invalidates the prior. |
| Binding | The token resolves **only** to an Adeks-native session-link record (app session ↔ PC). It is **not** a Selcafe member lookup. |
| Abuse controls | Rate-limit token minting per cashier station; fail-closed on any token validation failure; never confirm a token's prior existence. |
| Member-resolution rule (ADR-005 D-3a) | The handshake binds **app session → PC**, never **app session → member**. Adeks never reads or derives `adisyon.uye_no`. |

**Why this is safe.** There is **no guessable identifier and no typed-bill-number field** anywhere in the flow. Linking requires being **physically at the desk** while staff starts the session. A one-time, seconds-TTL token defeats replay and photo capture. **FINDING A is eliminated** for the open path.

---

## 7. Read-only boundary and the live-bill read

**How Adeks observes a session it did not create, without writing to Selcafe (D-1):**

- Selcafe **creates and owns** the session (cashier-initiated). Adeks holds its **own** session-link record (app session ↔ PC ↔ token) — **Adeks-native data, not a Selcafe write**.
- To show the **live bill**, Adeks resolves the linked PC (`masa`) to its current bill via **`masa.aktif_adisyon_no`**, used **server-internally only** under the **v0.3 §3 Q4 narrow exception** (identity-free, non-propagating). It then reads the **minimized non-identity projection** of that one `adisyon` + its `detay` lines (reconciliation v0.3 §4): PC/station, start/times, `toplam_tutar` (running/settled total), F&B item lines.
- `adisyon.uye_no`, staff FKs, `uye.bakiye`, credentials, and member identity/profile are **never read** (grant-denied; SR-003-6/7).
- The QR opt-in **strengthens the lawful-basis posture** for this read (clear, physical, contemporaneous consent to link) but does **not** remove the requirement for the read-surface expansion and legal sign-off (§8).

**System boundary stays read-only.** The session-link, the token, and the live-bill *read* are all either Adeks-native or gated reads. The only Adeks-originated value that reaches Selcafe is the discount-reflection row — entered by the **cashier human bridge**, not an Adeks write (separate item; PR #116 / K-OS-008).

**Auto-detect PC (SL-4 fast-follow) is gated.** Inferring which PC just started a session requires reading `masa.durum` / `baslangic_zaman` / `aktif_adisyon_no` — the same gated Selcafe read. So **auto-detect sits behind the legal read clearance and the ADR-005 read-surface expansion**; **manual PC selection is the Phase-1 path** and needs none of that.

---

## 8. Privacy / KVKK line

| Question | Position |
|---|---|
| What is **read** from Selcafe | Minimized non-identity projection of the **one linked bill** + its F&B lines (station, times, `toplam_tutar`, item lines). Never `uye_no`, staff FKs, member identity/profile, balance, or credentials. |
| What is **shown** | The **full live bill including itemized lines**, to the QR-linked customer (guest or account) — Kerem-decided (SL-6), justified by physical desk opt-in. |
| Member resolution (D-3a) | **Never.** The handshake links app→PC, not app→member. |
| Structural privacy gain | Because linking requires the desk handshake and **no unlinked session is reachable** without it, the "lucky guess reads a stranger's orders" risk is **structurally removed**, not just mitigated. Most customers never link, and their bills are simply never surfaced by Adeks. |
| Account / OTP | Phone OTP (ADR-015) is **opt-in** for discounts/coupons/points; not required to link or order. **OTP/SMS is therefore off the open-flow critical path** — the `AUTH_THREAT_MODEL.md` SMS ceilings (IR-25) do not gate this flow; they apply only when a customer chooses account features. |

`[NEEDS KEREM APPROVAL]` / legal gate: the **human KVKK advisor must clear the live-bill read** before any read is built. The tightened question set in reconciliation v0.3 §8 still stands (lawful basis for reading the claimant's own bill; guest≠member case; retention; minimization). The QR opt-in improves the posture; it does not close the gate. KVKK artifacts remain **absent** at HEAD: `KVKK_LEGAL_BASIS.md`, `DATA_RETENTION_POLICY.md`, `CROSS_BORDER_TRANSFER_ASSESSMENT.md`.

---

## 9. Locked-posture checks and the checkpoint

- `[LOCKED PRINCIPLE CONFLICT]` — **none on read-only (D-1).** The QR handshake and session-link are Adeks-native; the live-bill *read* is gated, not a write. Read-only posture is preserved.
- **Append-only ledgers (ADR-006/007) — untouched.** Nothing here writes to or derives the Adeks wallet/loyalty balance from Selcafe.
- **Product-flow change (not an architectural conflict).** SL-1/SL-5/SL-6 change the **linking mechanism** away from the K-21 typed-`fiş` approach. This is a **Kerem-decided product-direction change**, not Pod B re-opening a locked decision — but the **canonical record has not yet caught up**. Routed as `[PRODUCT IMPLICATION — POD A ALIGNMENT NEEDED]` (§10).
- **Operating Slice Checkpoint (Phase 7).** This artifact is checkpoint **evidence** — it supplies the reconciled design and the `[LOCKED PRINCIPLE CONFLICT]` determination (none on D-1) for this slice. It does **not** satisfy the checkpoint, which requires a **Kerem-approved, committed, reconciled end-to-end operating-slice model** (a Pod A artifact) incorporating QR linking.

---

## 10. Required follow-ups (canonical capture + gates)

1. **Pod A reconciliation (product flow).** Replace the typed-`fiş` linking path in `CORE_USER_FLOWS.md` §4 (steps 4–7, actors/preconditions) with the QR handshake; reflect SL-1/SL-5/SL-6. `[PRODUCT IMPLICATION — POD A ALIGNMENT NEEDED]`
2. **Kerem decision-log capture.** The SL-1…SL-7 decisions (and the consequent change to the K-21/K-OS "`fiş` is the visit link" wording) belong in `KEREM_DECISIONS.md` as a Kerem-approved amendment — the same pattern as the K-OS-008 amendment in PR #116.
3. **Legal/KVKK clearance.** Human advisor signs off the live-bill read (v0.3 §8). Gating for any read.
4. **Operating Slice Checkpoint.** Kerem-approved, committed, reconciled slice model (Pod A) incorporating QR linking; this design is evidence toward it.
5. **ADR-005 v1.2 read-surface expansion.** Still required for the live-bill read (per v0.3 §1/§4, ADR-009 §4 gate). Downstream of legal + checkpoint.
6. **Auto-detect PC (SL-4).** Sequenced **behind** the legal read clearance; manual PC selection is the Phase-1 path.

**Parked separately (not in scope here):** retiring the Selcafe membership system — a larger decision with data-migration and money/KVKK implications; to be scoped on its own.

---

## 11. Open / edge cases (for later Pod B review)

| Case | Behavior |
|---|---|
| Wrong PC linked (cashier picks/scans the wrong PC) | Same operational-slip class as today; cashier corrects. The unlinked-only start list reduces it. `[REQUIRES POD B REVIEW]` correction handling. |
| QR expires before scan | Re-mint a fresh token (prior invalidated). |
| Token scanned twice / replayed | Burned after first use; fail-closed. |
| Customer declines to link | No Adeks session; they use the PC via Selcafe normally. |
| Late joiner | Revisit the cashier for a fresh QR (no in-seat linking, SL-5). |
| Selcafe live-bill read stale/unreliable | Hide financial values / show last-updated, per `CORE_USER_FLOWS.md` §4.5. |
| Mis-ordered onto a stranger's session (residual) | Low harm: food is handed over **by PC number** by the cashier (Phase-1), so a bogus order is caught and the attacker gains nothing. The real exposure was *seeing* the bill — closed structurally by §8. |

---

## 12. What must not proceed

No Pod C; no schema/API contracts; no `SelcafeAdapter` implementation; no ADR-005 edit; no direct Selcafe writes; no Selcafe reads; no real data; no replica provisioning; **no repo commit of this document** until a command keyword (gitpp/gitpcc/gitcc) is given — until (i) this analysis is accepted, (ii) legal/KVKK clears the live-bill read (§8), (iii) Pod A reconciles the product flow and Kerem's decision log captures SL-1…SL-7 (§10), (iv) the Operating Slice Checkpoint is satisfied for this slice, and (v) ADR-005 v1.2 lands through the ADR-009 §4 gate.

---

## 13. Review routing

- **Pod B drafts → Kerem reviews/approves** (sole merge authority).
- **Product-flow implications → Pod A** (`CORE_USER_FLOWS.md` §4 + decision-log amendment). *This session does not draft that handoff in advance (one handoff at a time).*
- **Legal/KVKK → human advisor** (live-bill read sign-off).
- **Pod D → later/optional** (desk-screen / scanner UX, monitoring) once Pod B defines the risk/audit boundary.
