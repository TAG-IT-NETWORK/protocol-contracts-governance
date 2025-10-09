// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import {ERC20Votes} from "openzeppelin-contracts/token/ERC20/extensions/ERC20Votes.sol";
import {Governor} from "openzeppelin-contracts/governance/Governor.sol";
import {GovernorCountingSimple} from "openzeppelin-contracts/governance/extensions/GovernorCountingSimple.sol";
import {GovernorVotes} from "openzeppelin-contracts/governance/extensions/GovernorVotes.sol";
import {GovernorVotesQuorumFraction} from "openzeppelin-contracts/governance/extensions/GovernorVotesQuorumFraction.sol";
import {GovernorTimelockControl} from "openzeppelin-contracts/governance/extensions/GovernorTimelockControl.sol";
import {TimelockController} from "openzeppelin-contracts/governance/TimelockController.sol";

/// @title TAGITGovernor
/// @notice Role-weighted Governor configuration for TAG IT Network governance.
contract TAGITGovernor is
    Governor,
    GovernorCountingSimple,
    GovernorVotes,
    GovernorVotesQuorumFraction,
    GovernorTimelockControl
{
    uint256 private immutable _votingDelayBlocks;
    uint256 private immutable _votingPeriodBlocks;
    uint256 private immutable _proposalThresholdVotes;

    constructor(
        ERC20Votes token,
        TimelockController timelock,
        uint256 votingDelayBlocks,
        uint256 votingPeriodBlocks,
        uint256 proposalThresholdVotes,
        uint256 quorumPercent
    )
        Governor("TAGITGovernor")
        GovernorVotes(token)
        GovernorVotesQuorumFraction(quorumPercent)
        GovernorTimelockControl(timelock)
    {
        require(quorumPercent > 0 && quorumPercent <= 100, "Invalid quorum percent");
        require(votingPeriodBlocks > 0, "Voting period must be > 0");

        _votingDelayBlocks = votingDelayBlocks;
        _votingPeriodBlocks = votingPeriodBlocks;
        _proposalThresholdVotes = proposalThresholdVotes;
    }

    // ---------------------------------------------------------------------
    // Governor configuration
    // ---------------------------------------------------------------------

    function votingDelay() public view override returns (uint256) {
        return _votingDelayBlocks;
    }

    function votingPeriod() public view override returns (uint256) {
        return _votingPeriodBlocks;
    }

    function proposalThreshold() public view override returns (uint256) {
        return _proposalThresholdVotes;
    }

    // ---------------------------------------------------------------------
    // Timelock wiring
    // ---------------------------------------------------------------------

    function state(uint256 proposalId)
        public
        view
        override(Governor, GovernorTimelockControl)
        returns (ProposalState)
    {
        return super.state(proposalId);
    }

    function propose(
        address[] memory targets,
        uint256[] memory values,
        bytes[] memory calldatas,
        string memory description
    ) public override(Governor) returns (uint256) {
        return super.propose(targets, values, calldatas, description);
    }

    function quorum(uint256 blockNumber)
        public
        view
        override(Governor, GovernorVotesQuorumFraction)
        returns (uint256)
    {
        return super.quorum(blockNumber);
    }

    function _execute(
        uint256 proposalId,
        address[] memory targets,
        uint256[] memory values,
        bytes[] memory calldatas,
        bytes32 descriptionHash
    ) internal override(Governor, GovernorTimelockControl) {
        super._execute(proposalId, targets, values, calldatas, descriptionHash);
    }

    function _cancel(
        address[] memory targets,
        uint256[] memory values,
        bytes[] memory calldatas,
        bytes32 descriptionHash
    ) internal override(Governor, GovernorTimelockControl) returns (uint256) {
        return super._cancel(targets, values, calldatas, descriptionHash);
    }

    function _executor()
        internal
        view
        override(Governor, GovernorTimelockControl)
        returns (address)
    {
        return super._executor();
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(Governor, GovernorTimelockControl)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
