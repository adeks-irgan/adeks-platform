# PROJECT_SEQUENCE_STATUS.md

| Field | Value |
|---|---|
| Document | `PROJECT_SEQUENCE_STATUS.md` |
| Path | `/docs/PROJECT_SEQUENCE_STATUS.md` |
| Purpose | Sequence-control mirror: current gate, authorized next move, blocked moves, required approval. |
| Owner / maintainer | Pod B |
| Confirmation | Kerem confirms on gate movement. |
| Authority | Mirror-only. Establishes no decisions. Authorizes no implementation. Creates no phase or gate. If this file conflicts with a canonical source, the canonical source governs. |
| Last confirmed | 2026-06-28 |
| Source pin | HEAD `99e0c36` |
| Data rule | Synthetic examples only; no real customer/staff/transaction/Selcafe data. |

## 1. Current gate
- **Lifecycle:** Phase 7 (Architecture & Design) in progress for *foundational* decisions only; not entered for the Selcafe-linked operating slice. (`PROJECT_METHODOLOGY.md` §3, §10; `PHASE_GATES.md` "Current Phase 1 Gate Status")
- **Product Phase 1:** customer PWA + web cashier/admin foundation. Operating-spine product direction **recorded** — Selcafe-linked customer visibility & ordering — via K-21 with KD-1/KD-2 and the K-OS operating-spine constraints. Implementation-readiness: **not ready**. (`KEREM_DECISIONS.md`; `planning/SCOPE_RECONCILIATION_OPERATING_SPINE_ALIGNMENT_v0.1.md`; `PHASE_GATES.md`)

## 2. Authorized next move
- Governance/planning artifacts may proceed under the command-keyword gate (e.g., phase-gate criteria, this surface). (`PROJECT_METHODOLOGY.md` §16.2)
- For the operating slice, the **Operating Slice Checkpoint** (now a live `PHASE_GATES.md` Phase 7 entry criterion) must be satisfied before component-level ADR, schema/API, or implementation-ready issue drafting; the steps to satisfy it are ADR-005 read-surface reconciliation and KVKK/legal review. (`PHASE_GATES.md` Phase 7 entry; `SCOPE_RECONCILIATION_OPERATING_SPINE_ALIGNMENT_v0.1.md` §1, §6; `OPEN_QUESTIONS.md`, OQ-OS series)

## 3. Currently blocked moves
- **Pod C implementation** — blocked across all feature areas. (`PHASE_GATES.md`, "Blockers Before Pod C Implementation")
- **Operating-slice component ADR / schema / API / implementation-ready issue drafting** — blocked by the **Operating Slice Checkpoint** (now a live `PHASE_GATES.md` Phase 7 entry criterion); not yet satisfied for this slice pending ADR-005 read-surface reconciliation + KVKK/legal review. (`PHASE_GATES.md` Phase 7 entry; `SCOPE_RECONCILIATION_OPERATING_SPINE_ALIGNMENT_v0.1.md` §1, §6, §7)
- **Selcafe live reads of active visit/bill/order-line** — blocked; Phase 1 posture is read-only; ADR-005 currently hard-excludes the candidate read surfaces until revised. (`adr/ADR-005-selcafe-read-only-adapter.md`; reconciliation §2, KD-1)
- **Personal-data implementation / KVKK claims** — blocked pending `DATA_PROCESSING_INVENTORY.md`, `KVKK_LEGAL_BASIS.md`, `DATA_RETENTION_POLICY.md`, `CROSS_BORDER_TRANSFER_ASSESSMENT.md` + legal advisor + Kerem. (`PHASE_GATES.md`; manifest "Legal / KVKK compliance artifacts")
- **SMS provider selection (BL-1)** — open; gates auth implementation. (`PHASE_GATES.md`)

## 4. Required approval before moving forward
- **ADR-005 read-surface** — Kerem decision to authorize revision or adopt a fallback, after Pod B reconciliation + legal/KVKK. (reconciliation §1, §6)
- **Any operating-slice implementation** — Pod B review + Kerem + legal/KVKK clearance. (reconciliation §6, §8)
- **Any repo-edit/write material** — Kerem command keyword (`PROJECT_METHODOLOGY.md` §16.2); **merge is Kerem-only** (ADR-009; control plane).

---
*Maintenance: Pod B updates this surface on gate movement and re-pins the source SHA; Kerem confirms. Mirrors `PHASE_GATES.md`, `PROJECT_DECISION_INDEX.md`, and `KEREM_DECISIONS.md` and their linked ADRs. Not a project-management dashboard — no per-pod task lists, no progress metrics, no roadmap/timeline, no open-question or decision registry (those stay in `OPEN_QUESTIONS.md`, `PROJECT_DECISION_INDEX.md`, `KEREM_DECISIONS.md`).*
