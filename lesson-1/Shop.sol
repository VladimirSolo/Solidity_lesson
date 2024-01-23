// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;
// logic will saved in smart conract
contract MyShop {
    address public owner;
    mapping (address => uint) public payments;

//0xd9145CCE52D386f254917e481eB44e9943F39138
    constructor() {
        owner = msg.sender;
    }
// paybale for money
    function payForItem() public payable {
        // msg.value - money
        payments[msg.sender] = msg.value;
    }

    function withdrawAll() public {
        // only in function
        address payable  _to = payable(owner);
        address _thisContract = address(this);
        // take money - _thisContract.balance and send to _to.transfer
        _to.transfer(_thisContract.balance);
    }
}

// for trans pay gas