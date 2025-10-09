// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;

import "forge-std/Test.sol";
import {TAGITToken} from "../src/TAGITToken.sol";
import {TAGITTimelock} from "../src/TAGITTimelock.sol";
import {TAGITGovernor} from "../src/TAGITGovernor.sol";

contract GovernanceTest is Test {
    TAGITToken token;
    TAGITTimelock timelock;
    TAGITGovernor gov;
    address voter = address(0xBEEF);

    function setUp() public {
        token = new TAGITToken();
        address[] memory proposers = new address[](1);
        address[] memory executors = new address[](1);
        proposers[0] = address(this);
        executors[0] = address(0);

        timelock = new TAGITTimelock(1 days, proposers, executors, address(this));
        gov = new TAGITGovernor(token, timelock);

        token.transfer(voter, 1000e18);
        vm.prank(voter);
        token.delegate(voter);
    }

    function test_quorumIsNonZero() public {
        assertGt(gov.quorum(0), 0);
    }
}
