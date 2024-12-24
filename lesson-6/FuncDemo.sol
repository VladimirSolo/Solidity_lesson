// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.2 <0.9.0;

/**
 * @title FuncDemo
 * @notice This contract demonstrates the use of the `receive` and `fallback` functions to handle incoming ether transfers.
 * The contract also tracks the balance of each sender.
 * 
*                                       send Ether
                                            |
                                msg.data is empty?
                                      /           \
                                  yes             no
                                  |                |
                          receive() exists?     fallback()
                              /        \
                          yes          no
                            |            |
                        receive()     fallback()
 *
 */
contract FuncDemo {
  address public sender;
  mapping(address => uint) public balanceReceived;

  /**
   * @dev This function allows anyone to send ether to the contract.
   * It records the amount of ether received from the sender.
   */
  function receiveMoney() public payable {
    balanceReceived[msg.sender] += msg.value;  // Add the received ether to the sender's balance
  }

  /**
   * @dev Fallback function is triggered when the contract receives ether but does not match any other function signature.
   * The fallback function simply records the address of the sender.
   * It is external and payable, allowing the contract to accept ether.
   */
  fallback() external payable { 
    sender = msg.sender;  // Record the sender's address who called the fallback function
  }

  /**
   * @dev Receive function is triggered when the contract receives ether.
   * It calls the `receiveMoney` function to record the ether sent.
   * The receive function is external and payable, and is executed when the data sent is empty.
   */
  receive() external payable { 
    receiveMoney();  // Call the `receiveMoney` function to track ether sent to the contract
  }
}
