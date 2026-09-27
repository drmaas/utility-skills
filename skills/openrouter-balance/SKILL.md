---
name: openrouter-balance
description: Check the user's OpenRouter account credit balance. Use when the user asks about OpenRouter credits, balance, remaining funds, or account usage.
compatibility: Python 3 only (stdlib — urllib, no extra packages). Requires an OpenRouter API key.
metadata:
  repository: https://github.com/drmaas/utility-skills
---

# OpenRouter Balance

## Prerequisites

- Python 3 (stdlib only)
- An OpenRouter API key (`sk-or-v1-...`) in one of:
  - `OPENROUTER_API_KEY` environment variable
  - `~/.hermes/.env`

## Usage

Run the script:

```bash
python3 scripts/check_balance.py
```

Reads the API key from `OPENROUTER_API_KEY` env var or `~/.hermes/.env` (contains a `sk-or-v1-...` key). Output: total credits, used, remaining.

- `--json` for the raw API response
- `--key <key>` to override the key source

## Workflow

1. Resolve the script path relative to this skill's directory.
2. Run `python3 <skill-dir>/scripts/check_balance.py` with the terminal tool.
3. Report the three-line output directly.

## Edge Cases

- Missing key → the script exits with `No OpenRouter API key found`; do not retry, tell the user to set `OPENROUTER_API_KEY` or add the key to `~/.hermes/.env`.
- Never log, echo, or commit the API key itself — the script never prints it.