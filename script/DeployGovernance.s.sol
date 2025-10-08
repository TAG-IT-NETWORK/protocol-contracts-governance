// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;
import {Script} from "forge-std/Script.sol";
import {console2 as console} from "forge-std/console2.sol";
import {ERC20Votes} from "openzeppelin-contracts/token/ERC20/extensions/ERC20Votes.sol";
import {TAGITGovernor} from "src/TAGITGovernor.sol";
import {TAGITTimelock} from "src/TAGITTimelock.sol";
import {TimelockController} from "openzeppelin-contracts/governance/TimelockController.sol";

contract DeployGovernance is Script {
    function run() external {
        address safe = vm.envOr("SAFE_ADDRESS", address(0));
        require(safe != address(0), "SAFE_ADDRESS required");
        uint256 minDelay = vm.envOr("MIN_DELAY_SECONDS", uint256(3600));

        // Optional: reuse existing timelock
        address maybeTimelock = vm.envOr("TIMELOCK_ADDRESS", address(0));

        vm.startBroadcast();

        TAGITTimelock timelock;
        if (maybeTimelock != address(0)) {
            timelock = TAGITTimelock(payable(maybeTimelock));
            console.log("Reusing Timelock:", address(timelock));
        } else {
            address[] memory proposers = new address[](0);
            address[] memory executors = new address[](1); executors[0] = address(0);
            // ADMIN = SAFE from the start (no grants here)
            timelock = new TAGITTimelock(minDelay, proposers, executors, safe);
            console.log("Deployed Timelock:", address(timelock));
        }

        // Governor (wire to an existing ERC20Votes when known)
        ERC20Votes token = ERC20Votes(address(0));
        TAGITGovernor gov = new TAGITGovernor(
            token,
            TimelockController(address(timelock)),
            1,          // votingDelay (blocks)
            45818,      // votingPeriod (~1 week)
            0,          // proposalThreshold (votes)
            4           // quorumPercent
        );
        console.log("Deployed Governor:", address(gov));

        // IMPORTANT: Do NOT grant roles here. The Safe (admin) will do it post‑deploy.
        vm.stopBroadcast();
    }
}
