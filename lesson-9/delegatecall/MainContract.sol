// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;


contract MainContract {
    address public sender;
    uint public amount;

    function getBalance() public view returns(uint) {
      return address(this).balance;
    }

    function pay() external  payable {
        sender = msg.sender;
        amount = msg.value;
    }
  

} 