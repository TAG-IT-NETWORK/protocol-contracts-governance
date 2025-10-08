# ORACULAR — TAG IT Network

> **TL;DR**: ORACULAR is a modular blockchain + AI governance stack for physical‑world
> assets. It gives every item a secure **Digital Twin NFT**, binds it to **encrypted NFC**
> identity, logs **chain‑of‑custody**, and enforces policy via **DAO‑driven smart
> contracts**. Built on an **OP Stack L2 with EigenDA** and anchored to Ethereum for
> finality. Designed for enterprises and government partners that require security,
> auditability, and recovery tooling out‑of‑the‑box.

---

## Why this matters

Global supply chains lose hundreds of billions to counterfeits, theft, and paperwork
friction. Brands, agencies, and citizens lack a common, tamper‑evident source of truth
for an item’s identity and custody. Point solutions exist, but they fragment data and
rarely interoperate or meet public‑sector security standards.

## What we’re building

**ORACULAR** is the product suite by **TAG IT Network DAO** that brings the physical and
digital together:

* **Digital Twin NFT Layer** — each item gets a unique on‑chain identity and lifecycle.
* **Encrypted NFC Identity Binding** — tags bind to the Digital Twin securely.
* **Recovery Protocol** — mark items lost/stolen; scans trigger on‑chain flags/alerts.
* **Chain‑of‑Custody Contracts** — verifiable hand‑offs across logistics and retail.
* **DAO Governance Layer** — role‑weighted voting for public‑private partners.
* **Asset Flagging & Alerts** — automatic actions when stolen items are scanned.
* **Smart Access Controls** — time‑locks, geo‑restrictions, remote disable.
* **Dual‑Layer Tags (NFC + BT)** — optional active pings for high‑value assets.
* **Zero‑Knowledge Proofs** — privacy‑preserving ownership and compliance checks.
* **AI‑Powered Auditing** — anomaly detection and pattern analysis.
* **Micro‑DAOs for HVAs** — co‑ownership, leasing, dispute resolution per‑asset.
* **Military‑Safe Stealth Mode** — hidden, encrypted tags with authorization gates.
* **Leasing & Collateralization** — finance rails for physical assets.
* **Post‑Quantum Crypto Roadmap** — Kyber/Dilithium exploration.
* **Public/Private Split** — sensitive data on private chain, public proofs on L2/L1.

## Architecture at a glance

* **Execution:** TAG IT **L2 (OP Stack)** with **EigenDA** for data availability.
* **Settlement/Finality:** Ethereum L1 anchors and backstop timelocks.
* **Interop:** Chainlink (preferred), plus IBC/Axelar/Wormhole as needed.
* **Storage:** IPFS/Filecoin/Arweave for artifacts; Postgres for ops/analytics.
* **Indexing:** The Graph/Goldsky.
* **Identity & Auth:** DIDs/VCs, WalletConnect, passkeys.
* **Observability/DevOps:** Foundry/Hardhat, Tenderly, Grafana/Prometheus, OTel, K8s.

👉 See the placeholder diagram: `docs/diagrams/super-mesh-architecture.png` (TODO).

## Governance & trust model

TAG IT Network DAO stewards the protocol with role‑weighted voting aligned to real
stakeholders:

* **U.S. Government & Military — 30%**
* **Enterprises — 30%**
* **Token Holders — 20%**
* **Core Development — 10%**
* **Regulatory/Oversight — 10%**

Proposal classes: Constitutional, Protocol, Treasury, Emergency, Operations. Approved
changes execute via on‑chain timelock + Safe controls. Compliance‑by‑design for SEC,
CFTC, GDPR, AML/KYC, and global trade/tax regimes.

👉 Lifecycle diagram: `docs/diagrams/governance-lifecycle.png` (TODO).

## Why we win (benefits)

* **Authenticity & Anti‑Counterfeit** — instant verification via public scans.
* **Custody you can prove** — tamper‑evident hand‑offs from factory to customer.
* **Recovery & Deterrence** — stolen/lost items broadcast alerts at point of scan.
* **Privacy by default** — ZK proofs reveal compliance, not identities.
* **Security for the real world** — Safe‑admin timelocks, formal reviews, PQC roadmap.
* **Interoperable by design** — bridges/oracles to meet customers where they are.
* **Enterprise‑grade ops** — CI/CD, SBOM, signing, observability baked in.

## Traction & near‑term milestones

* Stand‑up **governance contracts** (OZ Governor + Timelock) on TAG IT L2.
* Pilot **Digital Twin + NFC** with launch partners.
* Publish **Recovery Protocol** spec and reference app.
* Integrate **AI auditing** for anomaly detection in custody flows.
* External **security review** and staged testnet→mainnet rollout.

## What’s in this repo

This repository contains protocol governance contracts, tests, and deployment tooling
for the TAG IT L2 environment. Other modules (NFC apps, custody services, AI auditing)
are versioned in adjacent repos within the TAG‑IT‑NETWORK org.

## Security & compliance stance

* Admin and upgrades gated by **Safe** + **Timelock**.
* Slither/static analysis, coverage goals, SBOM, signed releases, provenance.
* Data minimization, privacy by default, strict access controls.
* Responsible disclosure via security@ (see SECURITY.md).

## How to engage

* **Enterprises & Agencies** — Pilot programs and integration support.
* **Developers** — Contribute via issues/PRs; see `CONTRIBUTING.md`.
* **Researchers/Auditors** — Request specs and threat models.
* **Investors/Partners** — Contact core team for diligence package.

## Quickstart (dev)

```bash
forge install
forge build
forge test -vv
```

## License

Copyright © TAG IT Network. See `LICENSE`.

---

> *“A living control room for the physical internet—where AI, cryptography, and
> governance keep assets honest.”*
