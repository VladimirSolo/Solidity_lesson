// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract TokenExchange is Ownable {
    IERC20 token;

    constructor(address _token) Ownable(msg.sender) {
        token = IERC20(_token);
    }

    function byu() public payable {
        uint amount = msg.value; // wei

        require(amount >= 1);

        uint currentBalance = token.balanceOf(address(this));

        require(currentBalance >= amount);

        token.transfer(msg.sender, amount);
    }

    function sell(uint _amount) external {
        require(address(this).balance >= _amount);

        require(token.allowance(msg.sender, address(this)) >= _amount);

        token.transferFrom(msg.sender, address(this), _amount);

        (bool sent, ) = msg.sender.call{value: _amount}("");
        require(sent, "can not send");
    }

    function topUp() external payable onlyOwner {}

    receive() external payable {
        byu();
    }
}
