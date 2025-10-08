// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;
import {Test} from "forge-std/Test.sol";
import {ERC20Votes} from "openzeppelin-contracts/token/ERC20/extensions/ERC20Votes.sol";
import {ERC20} from "openzeppelin-contracts/token/ERC20/ERC20.sol";
import {TAGITGovernor} from "src/TAGITGovernor.sol";
import {TAGITTimelock} from "src/TAGITTimelock.sol";
import {TimelockController} from "openzeppelin-contracts/governance/TimelockController.sol";

contract GovToken is ERC20, ERC20Votes {
    constructor() ERC20("GovToken","GOV") ERC20Votes() { _mint(msg.sender, 1_000_000 ether); }
    function _update(address from, address to, uint256 value) internal override(ERC20, ERC20Votes) { super._update(from,to,value); }
    function nonces(address owner) public view override(ERC20Votes) returns (uint256) { return super.nonces(owner); }
}

contract Box { uint256 public value; function store(uint256 v) external { value = v; } }

contract GovernanceFlowTest is Test {
    address alice = address(0xA11CE);
    address bob   = address(0xB0B);
    GovToken token;
    TAGITTimelock timelock;
    TAGITGovernor governor;
    Box box;

    function setUp() public {
        token = new GovToken();
        token.transfer(alice, 100_000 ether);
        token.transfer(bob,   100_000 ether);
        vm.prank(alice); token.delegate(alice);
        vm.prank(bob);   token.delegate(bob);

        address[] memory proposers = new address[](0);
        address[] memory executors = new address[](1); executors[0] = address(0);
        timelock = new TAGITTimelock(1, proposers, executors, address(this));

        governor = new TAGITGovernor(token, TimelockController(address(timelock)), 1, 100, 0, 4);
        timelock.grantRole(timelock.PROPOSER_ROLE(), address(governor));
        timelock.grantRole(timelock.EXECUTOR_ROLE(), address(0));

        box = new Box();
    }

    function test_fullGovernanceLifecycle() public {
        address[] memory targets = new address[](1); targets[0] = address(box);
        uint256[] memory values = new uint256[](1); values[0] = 0;
        bytes[] memory calldatas = new bytes[](1); calldatas[0] = abi.encodeWithSelector(Box.store.selector, 42);
        string memory desc = "Set box to 42";

        uint256 pid = governor.propose(targets, values, calldatas, desc);
        vm.roll(block.number + governor.votingDelay());

        vm.prank(alice); governor.castVote(pid, 1);
        vm.prank(bob);   governor.castVote(pid, 1);

        vm.roll(block.number + governor.votingPeriod());
        bytes32 hash = keccak256(bytes(desc));
        governor.queue(targets, values, calldatas, hash);
        vm.warp(block.timestamp + 2);
        governor.execute(targets, values, calldatas, hash);

        assertEq(box.value(), 42);
    }
}
