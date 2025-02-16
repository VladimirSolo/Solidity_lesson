// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

// import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./ERC20.sol";

contract RewardingToken is ERC20 {
    constructor() ERC20("Rewarding", "SW", 10) {}
}
