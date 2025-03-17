// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Privacy {
    bool public locked = true; // slot 0
    uint256 public ID = block.timestamp; // slot 1
    uint8 private flattening = 10; // slot 2 (packed)
    uint8 private denomination = 255; // slot 2 (packed)
    uint16 private awkwardness = uint16(block.timestamp); // slot 2 (packed)
    bytes32[3] private data; // slot 3, 4, and 5

    constructor(bytes32[3] memory _data) {
        data = _data;
    }

    function unlock(bytes16 _key) public {
        require(_key == bytes16(data[2]));
        locked = false;
    }

    /*
    A bunch of super advanced solidity algorithms...

      ,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`
      .,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,
      *.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^         ,---/V\
      `*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.    ~|__(o.o)
      ^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'  UU  UU
    */
}

/* 
Nothing in the Ethereum blockchain is private. The keyword private is merely an artificial construct of the Solidity language.
 Tools such as Foundry or Ethers can be used to read anything from storage. It can be tricky to read what you want though,
 since several optimization rules and techniques are used to compact the storage as much as possible.
 */

/* 
bool public locked: This occupies slot 0. Each state variable takes up a single slot 
unless it is part of a struct or an array. bool takes 1 byte, but an entire 32-byte slot is allocated for it.

uint256 public ID: This occupies slot 1. uint256 requires 32 bytes (1 full slot).

uint8 private flattening: This will start in slot 2. uint8 only takes 1 byte.

uint8 private denomination: Since uint8 also takes only 1 byte, it is packed into slot 2 along with flattening.

uint16 private awkwardness: uint16 takes 2 bytes. Solidity packs this into slot 2 along with the other uint8 values because they collectively fit within 32 bytes.

Slot 2 looks like this (in bytes): flattening (1) + denomination (1) + awkwardness (2) + 28 bytes padding = 32 bytes

bytes32[3] private data: Arrays and structs are always stored in separate slots.
 The array data has 3 elements of type bytes32, and each bytes32 takes 32 bytes (1 full slot).

data[0] is stored in slot 3.

data[1] is stored in slot 4.

data[2] is stored in slot 5.

Therefore, data[2] is in slot 5 because it is the third element of the bytes32[3] array,
and each element of this array occupies its own 32-byte storage slot. 
The preceding variables occupy slots 0 through 2, with the array data starting at slot 3 and extending 
to slots 4 and 5 for its elements.

Once found, cast it as bytes16 to truncate the packed zeros.
 */
