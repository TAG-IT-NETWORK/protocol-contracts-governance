# Governance Contracts — One-Click Deploy
This repo uses a reusable Codex workflow to build, deploy and verify on TAGIT L2 (OP Stack) testnets and mainnets.
## How to use
1. Add secrets in **Settings → Secrets and variables → Actions**:
   - `L2_RPC_DEV`, `PRIVATE_KEY_DEV`, `SAFE_ADDRESS_DEV`, `BLOCK_EXPLORER_API_KEY_DEV`.
2. Go to **Actions → use-codex → Run workflow**, choose an environment (`dev | stage | prod`), and run.
3. The workflow runs Foundry build/tests and then `codex deploy` + `codex verify`.
> Standards and repo mappings are defined in the Deployment Manual and Codexfiles index.
> After deploy, addresses may be written to `scripts/addresses/<env>.json` by your scripts.
