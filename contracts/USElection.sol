// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

pragma abicoder v2;

contract USElection is Ownable {
    uint8 public constant BIDEN = 1;
    uint8 public constant TRUMP = 2;
    
    bool public electionEnded;
    
    mapping(uint8 => uint8) public seats;
    
    event LogStateResult(uint8 winner, uint8 stateSeats, string state);


    event LogElectionEnded(uint winner);

    modifier onlyActiveElection() {
        require(!electionEnded, "The election has ended already");
        _;
    }

    struct StateResult {
        string name;
        uint votesBiden;
        uint votesTrump;
        uint8 stateSeats;
    }
    
  
function submitStateResult(StateResult calldata result) public onlyActiveElection {
    require(result.stateSeats > 0, "States must have at least 1 seat");
    require(result.votesBiden != result.votesTrump, "There cannot be a tie");
    uint8 winner;
    if(result.votesBiden > result.votesTrump) {
        winner = BIDEN;
    } else {
        winner = TRUMP;
    }
    
    seats[winner] += result.stateSeats;
    
    emit LogStateResult(winner, result.stateSeats, result.name);
}

    
   function currentLeader() public view returns(uint8) {
    if(seats[BIDEN] > seats[TRUMP]) {
        return BIDEN;
    }
    if(seats[TRUMP] > seats[BIDEN]) {
        return TRUMP;
    }
    return 0;
}
    
 function endElection() public onlyActiveElection {
        electionEnded = true;
        emit LogElectionEnded(currentLeader());
    }
    
}