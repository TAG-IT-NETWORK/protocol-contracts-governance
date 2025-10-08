# protocol-contracts-governance
OpenZeppelin Governor + Timelock for TAGIT. Primary execution on TAGIT L2 (OP Stack + EigenDA). Ethereum L1 holds backstop timelocks and anchors. CCIP used for cross-chain messaging where needed. Includes Foundry tests and Codex CI/CD.

## Key params
- Default votingDelay=1 block, votingPeriod=~1 week, quorum=4%, threshold=0 (adjust in Deploy script).
- Timelock is adminned by SAFE; Governor is proposer; anyone can execute.

## Quickstart
forge install
forge build
forge test
