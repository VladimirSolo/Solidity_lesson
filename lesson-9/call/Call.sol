// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

/**
 * @title Call
 * @dev Call 
 * call is a low level function to interact with other smart contracts.
 * This is the recommended method to use when you're just sending Ether via calling the fallback function.
 * However it is not the recommend way to call existing functions.
 * Few reasons why low-level call is not recommended
 * Reverts are not bubbled up
 * Type checks are bypassed
 * Function existence checks are omitted
 */

contract Caller {
  bytes public  returnData;
  string public  returnName;

  function callGetName(address _contact) external {
      (bool result, bytes memory data) = _contact.call(
          abi.encodeWithSignature(
              "getName()"
          )
      );

      require(result, "failed");

      returnData = data;
      returnName = string(abi.encodePacked(data));
  }

  function callSetData(address _contact, string calldata _newName, uint _newAge) external {
      (bool result,) = _contact.call(
          abi.encodeWithSignature(
              "setData(string,uint256)",
              _newName,
              _newAge
          )
      );

      require(result, "failed");
  }

  function callPay(address _contact) external  payable {
          (bool result,) = _contact.call{value: msg.value}( // gas: 5000
          abi.encodeWithSignature(
              "pay(address)",
              msg.sender
          )
      );

      require(result, "failed");
  }
  //working if in Contact.sol - fallback()
  function callNonExistent(address _contact) external  payable {
          (bool result,) = _contact.call{value: msg.value}(
          abi.encodeWithSignature(
              "fake(address)",
              msg.sender
          )
      );

      require(result, "failed");
  }
} 