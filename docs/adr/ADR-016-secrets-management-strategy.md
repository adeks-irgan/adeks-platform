# ADR-016: Secrets Management Strategy

<!--
  STATUS: Accepted — 2026-06-23 (Kerem approval).
  AUTHOR: Pod B — Architecture, Logic & Risk
  CREATED: 2026-06-23
  CANONICAL REPO PATH: /docs/adr/ADR-016-secrets-management-strategy.md
  TASK REF: SECURITY_REVIEW.md SR-001 (homes the secrets-management approach);
            named dependency of ADR-005 SR-003-3 / §8.4 (Selcafe read-only credential),
            ADR-015 IR-04 (JWT signing key) and IR-14 (TOTP secret encryption key),
            and AUDIT_EVENT_SCHEMA §7 / KD-C (audit anchoring signing material).
  HEAD SHA AT AUTHORING: 49f997011d1aec7423dacddc28e90c251919954f
  SOURCES READ LIVE AT THIS SHA (this session):
    - docs/SECURITY_REVIEW.md            (blob 173ed4c6…) — SR-001, §4.5, §4.6, §7, R-2/IR-03 references, SR-007
    - docs/adr/ADR-005-selcafe-read-only-adapter.md (blob ff89c1c1…) — SR-003-1/3, §8.4, D-6, K-A1/K-A2 (Accepted 2026-06-23)
    - docs/PROJECT_DECISION_INDEX.md     (blob 544adb88…) — locked stack/tenancy/auth; hosting Not locked (K-05/K-08); ADR-012 precedent; §19 ADR backlog (016 free)
  SOURCES NOT RE-READ THIS SESSION (relied on via the above; the write session MUST re-verify):
    - PROJECT_METHODOLOGY.md (§16.2 keyword gate; §19 ADR backlog; §20.1 secure SDLC; §23 incident response)
    - AGENT_CONTEXT_MANIFEST.md (new-path registration for CI path-integrity check)
    - architecture/AUTH_THREAT_MODEL.md (IR-04 / IR-14 binding text)
    - architecture/AUDIT_EVENT_SCHEMA.md (§7 KD-C anchoring — characterization here is [ASSUMPTION], taken from SECURITY_REVIEW §4.5/SR-001)
    - ADR-015-authentication-strategy.md (IR-04 / IR-14 source text)
    - PROJECT_BRIEF.md (hosting / ops context)
  MERGE GATE: Pod B + Kerem (strictest ADR-009 §3 trigger — security-sensitive). Kerem is sole merge authority.
  IMPLEMENTATION AUTHORITY: This ADR does NOT authorize Pod C. It designs no migrations,
          writes no code, creates no issues, and provisions no infrastructure.
  DATA: Synthetic data only. NO secret values, key bytes, connection strings, or credentials
          appear anywhere in this document. Secret NAMES below are illustrative placeholders.
-->

## Status

**Accepted** — 2026-06-23 (Kerem approval).

This ADR homes **`SECURITY_REVIEW.md` SR-001** (secrets management implied but not consolidated) and supplies the secrets-management mechanism that **ADR-005 SR-003-3 / §8.4** explicitly defers to SR-001 for the Selcafe read-only credential. It also governs the JWT signing key (ADR-015 IR-04), the TOTP secret-encryption key (ADR-015 IR-14), and the audit hash-chain anchoring signing material (AUDIT_EVENT_SCHEMA §7 / KD-C).

- **Merge gate:** Pod B + Kerem (ADR-009 §3 *security-sensitive* trigger is strictest). **Kerem is sole merge authority.**
- **Behavior-change classification (ADR-009 §4):** the merging PR **fires the §4 gate** — it creates a new Accepted decision state and resolves the open SR-001 recommendation. It therefore requires a **Pod Impact Matrix** and a filled **`INSTRUCTION_UPDATE_PACKET.md`** (ADR-013 §7). See §8.
- **This ADR does NOT authorize Pod C.** It states requirements; it provisions nothing.

---

## 1. Context

### 1.1 The problem

