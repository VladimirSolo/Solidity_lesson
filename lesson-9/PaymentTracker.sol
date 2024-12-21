// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title PaymentForwarder
 * @dev This contract is used to interact with the PaymentTracker contract by forwarding payments.
 */
contract PaymentForwarder {
    /**
     * @notice Forwards the payment to the PaymentTracker contract and specifies the payer.
     * @dev The `forwardPayment` function forwards `msg.value` and the sender's address to the PaymentTracker contract.
     * @param _tracker The address of the PaymentTracker contract to interact with.
     */
    function forwardPayment(PaymentTracker _tracker) public payable {
        _tracker.pay{value: msg.value}(msg.sender);
    }
}

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
