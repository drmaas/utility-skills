# Contracts (host: `docs/contracts.md`)

One file for all contracts between network layers and subsystems. Not a directory.

## Ask timing

After PRD approval (`phases/01-prd.md`): contracts + tooling, contracts only, or skip.

## Who writes

| Phase | Action |
| --- | --- |
| Plan | If opted in: create or update sections in `docs/contracts.md` |
| Plan review | Architecture-security hardens sections |
| Implement | Tooling tasks only if user chose contracts + tooling |
| Implement / final review | Flag or fix drift vs code |
| Freeze | File already final; include in feature PR |

## Section template

Use one H2 (or H3 under a group) per contract:

```markdown
## <Contract name>

- Parties: <layer or subsystem A> ↔ <B>
- Surface: <APIs, events, UI seams — one short list>
- Invariants: <must-hold rules>
- Tooling: <path or URL to OpenAPI / GraphQL / Storybook / other, or `none`>
- Owners: <team or role>
```

Keep each section short. Point at stack tooling; do not paste full schemas into this file.

## Rules

- Create `docs/contracts.md` if missing when contracts are in scope.
- Prefer pointers over duplication.
- Brief, simple language. No unnecessary words.
- Freeze commits this file with the feature PR; no dangling follow-up doc commit.
