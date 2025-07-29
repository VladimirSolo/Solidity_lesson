// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.13;

contract Withdraw {
    receive() external payable {}

    // @notice make this contract able to receive ether from anyone and anyone can call withdraw below to withdraw all ether from it
    function withdraw() public {
        payable(msg.sender).transfer(address(this).balance);
    }
}
