// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;


contract Voting {
   error Voting__onlyOwner();
   error Voting__notQualified();
   error Voting__votingTimePassed();
   error Voting__mustBeOlderThan18();
   error Voting__alreadyVoted();
   error Voting__invalidCandidateIndex();

    address public owner;
    uint256 public totalVotes;
    uint256 public votingEnded;


    mapping(address => bool) public hasVoted;
    mapping(address => bool) public authorizedVoter;
    mapping(address => uint256) public qualifiedAge;


    struct Candidate {
        string name;
        string partyName;
        uint256 voteCount;
    }

    Candidate[] public candidates;

   
   constructor(uint256 _votingDuration) {
    owner = msg.sender;
    votingEnded = block.timestamp + _votingDuration;
   }

    ////////////////////////////////////////
    ///////////////MODIFIERS///////////////
    //////////////////////////////////////

    modifier onlyOwner() {
        require(msg.sender == owner, Voting__onlyOwner());
        _;
    }

    modifier qualifiedVoter() {
      require(authorizedVoter[msg.sender], Voting__notQualified());
        _;
    }

    modifier votingTime() {
        require(block.timestamp < votingEnded, Voting__votingTimePassed());
        _;
    }


    //////////////////////////////////////////////
    ///////////////SETTER FUNCTIONS///////////////
    //////////////////////////////////////////////

    function addCandidate(string memory _name, string memory _partyName) public  onlyOwner{
    Candidate memory newCandidate = Candidate({ name: _name, partyName: _partyName, voteCount: 0});
    candidates.push(newCandidate);
    }


    function canVote(address user, uint256 age) public onlyOwner {
        require(age >= 18, Voting__mustBeOlderThan18());
        authorizedVoter[user] = true;
        qualifiedAge[user] = age;
    }



    function vote(uint256 candidateIndex) public qualifiedVoter votingTime {
        require(!hasVoted[msg.sender], Voting__alreadyVoted());
        require(candidateIndex < candidates.length, Voting__invalidCandidateIndex());

        hasVoted[msg.sender] = true;
        candidates[candidateIndex].voteCount += 1;
        totalVotes += 1;
    }


    function endVoting() public onlyOwner {
        votingEnded = block.timestamp;
    }


    /////////////////////////////////////////////
    ///////////////GETTER FUNCTIONS///////////////
    //////////////////////////////////////////////

    function getCanditateIndex(uint256 index) public view returns(string memory, string memory, uint256){
        require(index < candidates.length, Voting__invalidCandidateIndex());
        Candidate memory candidate = candidates[index];
        return (candidate.name, candidate.partyName, candidate.voteCount);
    }


    function getCandidateCount() public view returns(uint256) {
        return candidates.length;
    }


    function getRemainingVotingTime() public view returns(uint256) {
        if(block.timestamp >= votingEnded) {
            return 0;
        }
            return (votingEnded - block.timestamp);
    }


    function getTotalVotes() public view returns(uint256) {
        return totalVotes;
    }



}

 






