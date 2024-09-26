// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {Voting} from "../src/Voting.sol";

contract Deploy is Script {
    uint256 public constant votingDays = 5 days;

    function run() external returns (Voting) {
        vm.startBroadcast();
        Voting voting = new Voting(votingDays);
        vm.stopBroadcast();
        return voting;
    }
}
