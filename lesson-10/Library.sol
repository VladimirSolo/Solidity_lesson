// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

// import "@openzeppelin/contracts/utils/Strings.sol";

/**
 * @title LibDemo
 * @notice Demonstrates the use of OpenZeppelin's Strings library
 * @dev This contract includes an example of converting a uint to a string
 */
contract LibDemo {
    // Uncomment the following line to use OpenZeppelin's Strings library
    // using Strings for uint;

    /**
     * @notice Converts a uint to its string representation
     * @param num The unsigned integer to convert
     * @return The string representation of the input number
     * @dev This function relies on the `Strings.toString` utility from OpenZeppelin.
     */
    function testConvert(uint num) public pure returns (string memory) {
        // Uncomment the following line to enable conversion
        // return num.toString();
    }
}
