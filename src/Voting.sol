// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;


contract Voting {
   error Voting__onlyOwner();
   error Voting__notQualified();
   error Voting__votingTimePassed();
   error Voting__mustBeOlderThan18();
   error Voting__alreadyVoted();
   error Voting__invalidCandidateIndex();

   event CandidateAdded(string name, string partyName);
   event VoteCasted(address voter, uint256 candidateIndex);
   event VotingEnded();

    address public owner;
    uint256 public totalVotes;
    uint256 public immutable i_votingEnded;


    mapping(address => bool) public hasVoted;
    mapping(address => bool) public authorizedVoter;
    mapping(address => uint256) public qualifiedAge;


    struct Candidate {
        string name;
        string partyName;
        uint256 voteCount;
    }

    // Mapping for candidates and counter for keeping track of candidates
        mapping(uint256 => Candidate) public candidates;
        uint256 public candidateCount;

    

   
   constructor(uint256 _votingDuration) {
    owner = msg.sender;
    i_votingEnded = block.timestamp + _votingDuration;
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
        require(block.timestamp < i_votingEnded, Voting__votingTimePassed());
        _;
    }


    //////////////////////////////////////////////
    ///////////////SETTER FUNCTIONS///////////////
    //////////////////////////////////////////////

    function addCandidate(string memory _name, string memory _partyName) public onlyOwner {
        candidates[candidateCount] = Candidate(_name, _partyName, 0);
        candidateCount++;

        emit CandidateAdded(_name, _partyName);
    }


    function canVote(address user, uint256 age) public onlyOwner {
        require(age >= 18, Voting__mustBeOlderThan18());
        authorizedVoter[user] = true;
        qualifiedAge[user] = age;
    }



    function vote(uint256 candidateIndex) public qualifiedVoter votingTime {
        require(!hasVoted[msg.sender], Voting__alreadyVoted());
        require(candidateIndex < candidateCount, Voting__invalidCandidateIndex());

        hasVoted[msg.sender] = true;
        candidates[candidateIndex].voteCount += 1;
        totalVotes += 1;

        emit VoteCasted(msg.sender, candidateIndex);

        if(i_votingEnded >= block.timestamp) {
            endVoting();
        }

    }


    function endVoting() internal {
        emit VotingEnded();
    }


    /////////////////////////////////////////////
    ///////////////GETTER FUNCTIONS///////////////
    //////////////////////////////////////////////

    function getCanditateIndex(uint256 index) 
        public 
        view 
        returns(string memory, string memory, uint256)
        {
        require(index < candidateCount, Voting__invalidCandidateIndex());
        Candidate memory candidate = candidates[index];
        return (candidate.name, candidate.partyName, candidate.voteCount);
    }


    function getCandidateCount() public view returns(uint256) {
        return candidateCount;
    }


    function getRemainingVotingTime() public view returns(uint256) {
        if(block.timestamp >= i_votingEnded) {
            return 0;
        }
            return (i_votingEnded - block.timestamp);
    }


    function getTotalVotes() public view returns(uint256) {
        return totalVotes;
    }



}

 






