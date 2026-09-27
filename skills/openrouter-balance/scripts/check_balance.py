#!/usr/bin/env python3
"""Check OpenRouter account credit balance.

Reads the API key from ~/.hermes/.env (OPENROUTER_API_KEY) unless given
via OPENROUTER_API_KEY env var or --key.
"""
import argparse
import json
import os
import re
import sys
import urllib.request

ENV_PATH = os.path.expanduser("~/.hermes/.env")


def get_key(cli_key=None):
    if cli_key:
        return cli_key.strip()
    key = os.environ.get("OPENROUTER_API_KEY")
    if key:
        return key.strip()
    if os.path.exists(ENV_PATH):
        text = open(ENV_PATH).read()
        m = re.search(r"sk-or-v1-[A-Za-z0-9\-]+", text)
        if m:
            return m.group(0)
    sys.exit("No OpenRouter API key found (env var, --key, or ~/.hermes/.env)")


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--key", help="API key override")
    ap.add_argument("--json", action="store_true", help="raw JSON output")
    args = ap.parse_args()

    req = urllib.request.Request(
        "https://openrouter.ai/api/v1/credits",
        headers={"Authorization": "Bearer " + get_key(args.key)},
    )
    data = json.loads(urllib.request.urlopen(req, timeout=30).read())
    if args.json:
        print(json.dumps(data, indent=2))
        return
    d = data["data"]
    remaining = d["total_credits"] - d["total_usage"]
    print(f"Total credits: ${d['total_credits']:.2f}")
    print(f"Used:         ${d['total_usage']:.2f}")
    print(f"Remaining:    ${remaining:.2f}")


if __name__ == "__main__":
    main()
