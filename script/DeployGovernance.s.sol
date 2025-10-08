// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;
import {Script} from "forge-std/Script.sol";
import {ERC20Votes} from "openzeppelin-contracts/token/ERC20/extensions/ERC20Votes.sol";
import {TAGITGovernor} from "src/TAGITGovernor.sol";
import {TAGITTimelock} from "src/TAGITTimelock.sol";
import {TimelockController} from "openzeppelin-contracts/governance/TimelockController.sol";

contract DeployGovernance is Script {
    function run() external {
        address safe = vm.envOr("SAFE_ADDRESS", address(0));
        uint256 minDelay = vm.envOr("MIN_DELAY_SECONDS", uint256(3600));

        vm.startBroadcast();

        // Timelock: proposers=Governor later, executors=open (address(0))
        address[] memory proposers = new address[](0);
        address[] memory executors = new address[](1); executors[0] = address(0);
        TAGITTimelock timelock = new TAGITTimelock(minDelay, proposers, executors, safe);

        // Expect a pre-existing ERC20Votes token on TAGIT L2; replace with actual address for mainnet deploys.
        ERC20Votes token = ERC20Votes(address(0));

        TAGITGovernor gov = new TAGITGovernor(
            token,
            TimelockController(address(timelock)),
            1,          // votingDelay (blocks)
            45818,      // votingPeriod (~1 week @ 15s)
            0,          // proposalThreshold (votes)
            4           // quorumPercent
        );

        // Wire roles: Governor is proposer; anyone can execute; admin already SAFE
        bytes32 PROPOSER_ROLE = timelock.PROPOSER_ROLE();
        bytes32 EXECUTOR_ROLE = timelock.EXECUTOR_ROLE();
        timelock.grantRole(PROPOSER_ROLE, address(gov));
        timelock.grantRole(EXECUTOR_ROLE, address(0));

        vm.stopBroadcast();
    }
}
