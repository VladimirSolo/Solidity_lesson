// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title PaymentTracker
 * @dev This contract tracks and records payments made by different addresses.
 */
contract PaymentTracker {
    // Mapping to store payments made by each address.
    mapping(address => uint) public payments;

    /**
     * @notice Records a payment made by a specific address.
     * @dev The `pay` function updates the `payments` mapping with the sent value.
     * @param _payer The address of the account making the payment.
     */
    function pay(address _payer) public payable {
        payments[_payer] = msg.value;
    }
}
