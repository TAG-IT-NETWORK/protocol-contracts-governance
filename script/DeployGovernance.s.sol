// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;

import "forge-std/Script.sol";
import {TAGITToken} from "../src/TAGITToken.sol";
import {TAGITTimelock} from "../src/TAGITTimelock.sol";
import {TAGITGovernor} from "../src/TAGITGovernor.sol";

contract DeployGovernance is Script {
    function run() external {
        uint256 deployerKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerKey);

        TAGITToken token = new TAGITToken();

        address[] memory proposers = new address[](1);
        address[] memory executors = new address[](1);
        proposers[0] = vm.addr(deployerKey);
        executors[0] = address(0);

        TAGITTimelock timelock = new TAGITTimelock(2 days, proposers, executors, vm.addr(deployerKey));
        TAGITGovernor governor = new TAGITGovernor(token, timelock);
        vm.label(address(token), "TAGITToken");
        vm.label(address(timelock), "TAGITTimelock");
        vm.label(address(governor), "TAGITGovernor");
        vm.stopBroadcast();
    }
}