Multiple high-value secrets already exist in the design corpus or will exist at first implementation, but **no single secrets-management approach is documented**. `SECURITY_REVIEW.md` SR-001 records this gap and routes it to Pod B as a future design item. Several downstream items are *blocked on this approach existing*: ADR-005 §8.4 names SR-001 credential handling as a binding pre-implementation item for the `SelcafeAdapter` (even on the strictly non-PII direct-read track), and ADR-015's IR-04/IR-14 presuppose somewhere safe for the signing/encryption keys to live.

### 1.2 The secrets in scope (from SR-001)

| ID | Secret | Source requirement | Class |
|---|---|---|---|
| **S-1** | JWT signing key | ADR-015 IR-04 (pinned alg, reject `none`) | A — cryptographic key material |
| **S-2** | TOTP secret-encryption key (KEK protecting per-user TOTP shared secrets at rest) | ADR-015 IR-14 | A — cryptographic key material |
| **S-3** | Audit hash-chain anchoring signing material | AUDIT_EVENT_SCHEMA §7 / KD-C (periodic external anchoring of the head hash) | A — cryptographic key material |
| **S-4** | Selcafe read-only DB login credential (`adeks_selcafe_ro`) | ADR-005 SR-003-1/3 (least-privilege `SELECT`-only login) | B — external service credential |
| **S-5** | SMS provider API credential | ADR-015 §4 (provider not selected — BL-1) | B — external service credential |

`[ASSUMPTION]` The S-3 characterization (an anchoring *signing* key whose compromise would let an attacker forge anchors) is taken from `SECURITY_REVIEW.md` §4.5/SR-001 and the KD-C description, not from a fresh read of `AUDIT_EVENT_SCHEMA.md` this session. The exact anchoring **cadence, format, covered-field set, and canonical serialization** remain **SR-002** (the Pod B schema/migration deliverable), not this ADR. SR-001 governs only **where the signing material lives and how it rotates**.

### 1.3 Constraints that shape this decision

- **Hosting / deployment model is Not locked** (`PROJECT_DECISION_INDEX.md` §2), constrained by the 99.9% SLO (K-05) and the KVKK cross-border assessment (K-08). **A concrete cloud-specific secrets backend cannot be locked before the hosting decision.** This ADR therefore locks the *requirements and an abstraction* and defers the *concrete backend* — the same shape ADR-005 used for its physical-source sub-decision.
- **Stack (locked):** TypeScript / NestJS / Next.js modular monolith on PostgreSQL/Prisma (ADR-001/002/003/004). The approach must fit a self-hosted Node process loading secrets at boot.
- **Phase scope:** Phase 1 is a **single café (single tenant)**. The five secrets are **platform-level**, not per-tenant. Per-tenant secret isolation (e.g. per-tenant SMS sender credentials) is a **Phase 3 multi-tenant** concern named here only as a forward pointer.
- **Precedent (ADR-012):** the project already accepts a "pragmatic Phase-1 mechanism → managed service before Phase 3" trajectory, and **excludes cross-border-coupled SaaS where a residency concern exists**. The same posture informs §4.

### 1.4 KVKK position (so the constraint is not overstated)

The five secrets are **not personal data**, and a secrets store does not process personal data. **KVKK's cross-border *personal-data* transfer obligation (K-08 / `CROSS_BORDER_TRANSFER_ASSESSMENT.md`) does not directly gate the secrets backend.** Two true qualifications: (a) S-1/S-2 protect *access to* personal data and S-3 protects the *integrity* of records that contain personal data, so their compromise has KVKK breach consequences (ROLLBACK_POLICY T-2 / §23); (b) the project's cross-border-cautious posture favours a residency-aware backend choice. Residency here is a **security/operational posture preference, not a KVKK personal-data trigger**. Any actual KVKK determination remains the K-08 legal advisor's. `[ASSUMPTION]` — Pod B legal-scope reasoning, to be confirmed by the advisor if Kerem wishes.

---

## 2. Decision (summary)

Adopt a **requirements-first, vendor-neutral** secrets-management approach: (1) ten binding requirements **SM-1…SM-10**; (2) a **`SecretsProvider` port abstraction** so the concrete backend is swappable and the codebase is not coupled to it; (3) a **two-class handling model** (Class A cryptographic key material vs Class B external service credentials) with class-specific rotation strategies; and (4) the **concrete backend left as a flagged sub-decision dependent on the hosting decision** (`[NEEDS KEREM APPROVAL]`), with a Pod B recommendation. No secret value is created, stored, or printed by this ADR; nothing is provisioned.

