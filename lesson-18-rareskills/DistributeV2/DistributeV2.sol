// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.13;

contract DistributeV2 {
    /*
     This exercise assumes you know how to sending Ether.
     1. This contract has some ether in it, distribute it equally among the
     array of addresses that is passed as argument.
     2. Write your code in the `distributeEther` function.
     3. Consider scenarios where one of the recipients rejects the ether transfer,
     have a work around for that whereby other recipients still get their transfer
     */

    event TransferFailed(address indexed recipient, uint256 amount);
    event TransferSucceeded(address indexed recipient, uint256 amount);

    constructor() payable {}

    function distributeEther(address[] memory addresses) public {
        require(addresses.length > 0, "No addresses provided");

        uint256 totalBalance = address(this).balance;
        require(totalBalance > 0, "No ether to distribute");

        uint256 amountPerAddress = totalBalance / addresses.length;
        require(amountPerAddress > 0, "Amount per address is zero");

        // Attempt to send to all addresses
        for (uint256 i = 0; i < addresses.length; i++) {
            address recipient = addresses[i];

            // Skip zero addresses
            if (recipient == address(0)) {
                emit TransferFailed(recipient, amountPerAddress);
                continue;
            }

            // Use call with low-level error handling
            (bool success, ) = recipient.call{value: amountPerAddress}("");

            if (success) {
                emit TransferSucceeded(recipient, amountPerAddress);
            } else {
                emit TransferFailed(recipient, amountPerAddress);
            }
        }
    }

    // Helper function to check contract balance
    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }

    // Allow contract to receive ether
    receive() external payable {}

    fallback() external payable {}
}
