# Architecture Decision Records

**Audience:** `hybrid` for each `docs/adrs/NNNN-slug.md`.

Host path: `docs/adrs/NNNN-slug.md`.

## When to write

| Phase | Action |
| --- | --- |
| Plan | List candidate decisions in `plan.md` Architecture (title + one-line choice) |
| Plan review | Architecture-security writes ADRs for **locked** decisions only |
| Implement / final | Amend an ADR only if the decision changed |
| Freeze | ADRs already final; include in feature PR |

Do not invent ADRs for routine code choices.

## Template

```markdown
# NNNN. <Title>

## Context
<2–4 short sentences>

## Decision
<one clear choice>

## Consequences
- <bullet>
- <bullet>
```

Number `NNNN` as the next free integer under `docs/adrs/`. Create `docs/adrs/README.md` only if missing (one-line index purpose).

## Rules

- Brief, simple language. No unnecessary words.
- Commit ADRs with the feature PR at freeze. No dangling ADR-only follow-up.
