// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title PaymentForwarder
 * @dev This contract is used to interact with the PaymentTracker contract by forwarding payments.
 */
interface IPaymentTracker {
    function pay(address _payer) external payable;
}

contract PaymentForwarder {
    /**
     * @notice Forwards the payment to the PaymentTracker contract and specifies the payer.
     * @dev The `forwardPayment` function forwards `msg.value` and the sender's address to the PaymentTracker contract.
     * @param _tracker The address of the Demo contract to interact with.
     */
    function forwardPayment(IPaymentTracker _tracker) public payable {
        _tracker.pay{value: msg.value}(msg.sender);
    }
}