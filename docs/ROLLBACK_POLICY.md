# Rollback Policy

<!--
  STATUS: Authoritative
  CANONICAL REPO PATH: /docs/ROLLBACK_POLICY.md
  AUTHORITY: K-03 (/docs/KEREM_DECISIONS.md §3) — binding input.
             PROJECT_METHODOLOGY.md §12.4 directed creation of this file and
             delegates rollback policy authority here.
  AUTHOR: Pod B — Architecture, Logic & Risk
  VERSION: 1.0
  LAST UPDATED: 2026-06-09
  PHASE: Phase 1 — single café (Adeks, ~130 PCs)
  STABILITY: Live. Update only via ADR-009-compliant PR.
-->

This document is the authoritative statement of the Adeks Platform rollback
policy. It is created per the directive in `PROJECT_METHODOLOGY.md` §12.4 and
is grounded in the binding Kerem decision recorded in
`/docs/KEREM_DECISIONS.md` §3 (K-03).

---

## 1. Purpose and Scope

This policy defines:

- Which conditions trigger a rollback, and whether the trigger is mandatory or
  at Kerem's discretion
- Who decides and who executes
- What must be recorded after a rollback

**Phase scope:** Phase 1 — single-café deployment at Adeks. This policy covers
the application layer only. Multi-tenant and SaaS scenarios are out of scope
until Phase 3.

---

## 2. What "Rollback" Means in This Policy

**Application rollback** means redeploying the previous application version,
identified by git SHA or version tag. This is the primary rollback action in
Phase 1.

**Application rollback does not automatically mean:**

- **Database schema rollback.** Reverting a schema migration is a separate,
  higher-severity operation requiring explicit, separate Kerem authorisation. It
  must not conflict with the Expand-and-Contract migration policy
  (`PROJECT_METHODOLOGY.md` §12.3) and requires Pod B + Kerem approval under
  the database/schema migration gate (§11.1).
- **Ledger data rollback.** Wallet and loyalty ledgers are append-only
  (ADR-006, ADR-007; principle locked). Incorrect ledger entries are corrected
  via compensating transactions, not by removing existing rows. Compensating
  transactions require Kerem + Pod B approval before execution (§11.1 —
  wallet/loyalty ledger class). See also §7.

An application rollback stops the system from producing further incorrect state.
It does not undo already-written ledger entries. The post-rollback record (§7)
must document what data correction is needed and how it will be authorised.

---

## 3. Rollback Triggers

### 3.1 Non-Discretionary Triggers (Mandatory — Immediate)

The following two conditions require **immediate rollback with no deliberation.**
They are not subject to Kerem's discretion. They execute upon confirmation —
regardless of time of day, café operating status, or any other factor.

| ID | Condition | Rationale |
|---|---|---|
| **T-1** | Wallet or loyalty balance/events appear incorrect | Financial integrity — customer value is at risk |
| **T-2** | Customer personal data is exposed to unauthorised parties | KVKK legal obligation — 72-hour breach notification clock starts on confirmation |

**T-2 — KVKK note:** Confirmation of a T-2 incident starts the 72-hour personal
data breach notification obligation under KVKK. The incident record (§7) must be
created immediately to fix the confirmed datetime. Kerem is responsible for
engaging the KVKK legal advisor without delay, per K-08
(`/docs/KEREM_DECISIONS.md` §8).

[NEEDS KEREM APPROVAL: Confirm that Kerem directly contacts the legal advisor
on T-2 confirmation, or designate an alternative responsible party if Kerem is
unreachable at the moment of confirmation.]

### 3.2 Discretionary Triggers (Kerem's Decision)

All rollback decisions outside T-1 and T-2 are **at Kerem's discretion.** There
is no fixed time threshold. Kerem decides case by case based on the nature and
severity of the incident (K-03).

The following situations are informative factors Kerem may weigh when making a
discretionary rollback decision. They do not independently mandate a rollback
(source: `PROJECT_METHODOLOGY.md` §12.4):

