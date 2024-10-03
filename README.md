## Voting Smart Contract

This project is a decentralized voting system built using Solidity and Foundry. The smart contract allows an owner to add candidates, and users can vote for their preferred candidate within a specified voting period. 

The system ensures transparency by allowing public access to voting results, the total number of votes, and the winner after the voting period ends.



## Features

**Owner-controlled candidate management:** Only the contract owner can add candidates.

**Vote casting:** Users can vote for a candidate as long as the voting period has not ended.

**Prevention of double voting:** A user can only vote once.

**Winner determination:** After the voting period, the contract can reveal the candidate with the most votes.

**Candidate and vote statistics:** Anyone can view candidate details, vote counts, and remaining voting time.