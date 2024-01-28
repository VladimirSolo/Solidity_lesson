// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

contract Byte {
    // the longer the string, the more it takes up in bytes
    // bytes32 public myByte = 'My bytes';
    // 1 --> 32
    // 32 * 8 = 256

    // dynamic
    bytes public myBytes; // 0x
    // fixed
    bytes32 public myBytes32; // 0x000000000000000000000000000000000000
    uint public myLength;

    function lengthFind() public {
        myLength = myBytes32.length; // uint:256 - 32
        // myLength = myBytes.length; // uint:256 - 0
    }

    // fixed
    bytes32 public myVar = "test here"; //  0:bytes32: 0x7465737420686572650000000000000000000000000000000000000000000000
    // dynamic
    bytes public myDynVar = "test here"; //0:bytes: 0x746573742068657265
    bytes public myDynVarUnicode = unicode"привет солид"; // bytes: 0xd0bfd180d0b8d0b2d0b5d18220d181d0bed0bbd0b8d0b4

    // 1 --> 32
    // 32 * 8 = 256 max
    // uint256

    function func() public view returns (uint) {
        return myDynVarUnicode.length; // uint256: 23
    }

    function firstByte() public view returns (bytes1) {
        //  there is no way to get any element of the string
        return myDynVar[0]; // bytes1: 0x74 return byte first 't' (charCode)
    }
}

// https://jeancvllr.medium.com/solidity-tutorial-all-about-bytes-9d88fdb22676
