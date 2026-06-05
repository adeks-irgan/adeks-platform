## Summary

<!-- What changed and why? One paragraph. -->

Closes #

## Scope

### Included

<!-- What was built in this PR. -->

-

### Excluded

<!-- What was explicitly not changed. -->

-

## What Changed and Why

<!-- Describe the implementation and the reasoning. Reference the linked issue or approved scope. -->

## Acceptance Criteria Check

- [ ] All acceptance criteria from the linked issue are met.

## Tests

- [ ] Unit tests written/updated and passing
- [ ] Integration tests written/updated and passing (where applicable)
- [ ] E2E tests written/updated and passing (where applicable)
- [ ] Contract tests written/updated and passing (where applicable)
- [ ] Manual UAT notes included where applicable

## CI

- [ ] Lint passes
- [ ] Type-check passes
- [ ] Test suite passes
- [ ] Build passes
- [ ] Security / dependency checks pass (where configured)

## Tests Run

<!-- Paste the test output or commands run. -->

```
# e.g.
# pnpm test → 42 passed, 0 failed
# pnpm lint → no errors
# pnpm build → success
```

## Review Triggers (ADR-009 §3)

<!-- Check every category that applies. Unchecked = not applicable. Authoritative source: ADR-009 §3. -->

- [ ] **Wallet ledger logic** → Pod B + Kerem required before merge
- [ ] **Loyalty ledger logic** → Pod B + Kerem required before merge
- [ ] **Payment logic** → Pod B + Kerem required before merge
- [ ] **Refund logic** → Pod B + Kerem required before merge
- [ ] **Customer personal data handling** → Pod B + Kerem required before merge
- [ ] **Security-sensitive PR** (incl. security-sensitive admin actions) → Pod B + Kerem required before merge
- [ ] **Selcafe adapter or Selcafe integration changes** → Pod B + Kerem required before merge
- [ ] **Database / schema migration** → Pod B + Kerem required before merge
- [ ] **Authentication or authorisation** → Pod B required before merge
- [ ] **Audit log schema or logic** → Pod B required before merge
- [ ] **Admin privilege changes** → Kerem required before merge
- [ ] **None of the above** → Standard review only

## Process / Behavior-Change Gate (ADR-009 §4)

**Does this PR change pod behavior, responsibilities, review/approval gates, context-loading rules, output format, locked/deferred decision state, methodology, templates, or external AI-platform instructions?**

- [ ] No → skip the rest of this section.
- [ ] Yes → complete the matrix and packet below before merge.

### Pod Impact Matrix
| Pod | Impacted? | Reason | Required Follow-Up |
|---|---|---|---|
| Pod A | Yes / No | | |
| Pod B | Yes / No | | |
| Pod C | Yes / No | | |
| Pod D | Yes / No | | |

### Instruction Update Packet
- [ ] Completed using `/docs/templates/INSTRUCTION_UPDATE_PACKET.md` and included/linked.
- [ ] `PROJECT_DECISION_INDEX.md` updated if decision state changed.
- [ ] `AGENT_CONTEXT_MANIFEST.md` updated if required context changed.
- [ ] Affected pod instruction snapshots updated; external platform re-paste noted if required.

## Documentation

- [ ] Documentation updated (list below)
- [ ] No documentation change required

Documents updated:

-

## Database / Migration Impact

- [ ] No migration included
- [ ] Migration included — reviewed by Pod B
- [ ] Expand-and-Contract pattern confirmed (no table locks during production hours)

## Rollback Notes

<!-- How is this change rolled back if needed? List any migration implications. -->

## Data Safety

- [ ] No real personal data used in tests, fixtures, screenshots, or examples
- [ ] Synthetic data only (Customer A, +90 555 000 00 01, PC-001, etc.)

## Risk Notes

<!-- Describe any risks, edge cases, or areas of uncertainty not covered above. -->

## Screenshots / Evidence

<!-- Add screenshots, logs, or test output where useful. -->

## Open Questions

<!-- Any unresolved questions or decisions required before merge? List or write "None". -->

## Definition of Done Checklist

<!-- Final confirmation before requesting review. All items must be checked. -->

- [ ] Acceptance criteria met
- [ ] Tests written and passing
- [ ] CI passes (lint, type-check, test, build)
- [ ] Required reviews completed (see Review Triggers above)
- [ ] Behavior-change gate answered; Pod Impact Matrix + Instruction Update Packet included if "Yes" (ADR-009 §4)
- [ ] Documentation updated if behaviour changed
- [ ] Migration reviewed by Pod B if schema changed
- [ ] Rollback notes included if deployment-impacting
- [ ] No real personal data in tests, fixtures, or examples
- [ ] PR description explains what changed and why
