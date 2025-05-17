// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.13;

contract BasicBank {
    /// @notice deposit ether into the contract
    /// @dev it should work properly when called multiple times
    function addEther() external payable {
        require(msg.value > 0, "Must send Ether to deposit");
    }

    /// @notice used to withdraw ether from the contract (No restriction on withdrawals)
    function removeEther(uint256 amount) external {
        require(
            address(this).balance >= amount,
            "Insufficient contract balance"
        );

        (bool sent, ) = msg.sender.call{value: amount}("");
        require(sent, "Failed to send Ether");
    }
}
