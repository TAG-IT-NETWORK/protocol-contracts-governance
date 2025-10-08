# Safe Roles Setup (Pattern B)
Admin = SAFE from the first block. Execute these from the Safe UI after deploy:

1) Get addresses from deploy logs or broadcast JSON:
   - Timelock = 0x...
   - Governor = 0x...

2) In the Safe app: New Transaction → Contract Interaction
   - Contract: TimelockController at Timelock address
   - Function: grantRole(bytes32,address)

3) Call #1 (Proposer):
   - role = keccak256("PROPOSER_ROLE")
   - account = Governor address

4) Call #2 (Executor open):
   - role = keccak256("EXECUTOR_ROLE")
   - account = 0x0000000000000000000000000000000000000000

5) Execute with the required signature threshold.

6) Verify (any CLI):
   cast call <Timelock> "hasRole(bytes32,address)(bool)" $(cast keccak PROPOSER_ROLE) <Governor>
   cast call <Timelock> "hasRole(bytes32,address)(bool)" $(cast keccak EXECUTOR_ROLE) 0x0000000000000000000000000000000000000000