---

## 3. Decision (detail) — binding requirements (SM-1…SM-10)

These apply to **all five secrets** unless a class-specific rule in §4 narrows them.

| ID | Requirement |
|---|---|
| **SM-1 — No secrets in the repository** | No secret value in source, application config, a committed `.env`, IaC, CI workflow definitions, or container images. Only a placeholder `.env.example` carrying **names** (never values) may be committed. Complements SR-007 secret-scanning (detective control). |
| **SM-2 — No plaintext at rest in the app** | Secrets are not stored in plaintext on the application host beyond a tightly-permissioned, out-of-band-provisioned injection surface. Prefer injection (SM-3) over an on-disk plaintext file. |
| **SM-3 — Runtime injection + fail-closed startup** | Secrets are injected at runtime (process environment or a read-only, strict-permission mounted secret), loaded once at boot. The app performs **startup validation and refuses to start** if a required secret is absent or malformed — deny-by-default parity with IR-06. |
| **SM-4 — Never in logs/traces/errors/audit/claims** | No secret value appears in logs, stack traces, error responses, the `audit_event` store, or JWT claims (aligns R-2, IR-03, and IR-04 no-PII/secret-in-claims). |
| **SM-5 — Environment separation** | dev / staging / prod hold **distinct** secret values. Prod secrets never appear in non-prod. Non-prod uses **synthetic/throwaway** secrets — parity with the synthetic-data-only locked principle. |
| **SM-6 — Least privilege** | Each secret grants the minimum capability: S-4 is `SELECT`-only on the enumerated ADR-005 §4.1 tables (SR-003-1); S-5 is scoped to send; S-1/S-2/S-3 are scoped to their single cryptographic function. |
| **SM-7 — Rotatability without code change** | Every secret is rotatable without a code change or redeploy of business logic. Each secret has a documented rotation procedure with its class-specific cutover strategy (§4). Rotation avoids downtime where versioning allows. |
| **SM-8 — Access control + access logging** | Read/rotate access to **prod** secrets is restricted to Kerem + a minimal operator set. The backend logs read and rotation events. A **non-secret-bearing** rotation record MAY be emitted (key-id + actor + timestamp + reason — **never** the value); whether that record lives in the `audit_event` store or in infra/secrets-backend logs is an open item (§9, OQ-SEC-NEW). |
| **SM-9 — Backup, recovery & break-glass** | The secrets store is securely backed up with a documented recovery procedure. Each secret has a compromise runbook (revoke → rotate → invalidate downstream), tied into incident response (§23) and ROLLBACK_POLICY (a confirmed key compromise is a security incident; S-1/S-2/S-3 compromise can be a T-2-class event). |
| **SM-10 — Trust-root separation from protected data** | The **S-2 TOTP KEK must not live in the same store/row as the encrypted TOTP secrets it protects**, and the **S-3 audit anchoring signing key must not be derivable by a PostgreSQL superuser** — otherwise external anchoring provides no tamper-evidence against a DB superuser (the precise residual AUDIT §10 / SR-001 rely on the chain mitigating). The trust root sits **outside** the database boundary. |

---

## 4. Decision (detail) — two-class handling & the `SecretsProvider` abstraction

### D-1 — `SecretsProvider` port (vendor-neutral)

The application depends only on a **vendor-neutral `SecretsProvider` port** (mirrors the `CafeManagementAdapter` ports-and-adapters pattern and the ADR-002 stack-neutrality principle), e.g. a minimal `getSecret(name, env)` / `rotateSecret(name)` surface. The concrete backend (§4.3) is an implementation of this port, so the **backend choice does not couple the codebase** and can change between Phase 1 and Phase 3 without business-logic churn.

### D-2 — Class A — cryptographic key material (S-1, S-2, S-3)

