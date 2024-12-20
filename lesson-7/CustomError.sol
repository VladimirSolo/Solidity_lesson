// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
// can use from file
// import { NotPermitted } from "./ExampleError.sol"

/**
 * @title Function with custom error
 * @notice using custom error only with revert - optimization gaz
 */

contract CustomError {
    address public owner;
    // custom error
    error NotPermitted();

    constructor() {
        owner = msg.sender;
    }

    function restrictedFunction() public view {
        if (msg.sender != owner) {
            revert NotPermitted();
        }
    }
}