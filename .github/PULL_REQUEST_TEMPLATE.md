## Summary

<!-- What changed and why? Link the GitHub issue this PR closes. -->

Closes #

## Files Changed

<!-- List the files changed and a one-line description of each change. -->

| File | Change |
|---|---|
| | |

## Tests Added or Updated

<!-- Describe the tests added or updated. If no tests were added, explain why. -->

## Commands Run

<!-- List the commands you ran to verify this PR before opening it. -->

```
# e.g.
# npm run lint
# npm run type-check
# npm test
```

## Risk Notes

<!-- Note any deployment risks, rollback considerations, or areas of uncertainty. -->

## Required Reviews

<!-- Mark all that apply -->

- [ ] Kerem approval required (all code PRs)
- [ ] Pod B review required — touches: wallet / loyalty / auth / authz / payments / refunds / customer data / KVKK / Selcafe / audit logs / schema migrations / reservation state machine / security-sensitive admin actions

## Open Questions

<!-- List any unresolved questions or decisions needed before merge. -->

---

## Definition of Done Checklist

Pod C must confirm all items before requesting review. Do not merge a PR that does not meet this standard.

- [ ] All acceptance criteria from the linked issue are met
- [ ] Unit tests written and passing
- [ ] Integration tests written and passing where applicable
- [ ] CI pipeline passes (lint, type-check, test, build)
- [ ] Security-sensitive areas reviewed by Pod B (if triggered)
- [ ] Financially-sensitive areas approved by Kerem (if triggered)
- [ ] Documentation updated if behaviour changed
- [ ] Migration reviewed by Pod B if schema changed
- [ ] Rollback notes included if deployment-impacting
- [ ] No real personal data used in tests or examples
- [ ] PR description explains what changed and why
