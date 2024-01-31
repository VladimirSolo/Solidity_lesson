// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

// Arrays can have a compile-time fixed size, or they can have a dynamic size.
// The type of an array of fixed size k and element type T is written as T[k], and an array of dynamic size as T[].

contract Array {
    uint[2][] itemsDyn;
    uint[][2] itemsFixed;

    function demo() public {
        itemsDyn.push([1, 2]);
        itemsDyn.push([3, 4]);

        itemsDyn[0][1]; //  2

        itemsFixed[0] = [10, 11, 12];
        itemsFixed[1] = [13, 14];

        itemsFixed[0][2]; //  12
    }

    // Pop()
    uint[] items = [1, 2, 3];

    function p() public {
        items.pop();
    }

    function itemsLength() public view returns (uint) {
        return items.length;
    }

    // Array in memory - after complete func will be lost
    function sampleMemoryArray() public pure {
        uint[] memory items = new uint[](7);

        items[0] = 1;
        items[1] = 2;
    }

    // return array - need set memory
    function getItems() public view returns (uint[] memory) {
        return items;
    }

    // just easy example
    string[] public myList = ["John", "Mary", "Sasha", "Rose", "Elvis"];

    function getValue(uint _index) public view returns (string memory) {
        return myList[_index];
    }
}
