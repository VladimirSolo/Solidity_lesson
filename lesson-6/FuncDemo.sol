// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.2 <0.9.0;

/**
 * @title Function
 * @notice  receive fallback
 */

contract FuncDemo {
  address sender;
  mapping(address => uint) public balanceReceived;
    
  function receiveMoney() public payable {
    balanceReceived[msg.sender] += msg.value;
  }

  fallback() external payable { 
    sender = msg.sender;
  }

  receive() external payable { 
    receiveMoney(); 
  }
}
