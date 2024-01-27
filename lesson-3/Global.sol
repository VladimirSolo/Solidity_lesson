// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

// ! global variables

contract Global {
  uint public sum;
  address public sender;
  uint public timestap;
  uint public number;
  uint public limit;
  uint public price;
  address public contractAddr;
  uint public balance;

  function getData() public payable {
    sum = msg.value;
    sender = msg.sender;
    timestap = block.timestamp;
    number = block.number;
    limit = block.gaslimit;
    price = tx.gasprice;
    contractAddr = address(this);
    balance =contractAddr.balance;
  }
}

// https://docs.soliditylang.org/en/latest/units-and-global-variables.html