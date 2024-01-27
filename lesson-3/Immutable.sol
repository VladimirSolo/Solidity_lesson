// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract Immutable {
    // using less gas
    // not rewrite, add in constructor

    /* address public immutable owner;

    constructor(address _newOwner) {
      owner = _newOwner;
    }

    function getUint() public view returns(uint) {
      // check
      require(msg.sender == owner, '');
      return 42;
    } */

    // from documentation
    string constant TEXT = "abc";
    bytes32 constant MY_HASH = keccak256("abc");
    uint immutable decimals = 18;
    uint immutable maxBalance;
    address immutable owner = msg.sender;

    constructor(uint decimals_, address ref) {
        if (decimals_ != 0)
            // Immutables are only immutable when deployed.
            // At construction time they can be assigned to any number of times.
            decimals = decimals_;

        // Assignments to immutables can even access the environment.
        maxBalance = ref.balance;
    }

    function isBalanceTooHigh(address other) public view returns (bool) {
        return other.balance > maxBalance;
    }
}

// https://docs.soliditylang.org/en/latest/contracts.html#immutable
