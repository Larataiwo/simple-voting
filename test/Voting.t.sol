// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {Voting} from "../src/Voting.sol";

contract testVote is Test {
     Voting public voting;

    function setUp() public {
        voting = new Voting();
    }

}