// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title ArrayLib
 * @notice Provides utility function remove for working with arrays of uint256
 * @dev Libraries are similar to contracts, but you can't declare any state variable and you can't send ether.
 * A library is embedded into the contract if all library functions are internal.
 * Otherwise the library must be deployed and then linked before the contract is deployed.
 */
library ArrayLib {
  function remove(uint256[] storage arr, uint256 index) public {
    // Move the last element into the place to delete
    require(arr.length > 0, "Can't remove from empty array");
    arr[index] = arr[arr.length - 1];
    arr.pop();
  }
}

/**
 * @title Array
 * @notice Example contract demonstrating the use of ArrayLib
 */
contract Array {
  using ArrayLib for uint256[];

  uint256[] public data;

  /**
   * @notice Removes an element from the array by index
   * @param index The index of the element to remove
   */
  function removeElement(uint256 index) external {
    data.remove(index);
  }

  function testArrayRemove() public {
    for (uint256 i = 0; i < 3; i++) {
        data.push(i);
    }

    data.remove(1);

    assert(data.length == 2);
    assert(data[0] == 0);
    assert(data[1] == 2);
  }
}
