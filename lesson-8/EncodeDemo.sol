// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title Function with encode
 * @notice abi.encode abi.encodePacked
 * @dev https://docs.soliditylang.org/en/develop/abi-spec.html
  Through abi.encodePacked(), Solidity supports a non-standard packed mode where:
  - types shorter than 32 bytes are concatenated directly, without padding or sign extension
  - dynamic types are encoded in-place and without the length.
  - array elements are padded, but still encoded in-place

  Furthermore, structs as well as nested arrays are not supported.
  If you use keccak256(abi.encodePacked(a, b)) and both a and b are dynamic types,
  it is easy to craft collisions in the hash value by moving parts of a into b and vice-versa.
  More specifically, abi.encodePacked("a", "bc") == abi.encodePacked("ab", "c").
  If you use abi.encodePacked for signatures, authentication or data integrity,
  make sure to always use the same types and check that at most one of them is dynamic.
  Unless there is a compelling reason, abi.encode should be preferred.
 */


contract EncodeDemo {
  function doHash(string memory str1, string memory str2) public pure returns(bytes32) {
    return keccak256(doEncode(str1, str2)); 
  }
  function doEncode(string memory str1, string memory str2) public pure returns(bytes memory) {
    // bytes memory result =  abi.encode(str1, str2)
    // probability of collision
    // "Jack", "Richers" === "Jac", "cRichers" --> one hash
    bytes memory result = abi.encodePacked(str1, str2);
    return result;
  }
}