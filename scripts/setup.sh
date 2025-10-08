#!/usr/bin/env bash
set -euo pipefail

echo "[codex setup] Starting reproducible setup..."

run_with_elevation() {
  if command -v sudo >/dev/null 2>&1; then
    if [ "${EUID:-$(id -u)}" -eq 0 ]; then
      "$@"
    else
      sudo -E "$@"
    fi
  else
    "$@"
  fi
}

# 1) System essentials
export DEBIAN_FRONTEND=noninteractive
run_with_elevation apt-get update -y
run_with_elevation apt-get install -y curl git build-essential pkg-config libssl-dev jq python3 python3-pip

# 2) Node + pnpm
if ! command -v node >/dev/null 2>&1; then
  echo "[codex setup] Installing Node 20.x"
  tmp_setup_script="$(mktemp)"
  curl -fsSL https://deb.nodesource.com/setup_20.x -o "$tmp_setup_script"
  run_with_elevation bash "$tmp_setup_script"
  rm -f "$tmp_setup_script"
  run_with_elevation apt-get install -y nodejs
fi
if ! command -v pnpm >/dev/null 2>&1; then
  run_with_elevation npm i -g pnpm
fi

# 3) Foundry (Solidity toolchain)
if ! command -v forge >/dev/null 2>&1; then
  echo "[codex setup] Installing Foundry"
  curl -L https://foundry.paradigm.xyz | bash
  source ~/.bashrc || true
  ~/.foundry/bin/foundryup
fi

# 4) Slither (security) + solc-select
run_with_elevation pip3 install --upgrade pip
run_with_elevation pip3 install slither-analyzer solc-select

# 5) Optional: install deps for JS/TS workspaces
[ -f pnpm-lock.yaml ] && {
  pnpm_args=(install --frozen-lockfile)
  if [ "${NODE_ENV:-}" = "production" ]; then
    pnpm_args+=(--prod)
  fi
  pnpm "${pnpm_args[@]}"
} || true

echo "[codex setup] Done."
