// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import {IVotes} from "openzeppelin-contracts/governance/utils/IVotes.sol";
import {Governor} from "openzeppelin-contracts/governance/Governor.sol";
import {GovernorSettings} from "openzeppelin-contracts/governance/extensions/GovernorSettings.sol";
import {GovernorCountingSimple} from "openzeppelin-contracts/governance/extensions/GovernorCountingSimple.sol";
import {GovernorVotes} from "openzeppelin-contracts/governance/extensions/GovernorVotes.sol";
import {GovernorVotesQuorumFraction} from "openzeppelin-contracts/governance/extensions/GovernorVotesQuorumFraction.sol";
import {GovernorTimelockControl} from "openzeppelin-contracts/governance/extensions/GovernorTimelockControl.sol";
import {TimelockController} from "openzeppelin-contracts/governance/TimelockController.sol";

/// @title TAGITGovernor
/// @notice OZ Governor configured for TAGIT with Timelock.
contract TAGITGovernor is
    Governor,
    GovernorSettings,
    GovernorCountingSimple,
    GovernorVotes,
    GovernorVotesQuorumFraction,
    GovernorTimelockControl
{
    constructor(
        IVotes token,
        TimelockController timelock,
        uint256 votingDelayBlocks,
        uint256 votingPeriodBlocks,
        uint256 proposalThresholdVotes,
        uint256 quorumPercent
    )
        Governor("TAGITGovernor")
        GovernorSettings(votingDelayBlocks, votingPeriodBlocks, proposalThresholdVotes)
        GovernorVotes(token)
        GovernorVotesQuorumFraction(quorumPercent)
        GovernorTimelockControl(timelock)
    {}

    // ---- Required Solidity overrides ----
    function votingDelay() public view override(Governor, GovernorSettings) returns (uint256) {
        return super.votingDelay();
    }

    function votingPeriod() public view override(Governor, GovernorSettings) returns (uint256) {
        return super.votingPeriod();
    }

    function quorum(uint256 blockNumber)
        public
        view
        override(Governor, GovernorVotesQuorumFraction)
        returns (uint256)
    { return super.quorum(blockNumber); }

    function proposalThreshold()
        public
        view
        override(Governor, GovernorSettings)
        returns (uint256)
    { return super.proposalThreshold(); }

    function state(uint256 proposalId)
        public view override(Governor, GovernorTimelockControl)
        returns (ProposalState)
    { return super.state(proposalId); }

    function _execute(uint256 pid, address[] memory targets, uint256[] memory values, bytes[] memory calldatas, bytes32 descHash)
        internal
        override(Governor, GovernorTimelockControl)
    { super._execute(pid, targets, values, calldatas, descHash); }

    function _cancel(address[] memory targets, uint256[] memory values, bytes[] memory calldatas, bytes32 descHash)
        internal
        override(Governor, GovernorTimelockControl)
        returns (uint256)
    { return super._cancel(targets, values, calldatas, descHash); }

    function _executor() internal view override(Governor, GovernorTimelockControl) returns (address) {
        return super._executor();
    }

    function supportsInterface(bytes4 iid) public view override(Governor, GovernorTimelockControl) returns (bool) {
        return super.supportsInterface(iid);
    }
}
