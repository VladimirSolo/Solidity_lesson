// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.13;

contract CodeSize {
    uint256 public value;
    mapping(address => uint256) public balances;

    function setValue(uint256 _value) public {
        value = _value;
    }

    function getValue() public view returns (uint256) {
        return value;
    }

    function setBalance(address _addr, uint256 _amount) public {
        balances[_addr] = _amount;
    }

    function getBalance(address _addr) public view returns (uint256) {
        return balances[_addr];
    }

    function transfer(address _to, uint256 _amount) public {
        require(balances[msg.sender] >= _amount, "Insufficient balance");
        balances[msg.sender] -= _amount;
        balances[_to] += _amount;
    }
}