- Authentication or authorisation failure exposing restricted functionality
- Cashier or admin workflows becoming unusable
- F&B ordering causing significant operational confusion or lost orders
- Reservation workflow creating duplicate or conflicting booking commitments
- Monitoring reporting repeated critical errors after a deployment
- Data migration causing unexpected data loss, corruption, or severe performance
  degradation
- Platform unable to recover within an acceptable cumulative downtime threshold

[NEEDS KEREM APPROVAL: Define the maximum acceptable cumulative downtime
threshold that would inform a discretionary rollback decision. This is currently
open in `PROJECT_METHODOLOGY.md` §12.4.]

---

## 4. Incident Severity Classification

| Severity | Condition | Rollback Type | Response Urgency |
|---|---|---|---|
| **SEV-1** | T-1 or T-2 confirmed | Mandatory — immediate, no deliberation | Immediate |
| **SEV-2** | Significant operational, data integrity, or security impact outside T-1/T-2; café operations materially disrupted | Kerem decides promptly | Within current operating session |
| **SEV-3** | Partial feature unavailability; café operations continue normally; no data or security impact | Kerem decides at next convenient review | Next review cycle |

Classification is made by Kerem. If Kerem is temporarily unreachable, Pod B may
make an initial SEV classification for incident response purposes, but Pod B does
not have independent authority to execute a rollback outside T-1 and T-2.
Immediate notification to Kerem is required regardless.

---

## 5. Rollback Decision Flow

1. **Incident detected** by staff observation, Pod D monitoring alert, or customer
   report.
2. **Notified to Kerem** via the incident notification channel.
   [NEEDS KEREM APPROVAL: Define the primary notification channel for SEV-1 and
   SEV-2 incidents. K-06 establishes WhatsApp as the general staff feedback
   channel; a SEV-1 incident may warrant direct phone contact. Kerem to confirm.]
3. **Severity classified** by Kerem. If Kerem is temporarily unreachable, Pod B
   makes an initial classification and notifies Kerem immediately.
4. **Decision applied:**
   - **SEV-1 (T-1 or T-2):** Rollback executes immediately. No deliberation required.
   - **SEV-2 or SEV-3:** Kerem deliberates, weighing the factors in §3.2. The
     outcome is either rollback or fix-forward. Kerem's decision is recorded in
     the post-rollback record (§7) or, if fix-forward, in a GitHub Issue.
5. **Rollback executed** by Pod C (deployment authority), or by Kerem directly
   if Pod C is unavailable, using the documented rollback procedure.
   [NEEDS KEREM APPROVAL: Define the rollback execution method for Phase 1 once
   the deployment model is finalised. Currently not locked.]
6. **Post-rollback record created** (§7) within 24 hours of rollback completion.
7. **If T-2:** KVKK legal advisor engaged immediately per §3.1.

[NEEDS KEREM APPROVAL: Define the out-of-hours escalation path — who is
responsible for incident detection and Kerem notification outside café operating
hours, and what happens if Kerem is unreachable for an extended period during a
SEV-1 event.]

---

## 6. Who May Initiate or Escalate a Rollback

| Role | Authority |
|---|---|
| **Kerem** | Full rollback authority for any release at any severity |
| **Pod B** | May call immediate rollback for confirmed T-1 or T-2; may recommend rollback for security, data integrity, or financial logic risk at other severities; notifies Kerem immediately in all cases |
| **Pod C** | May execute rollback for a pure technical deployment or environment failure with immediate Kerem notification; all other rollbacks require Kerem direction before execution |
| **Pod D** | May recommend rollback based on monitoring or observability signals; does not decide or execute |
| **Cashier / café staff** | May escalate an observed operational failure via the incident notification channel; does not decide or execute |

For T-1 and T-2, any person who confirms the condition may initiate the rollback
call. No additional deliberation or approval is required before execution begins.

