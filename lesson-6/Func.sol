// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.2 <0.9.0;

/**
 * @title Function
 * @notice View Pure Public Paybale
 */

contract Func {
  uint public myNumber = 42; 
  mapping(address => uint) public balances;
   
  // call not payment
  function funcOne() public view  returns(uint) {
    return myNumber;
  }

  function funcTwo() public pure returns(uint) {
    return 420;
  }

  function funcThree() public pure returns(string memory) {
    return '42';
  }

  // transaction need payment
  function funcFour() public  returns(uint) {
    return myNumber ++;
  }

   function funcFive() public payable {
    balances[msg.sender] += msg.value;
  }
  
}
