# RPI specialized agents

Role briefs for Task subagents. Spawn with `subagent_type: generalPurpose`, load the brief + phase template, resolve model via [`../models.md`](../models.md).

| Agent | Phases | Model role |
| --- | --- | --- |
| [`product-requirements-critic.md`](product-requirements-critic.md) | PRD create/review (`phases/01-prd.md`) | `adversarial` |
| [`architecture-security-reviewer.md`](architecture-security-reviewer.md) | Plan review (first spawn) | `adversarial` |
| [`qa-testability-reviewer.md`](qa-testability-reviewer.md) | Plan review (second spawn) | `adversarial` |
| [`adversarial-code-reviewer.md`](adversarial-code-reviewer.md) | Implement review, final review | `review` |

Research, plan write, implement, verify, and refactor keep their existing templates without a separate agent brief.
