// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.13;

contract Distribute {
    /*
     This exercise assumes you know how to sending Ether.
     1. This contract has some ether in it, distribute it equally among the
     array of addresses that is passed as argument.
     2. Write your code in the `distributeEther` function.
     */

    constructor() payable {}

    function distributeEther(address[] memory addresses) public {
        require(addresses.length > 0, "No addresses provided");

        uint256 totalBalance = address(this).balance;
        require(totalBalance > 0, "No ether to distribute");

        uint256 amountPerAddress = totalBalance / addresses.length;

        for (uint256 i = 0; i < addresses.length; i++) {
            require(addresses[i] != address(0), "Invalid address");

            (bool success, ) = addresses[i].call{value: amountPerAddress}("");
            require(success, "Transfer failed");
        }
    }
}

/* 
// Старый способ - может не работать:
payable(recipient).transfer(amount);

// Современный способ - надежнее:
(bool success, ) = recipient.call{value: amount}("");
require(success, "Transfer failed");
 */
