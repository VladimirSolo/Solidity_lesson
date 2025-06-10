// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.13;

contract IdiotBettingGame {
    /*
        This exercise assumes you know how block.timestamp works.
        - Whoever deposits the most ether into a contract wins all the ether if no-one 
          else deposits after an hour.
        1. `bet` function allows users to deposit ether into the contract. 
           If the deposit is higher than the previous highest deposit, the endTime is 
           updated by current time + 1 hour, the highest deposit and winner are updated.
        2. `claimPrize` function can only be called by the winner after the betting 
           period has ended. It transfers the entire balance of the contract to the winner.
    */

    address public winner;
    uint public highestBet;
    uint public endTime;

    function bet() public payable {
        // Allow bet if no active betting period or betting period not ended
        require(
            endTime == 0 || block.timestamp < endTime,
            "Betting period has ended."
        );

        if (msg.value > highestBet) {
            highestBet = msg.value;
            winner = msg.sender;
            endTime = block.timestamp + 1 hours;
        }
    }

    function claimPrize() public {
        require(endTime != 0, "No bets placed yet.");
        require(block.timestamp >= endTime, "Betting period has not ended.");
        require(msg.sender == winner, "You are not the winner.");

        uint prize = address(this).balance;
        // Reset state before transfer to prevent reentrancy
        highestBet = 0;
        endTime = 0;
        winner = address(0);

        (bool success, ) = msg.sender.call{value: prize}("");
        require(success, "Transfer failed.");
    }
}