---

## 7. Post-Rollback Record

A post-rollback record must be created as a GitHub Issue in
`adeks-irgan/adeks-platform` within **24 hours** of rollback completion.

[NEEDS KEREM APPROVAL: Confirm GitHub Issue as the required format, or specify
an alternative record-keeping format.]

The record must include:

| Field | Content required |
|---|---|
| **Incident detected at** | Datetime the incident was first observed (ISO 8601, local time with UTC offset) |
| **Reported by** | Who first detected or escalated the incident |
| **Severity** | SEV-1 / SEV-2 / SEV-3 |
| **Trigger** | T-1 / T-2 / discretionary; one-sentence description of the condition observed |
| **Rollback type** | Mandatory (T-1 or T-2) or discretionary (Kerem decision) |
| **Rolled back from** | Application version or git SHA of the release being reverted |
| **Rolled back to** | Application version or git SHA of the version restored |
| **Rollback completed at** | Datetime rollback was confirmed complete |
| **Data state** | Whether wallet, loyalty, or customer data was affected; compensating actions needed or taken; link to any compensating transaction approval |
| **Personal data scope** *(T-2 only)* | Categories of personal data exposed; estimated number of affected customers (use synthetic customer references — no real names, phone numbers, or identifiers in this record) |
| **KVKK notification** *(T-2 only)* | Datetime legal advisor was contacted; confirmation received from legal advisor |
| **Root-cause issue** | Link to the GitHub Issue or PR tracking root-cause investigation and fix |
| **Decision authority** | Kerem (discretionary rollbacks); Pod B confirms trigger for T-1/T-2 mandatory rollbacks |

**Compensating ledger transactions (T-1):** If wallet or loyalty entries were
written incorrectly before rollback, the application rollback stops further
incorrect writes. The post-rollback record must include a plan for compensating
transactions. Compensating transactions are wallet/loyalty-ledger-class changes
(§11.1) and require Kerem + Pod B approval before execution. They must not be
executed as an undocumented operational action outside the PR approval process.

---

## 8. Relationship to Other Documents

| Document | Role |
|---|---|
| `/docs/KEREM_DECISIONS.md` §3 (K-03) | Binding source for all trigger and discretion rules in this policy |
| `/docs/KEREM_DECISIONS.md` §8 (K-08) | KVKK legal advisor — T-2 engagement path |
| `PROJECT_METHODOLOGY.md` §11.1 | Mandatory human approval triggers — compensating ledger transactions are wallet/loyalty-ledger-class PRs requiring Kerem + Pod B |
| `PROJECT_METHODOLOGY.md` §12.3 | Zero-Downtime Migration Policy — governs database schema rollback constraints |
| `PROJECT_METHODOLOGY.md` §12.4 | Directed creation of this file; broader discretionary trigger list reproduced in §3.2 |
| ADR-006, ADR-007 | Append-only wallet and loyalty ledger principles (backlog — principle locked) |
| ADR-009 | PR approval gates — compensating ledger transaction PRs require Kerem + Pod B |

---

## 9. Document Maintenance

This document is updated when:

- A [NEEDS KEREM APPROVAL] item is resolved by a recorded Kerem decision
- A post-rollback review identifies a new class of non-discretionary trigger
  (requires a K-level Kerem decision and an ADR-009 §4 behavior-change
  assessment before the trigger is added here)
- Phase advances to Phase 2 or later (scope section and severity
  classification may require revision)

Changes to this document are made via ADR-009-compliant PR. Changes that add a
non-discretionary trigger or alter who may execute a rollback are
behavior-changing under ADR-009 §4 and require a Pod Impact Matrix and
Instruction Update Packet.

---

*Version: 1.0 — 2026-06-09*  
*Author: Pod B — Architecture, Logic & Risk*  
*Source decision: K-03 (`/docs/KEREM_DECISIONS.md` §3)*
