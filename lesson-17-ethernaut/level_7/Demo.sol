// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Demo {
    bool public disabled;
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not an owner!");
        _;
    }

    function disable() public onlyOwner {
        disabled = true;
    }

    receive() external payable {
        require(!disabled, "Disabled!");
    }
}

contract Helper {
    function getSize(address _adr) public view returns (uint256) {
        return _adr.code.length;
    }
}