- High-entropy, generated by a vetted CSPRNG/KMS; never leaves the secrets boundary in plaintext beyond runtime memory.
- **Versioned for rotation** (a `kid` / `key_version` identifier) so old and new keys can coexist during cutover:
  - **S-1 (JWT):** rotate with a key-id and a **verification overlap window** (verify against the previous key for the access-token lifetime, ~15 min, before retiring it). `[ASSUMPTION]` Where the auth design permits, an **asymmetric** signing key (private signs, public verifies) reduces blast radius vs a symmetric secret; the alg is **ADR-015 IR-04's** decision and is **not re-decided here** — flagged as a coordination point.
  - **S-2 (TOTP KEK):** envelope-encryption KEK. Rotation = **re-wrap** (decrypt each per-user TOTP secret with the old KEK, re-encrypt with the new KEK); this requires a **key-version column** on the encrypted TOTP records. The KEK is symmetric by nature.
  - **S-3 (audit anchor):** prefer an **asymmetric** signing key (private signs anchors; public key lets Pod D / an external verifier check them). Rotation is **new-anchors-forward** with the public key of each era retained for historical verification. Per SM-10 the private key lives outside the DB.
- **KMS/HSM-backed** handling for Class A is preferred where the chosen backend offers it (§4.3); it lets the key sign/wrap without the raw bytes ever entering the app process.

### D-3 — Class B — external service credentials (S-4, S-5)

- **S-4 (Selcafe RO login):** the least-privilege `SELECT`-only login from ADR-005 SR-003-1. Rotatable on schedule and on compromise; rotation is a password/credential change on the SQL Server side coordinated with the secrets store. Per ADR-005 §8.4 this is a **binding pre-implementation item** for the `SelcafeAdapter` — it must be in place before any adapter issue is Ready, but the adapter itself remains separately gated.
- **S-5 (SMS provider credential):** the credential **shape is unknown until BL-1** selects a provider (API key vs OAuth client-secret vs basic auth). Stored as an opaque/structured value via the `SecretsProvider`; provider-agnostic. The S-5 *value* depends on BL-1; the *approach* does not.

### 4.3 — D-4 — Concrete backend `[NEEDS KEREM APPROVAL]` (deferred to the hosting decision)

The concrete backend is **dependent on the hosting/deployment decision** (Not locked; K-05/K-08) and is therefore **not locked by this ADR**. Options:

| # | Option | Pros | Cons / gating |
|---|---|---|---|
| **O-1** | **Self-hosted secrets manager** (HashiCorp Vault / OpenBao / self-hosted Infisical) | Dynamic secrets, native rotation, fine-grained access, own audit log, residency fully controllable (Turkey/on-prem) | Another component to run at the 99.9% SLO; operational overhead heavy for a single Phase-1 café |
| **O-2** | **Cloud provider secret manager + KMS** (e.g. AWS Secrets Manager+KMS / GCP Secret Manager+KMS / Azure Key Vault) | Managed; KMS/HSM-backed Class-A keys; IAM access control; built-in rotation + audit | Ties to a cloud (hosting Not locked); region must be chosen with the cross-border posture in mind (posture, not a KVKK personal-data trigger — §1.4) |
| **O-3** | **Orchestrator secrets + encrypted-at-rest** (Docker/K8s secrets with SOPS/age or sealed-secrets; ciphertext-only in repo, decryption key out-of-band) | Minimal new infra; fits a self-hosted modular monolith; keeps secrets out of plaintext repo | Weaker rotation/audit ergonomics than O-1/O-2; the SOPS/age master key itself becomes a Class-A secret needing SM-10 handling |
| **O-4** | **Plaintext `.env` / committed config** | — | **Rejected** — violates SM-1/SM-2/SM-4 outright |

**Recommendation (not a decision):** For a single self-hosted Phase-1 location, **O-1 or O-3** (per the hosting decision) gives a residency-clean baseline with a clear path to a managed/KMS-backed store **before multi-tenant Phase 3** — the ADR-012 trajectory. If hosting lands on a major cloud whose Turkey-region (or otherwise posture-acceptable) offering is chosen, **O-2's KMS/HSM-backed handling is attractive specifically for the Class-A keys** (S-1/S-2/S-3) per D-2. The **requirements (SM-1…SM-10) and the `SecretsProvider` abstraction are lockable now, independent of the backend.**

---

## 5. Consequences

