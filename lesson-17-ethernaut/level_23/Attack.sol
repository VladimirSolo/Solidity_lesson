// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract AttackToken is ERC20 {
    constructor(uint256 initialSupply) ERC20("AttackToken", "ATK") {
        _mint(msg.sender, initialSupply);
    }
}
//https://docs.eridian.xyz/ethereum-dev/defi-challenges/ethernaut/level-23-dex-two
