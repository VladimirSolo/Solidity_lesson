// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.13;

contract OneWeekLockup {
    mapping(address => uint256) private balances;
    mapping(address => uint256) private lastDepositTime;

    uint256 constant ONE_WEEK = 7 days;

    /// @notice Deposit ether into the contract
    function depositEther() external payable {
        require(msg.value > 0, "Must deposit more than 0");

        balances[msg.sender] += msg.value;
        lastDepositTime[msg.sender] = block.timestamp;
    }

    /// @notice Withdraw ether from the contract (after one week from last deposit)
    /// @param amount The amount to withdraw
    function withdrawEther(uint256 amount) external {
        require(amount > 0, "Cannot withdraw zero");
        require(balances[msg.sender] >= amount, "Insufficient balance");
        require(
            block.timestamp >= lastDepositTime[msg.sender] + ONE_WEEK,
            "Must wait 1 week after last deposit"
        );

        balances[msg.sender] -= amount;

        // Transfer ETH to sender
        (bool success, ) = msg.sender.call{value: amount}("");
        require(success, "ETH transfer failed");
    }

    /// @notice View the balance of a user
    /// @param user The address to query
    /// @return The amount of ether deposited by the user
    function balanceOf(address user) public view returns (uint256) {
        return balances[user];
    }
}
