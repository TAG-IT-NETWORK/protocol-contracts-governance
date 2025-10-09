// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import {Test} from "forge-std/Test.sol";
import {TAGITGovernor} from "src/TAGITGovernor.sol";
import {TAGITTimelock} from "src/TAGITTimelock.sol";
import {Governor} from "openzeppelin-contracts/governance/Governor.sol";
import {ERC20} from "openzeppelin-contracts/token/ERC20/ERC20.sol";
import {ERC20Permit} from "openzeppelin-contracts/token/ERC20/extensions/ERC20Permit.sol";
import {ERC20Votes} from "openzeppelin-contracts/token/ERC20/extensions/ERC20Votes.sol";

contract TAGITGovernorTest is Test {
    uint256 internal constant MIN_DELAY = 2 days;

    address internal constant SAFE_ADMIN = address(0xA11CE);
    address internal constant VOTER = address(0xBEEF);

    TAGITTimelock internal timelock;
    TAGITGovernor internal governor;
    TestToken internal token;
    Counter internal counter;

    function setUp() public {
        token = new TestToken();
        token.mint(VOTER, 10 ether);
        vm.prank(VOTER);
        token.delegate(VOTER);

        address[] memory proposers = new address[](0);
        address[] memory executors = new address[](1);
        executors[0] = address(0);

        timelock = new TAGITTimelock(MIN_DELAY, proposers, executors, SAFE_ADMIN);
        governor = new TAGITGovernor(token, timelock, 1, 5, 0, 4);

        vm.prank(SAFE_ADMIN);
        timelock.grantRole(timelock.PROPOSER_ROLE(), address(governor));
        vm.prank(SAFE_ADMIN);
        timelock.grantRole(timelock.EXECUTOR_ROLE(), address(0));

        counter = new Counter();
    }

    function testConstructorSetsAdminToSafe() public {
        assertTrue(timelock.hasRole(timelock.DEFAULT_ADMIN_ROLE(), SAFE_ADMIN));
    }

    function testGovernorParameters() public {
        assertEq(governor.votingDelay(), 1);
        assertEq(governor.votingPeriod(), 5);
        assertEq(governor.proposalThreshold(), 0);
    }

    function testGovernorRevertsOnInvalidQuorum() public {
        vm.expectRevert("Invalid quorum percent");
        new TAGITGovernor(token, timelock, 1, 5, 0, 0);

        vm.expectRevert("Invalid quorum percent");
        new TAGITGovernor(token, timelock, 1, 5, 0, 101);
    }

    function testGovernorLifecycleThroughTimelock() public {
        address[] memory targets = new address[](1);
        targets[0] = address(counter);
        uint256[] memory values = new uint256[](1);
        bytes[] memory calldatas = new bytes[](1);
        calldatas[0] = abi.encodeWithSignature("increment()");
        string memory description = "Increment counter";

        uint256 proposalId = governor.propose(targets, values, calldatas, description);

        vm.roll(block.number + governor.votingDelay() + 1);
        vm.prank(VOTER);
        governor.castVote(proposalId, uint8(Governor.VoteType.For));

        vm.roll(block.number + governor.votingPeriod() + 1);

        bytes32 descriptionHash = keccak256(bytes(description));
        governor.queue(targets, values, calldatas, descriptionHash);

        vm.warp(block.timestamp + MIN_DELAY + 1);
        governor.execute(targets, values, calldatas, descriptionHash);

        assertEq(counter.value(), 1);
    }
}

contract TestToken is ERC20, ERC20Permit, ERC20Votes {
    constructor() ERC20("Test Token", "TST") ERC20Permit("Test Token") {}

    function mint(address to, uint256 amount) external {
        _mint(to, amount);
    }

    function _afterTokenTransfer(address from, address to, uint256 amount)
        internal
        override(ERC20, ERC20Votes)
    {
        super._afterTokenTransfer(from, to, amount);
    }

    function _mint(address to, uint256 amount) internal override(ERC20, ERC20Votes) {
        super._mint(to, amount);
    }

    function _burn(address account, uint256 amount) internal override(ERC20, ERC20Votes) {
        super._burn(account, amount);
    }
}

contract Counter {
    uint256 public value;

    function increment() external {
        value += 1;
    }
}
