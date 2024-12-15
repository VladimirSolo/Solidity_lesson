// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.2 <0.9.0;

/**
 * @title Function
 * @notice  require revert assert
 */

contract RequireDemo {
  address owner;

  constructor() {
    owner = msg.sender;
  }

  function withdraw(address payable _to) public {
    require(msg.sender == owner, "You are not an owner!");

/*     
    if(msg.sender != owner) {
    revert("You are not an owner!");
    } 
*/

// does not refund gas when canceling a transaction
// assert("You are not an owner!"); Panic - erorr

    _to.transfer(address(this).balance);
  }
}

/**
 * @title Function increase 5 and checked if more than uint8
 * @notice  Example use require and unchecked
 */

contract Incrementer {
    uint8 public value;

    constructor() {
        value = 0;
    }

    function increment() public {
        require(value + 5 <= type(uint8).max, "Overflow: value exceeds uint8 max");
        value += 5;
    }
}

contract IncrementerUnchecked {
    uint8 public value;

    constructor() {
        value = 0;
    }

    function increment() public {
        unchecked {
            value += 5; // economy gaz but Possible overflow
        }
    }
}