# Instruction Update Packet - K-OS-009 Manifest Context Registration

## Status

Proposed for PR: register QR-handshake design as manifest context.

## Trigger

This PR updates `/docs/AGENT_CONTEXT_MANIFEST.md` so pods load `docs/planning/SESSION_LINKING_QR_HANDSHAKE_DESIGN_v0.1.md` for session-linking / customer-flow / Selcafe-read-surface task types.

## ADR-009 Section 4 Classification

Does this PR change pod behavior, gates, methodology, templates, decision state, or platform instructions? **Yes.**

Reason: the PR changes context-loading rules by updating `/docs/AGENT_CONTEXT_MANIFEST.md`.

## Pod Impact Matrix

| Pod | Impact | Required follow-up |
|---|---|---|
| Pod A | Must load the QR-handshake design when working on customer-flow, F&B ordering, operating-spine, guest ordering, or session-linking docs. | No external instruction re-paste required unless Kerem wants the snapshot pointer refreshed. |
| Pod B | Must use the QR-handshake design as context for Selcafe read-surface, live-bill, security, KVKK, and session-linking review. | No external instruction re-paste required unless Kerem wants the snapshot pointer refreshed. |
| Pod C | No implementation authorization. Future implementation prompts must load the QR-handshake design when a separate Definition-of-Ready issue exists. | None now. |
| Pod D | Should load the QR-handshake design for PWA flow/prototype/audit work touching session linking, live bill, or guest ordering. | None now. |

## Instruction Snapshot Update

No external platform instruction text change is required by this PR because it only adds a repository context-routing entry. Existing pod snapshots already route live context through `/docs/AGENT_CONTEXT_MANIFEST.md`.

## Review Routing

- Author: Pod A
- Required review: Pod B
- Approver / merger: Kerem
- Pod C: Not authorized

## Non-Authorization

This packet does not authorize Pod C implementation, schema/API work, ADR drafting, ADR-005 edits, Selcafe reads/writes, direct Selcafe SQL writes, wallet/payment implementation, real data use, or any read/derive/resolve/display of `adisyon.uye_no`.
