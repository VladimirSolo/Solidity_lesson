// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Calls {
    uint256 public x;
    address public immutable target;

    constructor(address _target) {
        target = _target;
    }

    function call() public {
        (bool ok, ) = target.call(abi.encodeWithSignature("set(uint256)", 1));
        require(ok);
    }

    function delegateCall() public {
        (bool ok, ) = target.delegatecall(
            abi.encodeWithSignature("set(uint256)", 2)
        );
        require(ok);
    }
}

contract Target {
    uint256 public x;

    function set(uint256 val) external {
        x = val;
    }
}
