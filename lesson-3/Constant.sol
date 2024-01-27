// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract Constant {
  // not change and less gas!!!
  uint public constant MY_CONSTANT = 42;

  // local constant in function does not exist
  function tryUseConstant() public {
    // Expected ';' but got 'constant'solidity(2314)
    // uint constant MY_CONSTANT_IN_FUNC = 717; // ParserError
  }
}