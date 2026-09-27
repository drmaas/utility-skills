# openrouter-balance

Check the OpenRouter account credit balance: total credits, used, and remaining.

## Requirements

- Python 3 (stdlib only — no extra packages)
- An OpenRouter API key (`sk-or-v1-...`) in one of:
  - `OPENROUTER_API_KEY` environment variable
  - a `.env` file containing `OPENROUTER_API_KEY=...`

## Usage

```bash
python3 scripts/check_balance.py
```

Output:

```
Total credits: $40.00
Used:         $39.10
Remaining:    $0.90
```

Options:

- `--json` — print the raw API response instead
- `--key <key>` — override the key source (the key is never printed)

## Error handling

Exits with `No OpenRouter API key found` if no key is available. Set `OPENROUTER_API_KEY` or add the key to a `.env` file in your home directory.

## Install

```bash
npx skills add drmaas/utility-skills --skill openrouter-balance
```
