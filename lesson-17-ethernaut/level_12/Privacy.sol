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
