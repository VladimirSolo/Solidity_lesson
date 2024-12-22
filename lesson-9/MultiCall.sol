// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

/**
 * @title Contact
 * @dev A contract to manage a person's name and surname with encoding features.
 */
contract Contact {
  string name;
  string sureName;

  function setName(string memory _name) public  {
      name = _name;
  }

  function setSurName(string memory _sureName) public  {
      sureName = _sureName;
  }

  function getName() external view returns(string memory) {
  return name;
  }

  function getSurName() external view returns(string memory) {
  return sureName;
  }

  function encodeGetName() external pure returns(bytes memory) {
    return abi.encodeWithSelector(this.getName.selector);
  }

  function encodeGetSureName() external pure returns(bytes memory) {
    return abi.encodeWithSelector(this.getSurName.selector);
  }
} 

/**
 * @title Caller
 * @dev A contract to execute multiple calls and encode function signatures.
 */
contract Caller {
    /**
     * @notice Executes multiple static calls.
     * @param targets The addresses of the contracts to be called.
     * @param data The encoded function data for each call.
     * @return The results of each call as an array of strings.
     */
   function multiCall(address[] calldata targets, bytes[] calldata data)
        external
        view
        returns (string[] memory)
    {
        require(targets.length == data.length, "target length != data length");

        string[] memory results = new string[](data.length);

        for (uint256 i; i < targets.length; i++) {
            (bool success, bytes memory result) = targets[i].staticcall(data[i]);
            require(success, "call failed");
            results[i] = abi.decode(result, (string));
        }

        return results;
    }

  /**
     * @notice Executes multiple calls (non-static).
     * @param targets The addresses of the contracts to be called.
     * @param data The encoded function data for each call.
     */
  function multiCallTwo(address[] calldata targets, bytes[] calldata data) public {
    require(targets.length == data.length, "target length != data length");
    for (uint i; i < targets.length; i++) {
      (bool success,) = targets[i].call(data[i]);
      require(success, "call failed");
    }
  }

 /**
  * @notice Encodes a function signature with an argument.
  * @param _func The name of the function to be encoded (e.g., "setName(string)").
  * @param _arg The argument to pass to the function.
  * @return The encoded function call data.
  */
  function encode(string calldata _func, string calldata _arg) public pure returns(bytes memory) {
    return abi.encodeWithSignature(_func, _arg);
  }
}