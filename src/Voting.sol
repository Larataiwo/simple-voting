// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Voting {
    error Voting__onlyOwner();
    error Voting__VotingEnded();
    error Voting__alreadyVoted();
    error Voting__invalidCandidateIndex();
    error Voting__NoCandidateAvailable();

    address private immutable i_owner;
    uint256 public immutable i_votingEnded;
    uint256 public totalVotes;

    mapping(address => bool) public hasVoted;
    
    struct Candidate {
        string name;
        string partyName;
        uint256 voteCount;
    }

    // Mapping for candidates and counter for keeping track of candidates
    mapping(uint256 => Candidate) public candidates;
    uint256 public candidateCount;

    constructor(uint256 _votingDuration) {
        i_owner = msg.sender;
        i_votingEnded = block.timestamp + _votingDuration;
    }

    event CandidateAdded(string name, string partyName);
    event VoteCasted(address voter, uint256 candidateIndex);


    modifier onlyOwner() {
        require(msg.sender == i_owner, Voting__onlyOwner());
        _;
    }


    modifier votingTime() {
        require(block.timestamp < i_votingEnded, Voting__VotingEnded());
        _;
    }


    function addCandidate(string memory _name, string memory _partyName) public onlyOwner {
        candidates[candidateCount] = Candidate(_name, _partyName, 0);
        candidateCount++;

        emit CandidateAdded(_name, _partyName);
    }


    function vote(uint256 candidateIndex) public votingTime {
        require(!hasVoted[msg.sender], Voting__alreadyVoted());
        require(candidateIndex < candidateCount, Voting__invalidCandidateIndex());

        hasVoted[msg.sender] = true;
        candidates[candidateIndex].voteCount += 1;
        totalVotes += 1;

        emit VoteCasted(msg.sender, candidateIndex);
    }

      function getWinner() public view returns (string memory winnerName, string memory winnerParty, uint256 winnerVoteCount) {
        require(candidateCount > 0, Voting__NoCandidateAvailable());
        
        uint256 winningVoteCount = 0;
        uint256 winningIndex = 0;

        for (uint256 i = 0; i < candidateCount; i++) {
            if (candidates[i].voteCount > winningVoteCount) {
                winningVoteCount = candidates[i].voteCount;
                winningIndex = i;
            }
        }
        Candidate memory winner = candidates[winningIndex];
        return (winner.name, winner.partyName, winner.voteCount);
    }


    function getCanditateIndex(uint256 index) public view returns (string memory, string memory, uint256) {
        require(index < candidateCount, Voting__invalidCandidateIndex());
        Candidate memory candidate = candidates[index];
        return (candidate.name, candidate.partyName, candidate.voteCount);
    }

    function getCandidateCount() public view returns (uint256) {
        return candidateCount;
    }

    function getRemainingVotingTime() public view returns (uint256) {
        if (block.timestamp >= i_votingEnded) {
            return 0;
        }
        return (i_votingEnded - block.timestamp);
    }

    function getTotalVotes() public view returns (uint256) {
        return totalVotes;
    }

    function getVotePerCandidate(uint256 candidateIndex) public view returns (uint256) {
        return candidates[candidateIndex].voteCount;
    }
}
