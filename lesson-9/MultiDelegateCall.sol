// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

/**
 * @title MultiDelegateCall
 * @dev A contract to execute multiple delegate calls and store results.
 */
contract MultiDelegateCall {
  uint[] public results;

  function multiCall(bytes[] calldata data) external {
    for(uint i; i < data.length; i++) {
      (bool success, bytes memory result) = address(this).delegatecall(data[i]);
      require(success, "failed!");
      results.push(abi.decode(result, (uint)));
    }
  }
} 

/**
 * @title Calculator
 * @dev A contract that extends MultiDelegateCall to provide mathematical operations and balance tracking.
 */
contract Calculator is MultiDelegateCall {
  event Log(address caller, string calcName, uint result);

  function addition(uint x, uint y) external returns(uint) {
    uint result = x + y;
    emit Log(msg.sender, "addition", result);
    return result;
  }

  function multiplication(uint x, uint y) external returns(uint) {
    uint result = x * y;
    emit Log(msg.sender, "multiplication", result);
    return result;
  }

  function encodeAddition(uint x, uint y) external pure returns(bytes memory) {
    return abi.encodeWithSelector(Calculator.addition.selector, x, y);
  }

  function encodeMultiplication(uint x, uint y) external pure returns(bytes memory) {
    return abi.encodeWithSelector(Calculator.multiplication.selector, x, y);
  }

  mapping(address => uint256) public balanceOf;

  /**
  * @notice Allows a user to mint tokens by sending Ether. 
  * @dev WARNING: This function is unsafe when used with multi-delegatecall.
  *  A user can mint multiple times for the price of one msg.value.
  */
  function mint() external payable {
    balanceOf[msg.sender] += msg.value;
  }

  function getMintData() external pure returns (bytes memory) {
    return abi.encodeWithSelector(Calculator.mint.selector);
  }
}