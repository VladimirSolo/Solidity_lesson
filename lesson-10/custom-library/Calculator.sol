// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

/**
 * @title Math Library
 * @notice Provides basic arithmetic operations as a reusable library
 */
library MathLib {
    /**
     * @notice Adds two numbers
     * @param a The first number
     * @param b The second number
     * @return The sum of `a` and `b`
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        return a + b;
    }

    /**
     * @notice Subtracts the second number from the first
     * @param a The first number
     * @param b The second number
     * @return The difference of `a` and `b`
     * @dev Reverts if `b` is greater than `a`
     */
    function subtract(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a, "MathLib: subtraction overflow");
        return a - b;
    }

    /**
     * @notice Multiplies two numbers
     * @param a The first number
     * @param b The second number
     * @return The product of `a` and `b`
     */
    function multiply(uint256 a, uint256 b) internal pure returns (uint256) {
        return a * b;
    }

    /**
     * @notice Divides the first number by the second
     * @param a The dividend
     * @param b The divisor
     * @return The quotient of `a` divided by `b`
     * @dev Reverts if `b` is zero
     */
    function divide(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b > 0, "MathLib: division by zero");
        return a / b;
    }
}

/**
 * @title Calculator Contract
 * @notice Provides basic arithmetic operations using the MathLib library
 */
contract Calculator {
    using MathLib for uint256;

    function calculateSum(uint256 a, uint256 b) external pure returns (uint256) {
        return a.add(b);
    }


    function calculateDifference(uint256 a, uint256 b) external pure returns (uint256) {
        return a.subtract(b);
    }

    function calculateProduct(uint256 a, uint256 b) external pure returns (uint256) {
        return a.multiply(b);
    }

    function calculateQuotient(uint256 a, uint256 b) external pure returns (uint256) {
        return a.divide(b);
    }
}
