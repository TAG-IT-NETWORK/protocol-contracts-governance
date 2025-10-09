// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import {TimelockController} from "openzeppelin-contracts/governance/TimelockController.sol";

/// @title TAGITTimelock
/// @notice Thin wrapper around OpenZeppelin's TimelockController that sets the
///         Safe (or other multisig) as the admin authority from construction.
contract TAGITTimelock is TimelockController {
    constructor(
        uint256 minDelay,
        address[] memory proposers,
        address[] memory executors,
        address admin
    ) TimelockController(minDelay, proposers, executors, admin) {}
}
