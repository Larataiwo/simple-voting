// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {Voting} from "../src/Voting.sol";


contract Deploy is Script {
    Voting public voting;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        voting = new Voting();

        vm.stopBroadcast();
    }
}