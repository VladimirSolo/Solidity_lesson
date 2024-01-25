// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract Type {
  // it can be not only address  - string uint ..etc.
  mapping (address => uint) public payments; // if not uint will be defolt = 0 // storage

  address public myAddr = 0xd9145CCE52D386f254917e481eB44e9943F39138;

  function receive() public payable {
    // payments[0xd9145CCE52D386f254917e481eB44e9943F39138] = 42;
    payments[msg.sender] = msg.value; // money recieve - only when payable
  }

// transfer money
  function transfer(address targetAddress, uint amount) public {
    address payable _to = payable(targetAddress);
    _to.transfer(amount);
  }

// get info about balance
  function getBalance(address targetAddres) public view returns(uint) {
    return targetAddres.balance;
  }

  string public myStr = 'test'; // if length of string big -  more money // storage

  // we cant use concat to strings
  // myStr[0] - not working

  function demo(string memory newValueStr)  public {
    string memory myTempStr = 'temp'; // we cant say storage
    myStr = newValueStr;
  }
}