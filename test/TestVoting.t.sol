// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {Voting} from "../src/Voting.sol";
import {Deploy} from "../script/DeployVoting.s.sol";

contract testVote is Test {
    uint256 public constant votingDays = 5 days;

     Voting public voting;
     Deploy public deploy;

    function setUp() public {
        voting = new Voting(votingDays);
        deploy = new Deploy();

          voting.addCandidate("Obama", "party1");
          voting.addCandidate("Trump", "party2");
    }

    function test_addcandidate() public {
        voting.addCandidate("Kamela", "party3");
        assertEq(voting.getCandidateCount(), 3);
    }

    function test_getCandidateIndex() public {
      (string memory name, string memory party, uint256 voteCount) = voting.getCanditateIndex(0);
      assertEq(name, "Obama");
      assertEq(party, "party1");
      assertEq(voteCount, 0);

    }

    function test_vote() public {
        vm.warp(block.timestamp + 4 days);
         voting.vote(0);
        vm.prank(address(0x1234));
        voting.vote(1);
        vm.prank(address(0x5678));
        voting.vote(0);
        assertEq(voting.getTotalVotes(), 3);
        assertEq(voting.getVotePerCandidate(1), 1);
        voting.getRemainingVotingTime();
        voting.getWinner();
    }

    function test_onlyOwnerAddCandidate() public {
    vm.prank(address(0x1234)); // Using address(0x1234) as a non-owner address
    vm.expectRevert(Voting.Voting__onlyOwner.selector);
    voting.addCandidate("NonOwnerCandidate", "party4");
}

    function test_votingTime() public {
        vm.warp(block.timestamp + 10 days);
        vm.expectRevert(Voting.Voting__VotingEnded.selector);
        voting.vote(0);
    }

    function test_remainingTime() public {
        vm.warp(block.timestamp + 7 days);
        voting.getRemainingVotingTime();
        assertEq(voting.getRemainingVotingTime(), 0);
    }

     function test_getCandidateCount() public {
        voting.getCandidateCount();
        assertEq(voting.getCandidateCount(), 2);
    }

    
    function test_deployment() public {
        voting = deploy.run();
        
        // Check if the contract was deployed correctly
        assertTrue(address(voting) != address(0), "Voting contract not deployed");

        // Validate the voting duration is set correctly with a tolerance
        uint256 votingDuration = voting.i_votingEnded();
        uint256 currentTime = block.timestamp;
        uint256 expectedVotingEnd = currentTime + 5 days;
        
        // Allow a tolerance of ±2 seconds
        assertTrue(votingDuration >= expectedVotingEnd - 2 && votingDuration <= expectedVotingEnd + 2, "Voting duration should be approximately 5 days");
    }

}