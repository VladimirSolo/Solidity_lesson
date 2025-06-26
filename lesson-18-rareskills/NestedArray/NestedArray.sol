// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.13;

contract NestedArray {
    uint256[][] public arr;

    function setArr(uint256[][] memory newArr) public {
        arr = newArr;
    }

    /**
     * This function is expected to get the sum of all members of each nested array and finally return the sum of all the nested sums
     * Example: [[1,2], [3,4]] this should return 1 + 2 + 3 + 4 = 10
     */
    function getNestedSum() public view returns (uint256) {
        uint256 totalSum = 0;
        for (uint256 i = 0; i < arr.length; i++) {
            uint256[] memory innerArray = arr[i];
            for (uint256 j = 0; j < innerArray.length; j++) {
                totalSum += innerArray[j];
            }
        }
        return totalSum;
    }
}
