# protocol-contracts-governance • AGENT PLAYBOOK

<!-- INCLUDE STEM: docs/readme-badge@v1 -->
<!-- INCLUDE STEM: ci/pipeline-call@v1 -->

## Purpose
Core DAO/treasury governance contracts: voting, timelocks, emergency controls. Enforced via standardized CI/CD and security gates.  <!-- SOURCE: Deployment Manual repo list -->

## Required Checks (must pass before deploy)
- build, tests, slither, coverage>=85, sbom, sign, provenance  
<!-- SOURCE: Codexfile for this repo -->

## Workflows
- Type: `pipeline-contracts` (reusable, called from strategy-governance)  
- Triggers: pull_request, push:main, workflow_dispatch, scheduled  
<!-- INCLUDE STEM: ci/contracts@v1 -->

## Environments
```yaml
dev:
  rpc_url: $L2_RPC
  signer: env:PRIVATE_KEY_DEV
  timelock: $TIMELOCK_ADDRESS
  safe: $SAFE_ADDRESS
  approvals: [OWNER_TEAM]
stage:
  rpc_url: $L2_RPC
  signer: env:PRIVATE_KEY_STAGE
  timelock: $TIMELOCK_ADDRESS
  safe: $SAFE_ADDRESS
  approvals: [OWNER_TEAM, SECURITY_TEAM]
prod:
  rpc_url: $L2_RPC
  signer: env:PRIVATE_KEY_PROD
  timelock: $TIMELOCK_ADDRESS
  safe: $SAFE_ADDRESS
  approvals: [OWNER_TEAM, SECURITY_TEAM, PLATFORM_TEAM]
  
# Build & test
forge build
forge test --match-path test/*Governance*.t.sol

# Deploy and verify
codex deploy --repo protocol-contracts-governance --env {{ env }} --version {{ git_sha }}
codex verify --repo protocol-contracts-governance --env {{ env }} --checks timelock,roles,events

# Rollback (failure or policy breach)
codex rollback --repo protocol-contracts-governance --env {{ env }} --to previous-stable

Global Placeholders (must be injected)

[OWNER_TEAM] [SECURITY_TEAM] [PLATFORM_TEAM] [ALERT_CHANNEL] [L2_RPC] [SAFE_ADDRESS] [TIMELOCK_ADDRESS]

Policy & Security (non-negotiable)

No plaintext secrets; use OIDC/Vault.

Enforce CODEOWNERS; dual approval for prod; artifact SBOM + cosign + SLSA provenance.

Post-deploy health + incident tickets; use RUNBOOK DPL-CTR-001 for contract incidents.

Architecture Notes (for context-only)

Governance executes on TAGIT L2 (OP Stack + EigenDA); L1 is backstop via timelocks/emergency pause; cross-domain governance actions use CCIP messages when applicable.


(References: required checks; environments; pipeline type & triggers; global placeholder list; security rules; rollback; L2/L1 governance topology.)  :contentReference[oaicite:11]{index=11} :contentReference[oaicite:12]{index=12} :contentReference[oaicite:13]{index=13} :contentReference[oaicite:14]{index=14} :contentReference[oaicite:15]{index=15} :contentReference[oaicite:16]{index=16} :contentReference[oaicite:17]{index=17} :contentReference[oaicite:18]{index=18}

---

### 60-second check (diff your repo against this)

- Root has the standard skeleton (Codexfile, workflow, CODEOWNERS, SECURITY.md, README.md)  :contentReference[oaicite:19]{index=19}  
- Human **readme** contains: purpose, TL;DR commands, envs, emergencies/rollback, security, skeleton links  :contentReference[oaicite:20]{index=20} :contentReference[oaicite:21]{index=21} :contentReference[oaicite:22]{index=22}  
- Agent **README.md** defines required checks (coverage≥85 etc.), env matrix, exact codex/forge commands, placeholders, and includes stems  :contentReference[oaicite:23]{index=23} :contentReference[oaicite:24]{index=24} :contentReference[oaicite:25]{index=25}  
- Language around governance matches our L2-first model with L1 timelock backstop  :contentReference[oaicite:26]{index=26}  
- Repo description in your org inventory lists this as “DAO & treasury — voting, timelocks, emergency controls”  :contentReference[oaicite:27]{index=27}

If you want, paste your current two files here and I’ll diff them against these templates and patch them inline.

