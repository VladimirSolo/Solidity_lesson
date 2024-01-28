// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract Adress {
    uint public balanceReceived;

    function receiveMoney() public payable {
        balanceReceived += msg.value;
    }

    function getBalance() public view returns (uint) {
        return address(this).balance;
    }

    function withdrawMoney() public {
        address payable receiver = payable(msg.sender);
        receiver.transfer(this.getBalance());
    }

    // argument - address
    function withdrawMoneyInput(address payable _address) public {
        address payable receiver = _address;
        receiver.transfer(this.getBalance());
    }
}
