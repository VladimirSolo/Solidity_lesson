// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.13;

// You may modify this contract
contract Parent {
    uint256 internal _value;
}

contract Child is Parent {
    function setValue(uint256 newValue) public {
        _value = newValue;
    }

    function getValue() public view returns (uint256) {
        return _value;
    }
}

/*
private: accessible only within the same contract.

internal: accessible within the same contract and derived contracts.

public: accessible from anywhere.

external: like public but callable only from outside the contract (not from internal functions).
 */