### 5.1 Positive
- Consolidates five scattered high-value secrets under one governed approach; unblocks the SR-001 dependency that ADR-005 §8.4 names for the Selcafe credential (at the requirement level).
- The `SecretsProvider` abstraction decouples the codebase from the backend, so the deferred hosting decision does not block design or create rework.
- SM-10 closes the precise gap that would otherwise let a DB superuser defeat the audit hash chain (the §10 residual depends on the anchor key being outside the DB).

### 5.2 Negative / costs
- Startup fail-closed (SM-3) means a missing secret is a hard boot failure — correct, but it makes secret provisioning a release-readiness gate.
- Class-A rotation has real cutover cost (JWT overlap window; TOTP re-wrap with a key-version column; audit new-anchors-forward) — more than "swap a string."
- Running O-1 adds a component to the 99.9%-SLO surface; O-3 trades rotation/audit ergonomics for simplicity.

### 5.3 Residual risks
| Residual | Status | Reference |
|---|---|---|
| Secret leakage via logs/repo despite SM-1/SM-4 | **Mitigated, detective** — SR-007 secret-scanning in CI is the backstop | SR-007 |
| DB superuser defeats audit tamper-evidence | **Mitigated by SM-10** (anchor key outside DB) + Pod D verification | AUDIT §10; SM-10 |
| Backend single point of failure / availability | **Open** — bound to the hosting/SLO decision (K-05) | §4.3 |
| S-5 credential handling unverifiable until provider known | **Open — BL-1** | §4 D-3 |

**`[LOCKED PRINCIPLE CONFLICT]`: none identified.** Consistent with all locked principles (KVKK required; human approval for security/customer-data; synthetic-data-only; no direct commits to `main`) and with ADR-001/002/003/004/005/008/009/013/015.

---

## 6. Alternatives Considered

| # | Alternative | Disposition |
|---|---|---|
| A1 | **Requirements + abstraction now; concrete backend deferred to hosting** | **Recommended** (this ADR). Matches ADR-005's flagged-sub-decision shape and ADR-012's pragmatic-now/managed-before-Phase-3 trajectory. |
| A2 | **Lock a concrete backend now** | **Rejected for now** — hosting is Not locked (K-05/K-08); a backend pick would pre-empt the hosting decision and risk cross-border-posture rework. |
| A3 | **Store secrets encrypted in PostgreSQL** | **Rejected for Class A** — violates SM-10 (KEK/anchor key co-located with the data they protect lets a DB superuser defeat both). Could host *ciphertext* of Class-B creds only if the wrapping key is external, which just re-creates the Class-A problem. |
| A4 | **Per-tenant secrets in Phase 1** | **Out of scope** — Phase 1 is single-tenant; per-tenant secret isolation is a Phase-3 forward pointer (§1.3). |
| A5 | **Defer SR-001 entirely until hosting is locked** | **Rejected** — ADR-005 §8.4 and IR-04/IR-14 need the *requirements* now; only the *backend* needs hosting. |

---

## 7. Document a SECURITY_REVIEW section instead of an ADR?

Considered, **rejected.** SR-001 is a **decision** with genuine alternatives (§6) that another **Accepted** ADR (ADR-005) names as a dependency and that coordinates Pod C (implements) and Pod D (monitors). `SECURITY_REVIEW.md` is explicitly a *review artifact that establishes no decision* — homing a decision there would be non-conformant. An ADR is the correct durable, referenceable home. On merge, the `SECURITY_REVIEW.md` SR-001 row should be reconciled to **point at ADR-016** (a small Pod B follow-on, §11).

---

## 8. Acceptance Criteria, Merge Gate & Implementation Gating

### 8.1 ADR acceptance criteria
1. Kerem approves the SM-1…SM-10 requirements and the `SecretsProvider` abstraction.
2. Kerem records a decision (or explicit deferral) on the §4.3 D-4 backend selection — including whether to **lock requirements+abstraction now and defer the backend**, or make the hosting decision first.
3. Pod B + Kerem merge gate satisfied; **Pod Impact Matrix + `INSTRUCTION_UPDATE_PACKET.md` attached** to the merging PR (ADR-009 §4 fires).

