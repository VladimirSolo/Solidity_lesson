// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

/**
 * @title Inheritance Example
 * @dev Demonstrates inheritance in Solidity, including function overriding and the order of execution.
 *
 * ## Graph of Inheritance
 * 
 * ```
 *       A
 *      / \
 *     B   C
 *    / \ /
 *   F  D,E
 * ```
 *
 * ## Notes on Inheritance
 * - Functions in parent contracts can be overridden using the `virtual` and `override` keywords.
 * - Solidity resolves function calls using a depth-first, right-to-left search of parent contracts.
 * - Contracts must declare inheritance from the "most base-like" contract to the "most derived" contract.
 */

// Base contract
contract A {
    /**
     * @dev Returns the name of the contract as a string.
     * @return A string value "A".
     */
    function foo() public pure virtual returns (string memory) {
        return "A";
    }
}

// Contract B inherits from A
contract B is A {
    /**
     * @dev Overrides A.foo().
     * @return A string value "B".
     */
    function foo() public pure virtual override returns (string memory) {
        return "B";
    }
}

// Contract C inherits from A
contract C is A {
    /**
     * @dev Overrides A.foo().
     * @return A string value "C".
     */
    function foo() public pure virtual override returns (string memory) {
        return "C";
    }
}

// Contract D inherits from B and C
contract D is B, C {
    /**
     * @dev Overrides foo() from both B and C.
     *
     * @notice D.foo() returns "C" because Solidity resolves function calls
     * using depth-first, right-to-left search, making C the final parent to execute.
     *
     * @return A string value "C".
     */
    function foo() public pure override(B, C) returns (string memory) {
        return super.foo();
    }
}

// Contract E inherits from C and B
contract E is C, B {
    /**
     * @dev Overrides foo() from both C and B.
     *
     * @notice E.foo() returns "B" because Solidity resolves function calls
     * using depth-first, right-to-left search, making B the final parent to execute.
     *
     * @return A string value "B".
     */
    function foo() public pure override(C, B) returns (string memory) {
        return super.foo();
    }
}

// Contract F inherits from A and B
contract F is A, B {
    /**
     * @dev Overrides foo() from both A and B.
     *
     * @notice Inheritance order must list the most base-like contract first (A),
     * followed by derived contracts (B). Swapping A and B in the inheritance list
     * will result in a compilation error.
     *
     * @return A string value "B" because B.foo() overrides A.foo().
     */
    function foo() public pure override(A, B) returns (string memory) {
        return super.foo();
    }
}
