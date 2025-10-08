// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import {TimelockController} from "openzeppelin-contracts/governance/TimelockController.sol";

/// @title TAGITTimelock
/// @notice Standard OZ TimelockController wrapper.
contract TAGITTimelock is TimelockController {
    constructor(
        uint256 minDelay,
        address[] memory proposers,
        address[] memory executors,
        address admin
    ) TimelockController(minDelay, proposers, executors, admin) {}
}
