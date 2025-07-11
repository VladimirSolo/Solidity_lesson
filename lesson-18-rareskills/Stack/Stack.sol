// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.13;

contract Stack {
    /*
        This exercise assumes you understand what a stack is and know how to manipulate it.
        1. Implement a stack using an array `stack` with the following functions:
            a. `push` function appends a new value to the end of the array.
            b. `peek` function returns the last element of the array without removing it, 
               but first checks if the stack is not empty.
            c. `pop` function returns the last element of the array and removes it from 
               the stack, but also checks if the stack is not empty.
            d. `size` function returns the length of the array, which corresponds to
               the number of elements in the stack.
            e. `getStack` function returns the stack.
    */

    uint256[] stack;

    constructor(uint256[] memory _stack) {
        stack = _stack;
    }

    // your code here
    function push(uint256 value) public {
        stack.push(value);
    }

    function peek() public view returns (uint256) {
        require(stack.length > 0, "Stack is empty");
        return stack[stack.length - 1];
    }

    function pop() public returns (uint256) {
        require(stack.length > 0, "Stack is empty");
        uint256 value = stack[stack.length - 1];
        stack.pop();
        return value;
    }

    function size() public view returns (uint256) {
        return stack.length;
    }

    function getStack() public view returns (uint256[] memory) {
        return stack;
    }
}
