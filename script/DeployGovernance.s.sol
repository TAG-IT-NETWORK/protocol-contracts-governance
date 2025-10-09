// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "@openzeppelin/contracts/governance/TimelockController.sol";
import "@openzeppelin/contracts/governance/Governor.sol";
import "@openzeppelin/contracts/governance/extensions/GovernorSettings.sol";
import "@openzeppelin/contracts/governance/extensions/GovernorCountingSimple.sol";
import "@openzeppelin/contracts/governance/extensions/GovernorVotes.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Votes.sol";

contract GovToken is ERC20Votes {
    constructor() ERC20("TAGIT GOV", "TAGG") ERC20Permit("TAGIT GOV") { _mint(msg.sender, 1_000_000e18); }
    // required overrides
    function _update(address from, address to, uint256 value) internal override(ERC20, ERC20Votes) { super._update(from,to,value); }
    function nonces(address owner) public view override(ERC20Permit) returns (uint256) { return super.nonces(owner); }
}

contract Gov is Governor, GovernorSettings, GovernorCountingSimple, GovernorVotes {
    constructor(IVotes _token)
        Governor("TAGIT-Governor")
        GovernorSettings(1 /*delay*/, 45818 /*period ~1w*/, 100_000e18 /*proposal threshold*/)
        GovernorVotes(_token)
    {}
    function quorum(uint256) public pure override returns (uint256) { return 200_000e18; }
    function votingDelay() public view override(Governor, GovernorSettings) returns (uint256) { return super.votingDelay(); }
    function votingPeriod() public view override(Governor, GovernorSettings) returns (uint256) { return super.votingPeriod(); }
    function proposalThreshold() public view override(Governor, GovernorSettings) returns (uint256) { return super.proposalThreshold(); }
}

contract DeployGovernance is Script {
    function run() external {
        uint256 pk = vm.envUint("DEPLOYER_KEY_U256"); // used locally if you prefer numeric
        vm.startBroadcast(); // forge uses DEPLOYER_KEY when provided

        address;
        address;
        proposers[0] = msg.sender;
        executors[0] = address(0);

        GovToken token = new GovToken();
        TimelockController timelock = new TimelockController(2 days, proposers, executors, msg.sender);
        Gov governor = new Gov(IVotes(address(token)));

        // OPTIONAL: wire governance → timelock roles etc. (left simple for now)

        // Emit addresses for the Python shim to pick up (also dump to file):
        console2.log("GovToken", address(token));
        console2.log("TimelockController", address(timelock));
        console2.log("Governor", address(governor));

        // lightweight JSON dump for codex.py
        string memory file = string.concat(vm.projectRoot(), "/script/out.addresses.json");
        vm.writeJson(
            string(
                abi.encodePacked(
                    '{"GovToken":"', vm.toString(address(token)),
                    '","TimelockController":"', vm.toString(address(timelock)),
                    '","Governor":"', vm.toString(address(governor)),
                    '"}'
                )
            ),
            file
        );

        vm.stopBroadcast();
    }
}