### 8.2 ADR-009 assessment
- **PR class:** adds one ADR under `/docs/adr/` plus mirror rows. **§4 behavior-change gate FIRES** — new Accepted decision-state; resolves the open SR-001 recommendation. **Pod Impact Matrix + `INSTRUCTION_UPDATE_PACKET.md` required.**
- **§3 / §11.1 triggers:** *security-sensitive* (Pod B + Kerem) is the strictest applicable → **Pod B + Kerem before merge.** Kerem sole merge authority.
- **Mirror updates required in the same PR:** new **ADR-016 row** in `PROJECT_DECISION_INDEX.md` §3; **ADR-016 entry** in the `PROJECT_METHODOLOGY.md` §19 ADR backlog; **new-path registration** for this file in `AGENT_CONTEXT_MANIFEST.md` (CI path-integrity check). The `SECURITY_REVIEW.md` SR-001 row reconciliation (§7) may ride along or follow on.

### 8.3 Implementation gating (preserved)
**This ADR does NOT authorize Pod C.** It provisions no store, creates no login, writes no migration, and creates no issue. The approach becomes Pod C work only via a separately Pod B + Kerem-approved issue meeting the Definition of Ready, **after** the §4.3 backend selection is made (which itself depends on the hosting decision). The S-4 Selcafe credential and the S-1/S-2/S-3 keys are *requirements* here, not provisioned artifacts.

---

## 9. `[NEEDS KEREM APPROVAL]` items raised by this ADR

| # | Item | Type | Default if no action |
|---|---|---|---|
| **K-S1** | Approve SM-1…SM-10 + the `SecretsProvider` abstraction as the locked secrets-management requirements | Architecture / security | Stays Draft; ADR-005 §8.4 SR-001 dependency stays unhomed; SelcafeAdapter cannot reach Ready |
| **K-S2** | §4.3 D-4 **concrete backend** — lock requirements+abstraction now and **defer backend to the hosting decision** (recommended), or make hosting first | Architecture (+ ops/SLO, K-05) | Backend stays deferred; requirements still lockable via K-S1 |
| **K-S3** | Whether secret **rotation events** are recorded in the `audit_event` store (non-secret-bearing) or only in infra/secrets-backend logs (**OQ-SEC-NEW**) | Audit scope | Default: infra/secrets-backend log only; revisit if Pod D wants a domain signal |

No `[PRODUCT IMPLICATION — POD A ALIGNMENT NEEDED]` items: secrets management has no customer-facing product surface.

---

## 10. Approval

- **Author:** Pod B — Architecture, Logic & Risk
- **Reviewer / Approver:** Kerem (merge gate Pod B + Kerem; Kerem sole merge authority)
- **Status:** **Accepted** — 2026-06-23 (Kerem approval)

---

## 11. Routing

- **Pod B:** owns this ADR and the §7 `SECURITY_REVIEW.md` SR-001-row reconciliation (follow-on). Coordinates the S-1 asymmetric-vs-symmetric point with ADR-015 IR-04 (does not re-decide). Defers S-3 anchoring cadence/format to **SR-002**.
- **Kerem:** review/approval before merge; decides K-S1/K-S2/K-S3; sole merge authority. The commit is gated on a **command keyword** (none issued this session).
- **Pod A:** on merge — register this file's path in `AGENT_CONTEXT_MANIFEST.md` (Pod A-owned, Pod B-reviewed) for the CI path-integrity check.
- **Pod C:** **Not authorized.** SR-003-3 now has a home, but the `SelcafeAdapter` and all secret-consuming features remain gated on separately approved issues + the §4.3 backend selection.
- **Pod D:** later — secret-access/rotation-anomaly monitoring as an operate-stage consumer (contingent on K-S3).

---

## 12. Document History

| Version | Date | Author | Change |
|---|---|---|---|
| v0.1 (draft) | 2026-06-23 | Pod B | Initial draft homing SR-001. SM-1…SM-10 requirements; `SecretsProvider` abstraction (D-1); two-class handling for S-1…S-5 (D-2/D-3); concrete backend deferred to hosting decision with options O-1…O-4 (D-4, `[NEEDS KEREM APPROVAL]`); KVKK position clarified (§1.4 — not a cross-border personal-data trigger); ADR-vs-section decision (§7, ADR chosen); ADR-009 §4 fires (§8.2). Raises K-S1…K-S3. No secret values; synthetic data only; does NOT authorize Pod C. Merge gate Pod B + Kerem. |
