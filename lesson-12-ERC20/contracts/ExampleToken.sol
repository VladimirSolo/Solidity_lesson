// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "./ERC20.sol";
import "./ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ExampleToken is ERC20, ERC20Burnable, Ownable {
    constructor(
        address initialOwner
    ) ERC20("ExampleToken", "GTK") Ownable(initialOwner) {
        _mint(msg.sender, 5 * 10 ** decimals());
    }

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }
}
