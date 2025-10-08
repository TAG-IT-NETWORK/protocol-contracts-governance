#!/usr/bin/env bash
set -euo pipefail

echo "[codex setup] Starting reproducible setup..."

# 1) System essentials
export DEBIAN_FRONTEND=noninteractive
sudo apt-get update -y
sudo apt-get install -y curl git build-essential pkg-config libssl-dev jq python3 python3-pip

# 2) Node + pnpm
if ! command -v node >/dev/null 2>&1; then
  echo "[codex setup] Installing Node 20.x"
  curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
  sudo apt-get install -y nodejs
fi
if ! command -v pnpm >/dev/null 2>&1; then
  npm i -g pnpm
fi

# 3) Foundry (Solidity toolchain)
if ! command -v forge >/dev/null 2>&1; then
  echo "[codex setup] Installing Foundry"
  curl -L https://foundry.paradigm.xyz | bash
  source ~/.bashrc || true
  ~/.foundry/bin/foundryup
fi

# 4) Slither (security) + solc-select
pip3 install --upgrade pip
pip3 install slither-analyzer solc-select

# 5) Optional: install deps for JS/TS workspaces
[ -f pnpm-lock.yaml ] && pnpm install --frozen-lockfile || true

echo "[codex setup] Done."
