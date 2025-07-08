// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.13;

contract ReducingPayout {
    /*
     This exercise assumes you know how block.timestamp works.
     1. This contract has 1 ether in it, each second that goes by,
     the amount that can be withdrawn by the caller goes from 100% to 0% as 24 hours passes.
     2. Implement your logic in `withdraw` function.
     Hint: 1 second deducts 0.0011574% from the current %.
     */

    // The time 1 ether was sent to this contract
    uint256 public immutable depositedTime;

    constructor() payable {
        depositedTime = block.timestamp;
    }

    function withdraw() public {
        // Calculate elapsed time since deposit
        uint256 elapsedTime = block.timestamp - depositedTime;

        // 24 hours in seconds
        uint256 maxTime = 24 * 60 * 60; // 86,400 seconds

        // Calculate withdrawable amount based on original deposit (1 ether)
        // Formula from test: 1 ether - ((elapsedTime * 0.0011574 ether) / 100)
        uint256 withdrawableAmount;

        if (elapsedTime >= maxTime) {
            withdrawableAmount = 0;
        } else {
            // Using the exact formula from the test
            // 0.0011574% per second = 0.0011574 * 1 ether / 100
            uint256 reduction = (elapsedTime * 0.0011574 ether) / 100;
            withdrawableAmount = 1 ether - reduction;
        }

        // Ensure contract has enough balance for the withdrawal
        require(
            address(this).balance >= withdrawableAmount,
            "Insufficient contract balance"
        );

        // Transfer the withdrawable amount to the caller (even if it's 0)
        if (withdrawableAmount > 0) {
            payable(msg.sender).transfer(withdrawableAmount);
        }
    }

    // Optional: View function to check current withdrawable amount
    function getWithdrawableAmount() public view returns (uint256) {
        uint256 elapsedTime = block.timestamp - depositedTime;
        uint256 maxTime = 24 * 60 * 60;

        if (elapsedTime >= maxTime) {
            return 0;
        }

        uint256 reduction = (elapsedTime * 0.0011574 ether) / 100;
        return 1 ether - reduction;
    }

    // Optional: View function to check remaining time
    function getRemainingTime() public view returns (uint256) {
        uint256 elapsedTime = block.timestamp - depositedTime;
        uint256 maxTime = 24 * 60 * 60;

        if (elapsedTime >= maxTime) {
            return 0;
        }

        return maxTime - elapsedTime;
    }
}
