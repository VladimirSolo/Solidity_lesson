// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.2 <0.9.0;

/**
 * @title Function 
 * @notice modifier
 */

contract ModifierDemo {
  address owner;

    //  Modifier to check that the caller is the owner of the contract.
    modifier onlyOwner() {
        require(msg.sender == owner, "You are not an owner!");
        // Underscore is a special character only used inside a function modifier and it tells Solidity to execute the rest of the code.
        _;
    }

    // Modifiers can take inputs.
    modifier checkSum(uint _amount) {
        require(_amount  < 1 ether, "Too much!");
        _;
    }

  constructor() {
    owner = msg.sender;
  }

  function withdrawAllMoney(address payable _to) public onlyOwner {
    _to.transfer(address(this).balance);
  }

  function withdrawPartiallMoney(address payable _to, uint _amount) public onlyOwner checkSum(_amount) {
    _to.transfer(address(this).balance);
  }

  function destroyContract(address payable _to) public onlyOwner {
    selfdestruct(_to);
  }
}