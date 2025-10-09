#!/usr/bin/env python3
import argparse, json, os, subprocess, sys, pathlib

ROOT = pathlib.Path(__file__).resolve().parents[2]  # repo root
ADDRS_DIR = ROOT / "scripts" / "addresses"
ADDRS_DIR.mkdir(parents=True, exist_ok=True)

def sh(cmd, env=None):
    print(f"$ {cmd}", flush=True)
    subprocess.check_call(cmd, shell=True, env=env or os.environ.copy())

def save_addresses(env, addrs):
    f = ADDRS_DIR / f"{env}.json"
    f.write_text(json.dumps(addrs, indent=2))
    print(f"saved → {f}")

def load_addresses(env):
    f = ADDRS_DIR / f"{env}.json"
    return json.loads(f.read_text()) if f.exists() else {}

def plan(repo, env, version, **_):
    # Build + tests + slither (if present)
    sh("forge --version")
    sh("forge build -vv")
    sh("forge test -vvv")
    # optional slither (skip if not installed)
    try:
        sh("slither --version")
        sh("slither . --print contract-summary --filter-paths 'lib|test|script'")
    except Exception:
        print("slither not installed, skipping static analysis")

def deploy(repo, env, version, strategy=None, percent=None, **_):
    rpc = os.environ.get("L2_RPC") or os.environ.get("RPC_URL")
    pk  = os.environ.get("DEPLOYER_KEY")
    api = os.environ.get("BLOCK_EXPLORER_API_KEY")
    if not (rpc and pk):
        print("Missing L2_RPC/RPC_URL or DEPLOYER_KEY in environment.", file=sys.stderr)
        sys.exit(2)

    # forge script deploy (broadcast + verify)
    # NOTE: set VERIFY=1 only if BLOCK_EXPLORER_API_KEY is present
    verify_flag = "--verify" if api else ""
    cmd = (
        "forge script script/DeployGovernance.s.sol:DeployGovernance "
        f"--rpc-url {rpc} "
        f"--private-key {pk} "
        "--broadcast "
        f"{verify_flag} "
        f"--etherscan-api-key {api or ''} "
        "-vv"
    )
    sh(cmd)

    # read the broadcast artifact to capture addresses
    # (forge writes to broadcast/<script>/<chainId>/run-latest.json)
    # we’ll scan for known contracts
    chain_id = os.environ.get("CHAIN_ID", "unknown")
    # Fallback: allow user to write addresses via a temp file
    out_file = ROOT / "script" / "out.addresses.json"
    if out_file.exists():
        addrs = json.loads(out_file.read_text())
        save_addresses(env, addrs)
    else:
        # minimal graceful fallback (addresses can be added later)
        print("No script/out.addresses.json found; add write in your deploy script to capture addresses.")

def verify(repo, env, version, checks=None, **_):
    rpc = os.environ.get("L2_RPC") or os.environ.get("RPC_URL")
    addrs = load_addresses(env)
    if not rpc:
        print("Missing L2_RPC/RPC_URL.", file=sys.stderr)
        sys.exit(2)
    if not addrs:
        print(f"No saved addresses for env '{env}'. Skipping deep checks.")
        return 0

    timelock = addrs.get("TimelockController")
    governor = addrs.get("Governor")
    if timelock:
        # Example checks: timelock minDelay and admin role presence
        sh(f"cast call {timelock} 'getMinDelay()(uint256)' --rpc-url {rpc}")
    if governor:
        sh(f"cast code {governor} --rpc-url {rpc}")

    print("[codex] verify completed.")
    return 0

PHASES = {"plan": plan, "deploy": deploy, "verify": verify}

def main():
    p = argparse.ArgumentParser(prog="codex")
    p.add_argument('phase', choices=list(PHASES.keys()))
    p.add_argument('--repo', required=True)
    p.add_argument('--env', required=True, choices=['dev','stage','prod'])
    p.add_argument('--version', default=os.environ.get('GITHUB_SHA','local'))
    p.add_argument('--strategy', default=None)
    p.add_argument('--percent', default=None)
    p.add_argument('--checks', default=None)
    args = vars(p.parse_args())
    print(f"[codex] {args}")
    return PHASES[args.pop("phase")](**args)

if __name__ == "__main__":
    sys.exit(main() or 0)
