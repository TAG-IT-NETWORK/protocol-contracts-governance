#!/usr/bin/env python3
# tools/codex/codex.py
import argparse, os, sys

def main():
    p = argparse.ArgumentParser(prog="codex")
    p.add_argument('phase', choices=['plan','deploy','verify'])
    p.add_argument('--repo', required=True)
    p.add_argument('--env', required=True, choices=['dev','stage','prod'])
    p.add_argument('--version', default=os.environ.get('GITHUB_SHA','local'))
    p.add_argument('--strategy', default=None)
    p.add_argument('--percent', default=None)
    p.add_argument('--checks', default=None)
    args = p.parse_args()

    # For now, just prove the plumbing works (no-op).
    # Replace these prints with real calls (foundry/hardhat/helm/etc).
    print(f"[codex] phase={args.phase} repo={args.repo} env={args.env} "
          f"version={args.version} strategy={args.strategy} percent={args.percent} checks={args.checks}")
    return 0

if __name__ == "__main__":
    sys.exit(main())
