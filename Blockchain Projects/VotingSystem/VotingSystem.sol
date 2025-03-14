// SPDX-License-Identifier: MIT
pragma solidity >= 0.8.19;

contract Vote{
    struct Candidate{
        string name;
        uint votecount;
    }

    mapping(address=>bool) public Voted;

    Candidate[] public candidates;

    address public owner;

    constructor(){
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only a owner can add candidates");
        _;
    }


    function AddCandidate(string memory _name) public onlyOwner{
        candidates.push(Candidate(_name, 0));
    }

    function doVote(uint _candidateIndex) public {
        require(!Voted[msg.sender], "You have already voted!");
        require(_candidateIndex < candidates.length, "Invalid candidate index");

        Voted[msg.sender] = true;
        candidates[_candidateIndex].votecount++;
    }


    function alreadyVoted() public view returns (bool) {
        return Voted[msg.sender];
    }

    function winner() public view returns( string memory, uint){
        require(candidates.length > 0, "No candidates available");

        uint winnerIndex = 0;

        uint max = 0; 
            for (uint256 i = 1; i<candidates.length ;i++){
                if(max < candidates[i].votecount) {
                    max = candidates[i].votecount;
                    winnerIndex = i;
                }   
            }
        return (candidates[winnerIndex].name, candidates[winnerIndex].votecount);
    }
}