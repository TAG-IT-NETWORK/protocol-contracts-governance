# protocol-contracts-governance

Governance smart contracts for protocol governance functions.

## Local environment setup

Run the reproducible environment bootstrap script to install the required toolchain (Node.js, pnpm, Foundry, and auditing dependencies):

```bash
./scripts/setup.sh
```

> **Note:** The Foundry installer fetches binaries from `https://foundry.paradigm.xyz`. If the download is blocked by a proxy (e.g. HTTP 403), rerun the script once the network restriction is resolved.

## Quickstart

> Pattern B (Safe‑first): deploy does not set roles. After deploy, follow docs/Safe-Roles-Setup.md using the Safe UI to grant PROPOSER/EXECUTOR.
