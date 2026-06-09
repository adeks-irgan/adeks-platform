# PROPOSAL: Orchestration Advisor (Kerem's Coordination Aide)

- Status: PROPOSED — trial, non-authoritative
- Author: Pod B (review) / Kerem (owner)
- Date: 2026-06-08
- Canonical path: /docs/proposals/PROPOSAL-orchestration-advisor.md
- Related: PROJECT_METHODOLOGY.md §1 (Control Plane, LOCKED), §24.2
  (Delivery Coordinator gap), ADR-013 §5/§7, ADR-009 §4/§5

> This is a PROPOSAL. It establishes no decision and grants no authority.
> It does not modify methodology. If it ever appears to do so, it is
> non-conformant and the repo control plane wins.

## What this is
An advisory coordination aide that helps **Kerem** understand current
project state, detect cross-pod drift, sequence work, prepare candidate
handoff/decision packets, and identify approval checkpoints.

It is **NOT a pod**. It is not Pod A, B, C, or D. It is not "Pod O."

## Hard boundaries (load-bearing)
- No final product, architecture, implementation, or merge authority.
- Produces **no durable project truth**. Nothing it outputs is binding until
  committed to the repository by the responsible pod or Kerem through the
  normal review path.
- Outputs go **to Kerem only**, as candidates/options — never issued to
  Pod A/B/C/D as directives. No pod ever receives an instruction "from the
  Orchestration Advisor."
- Does not satisfy or participate in any ADR-009 §3/§4 gate. It may *draft*
  a Pod Impact Matrix or Instruction Update Packet; the owning pod + Kerem
  still execute the gate.
- Preserves PROJECT_METHODOLOGY.md §1: "No AI pod is the project manager.
  No AI pod can make final decisions." Kerem remains sole decision authority.

## Relationship to Pod A
Overlaps Pod A's planning/routing role and the §24.2 "Delivery Coordinator"
coverage. To stay separate: the Advisor prepares **candidate** routing and
roadmap material for Kerem; **Pod A remains owner** of all product/planning
artifacts, AGENT_CONTEXT_MANIFEST.md, and the handoff templates.

## Trial
- Window: 2026-07-07 (4 weeks from merge date).
- Exit: Pod D audits for workflow consistency; Pod A reviews for role overlap;
  Kerem decides whether to (a) discontinue, (b) keep informal, or
  (c) formalize via a behavior-changing PR (ADR-013 §7 / ADR-009 §4 —
  Pod Impact Matrix + Instruction Update Packet + Pod A review + Kerem approval),
  most likely by clarifying the §24.2 Delivery Coordinator row rather than
  creating a new pod.
