// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

/**
 * @title Inheritance Demonstration
 * @dev This example demonstrates Solidity's multiple inheritance and function overriding.
 *      The inheritance tree is as follows:
 * 
 *                 ParentContract
 *                   /       \
 *                First     Second
 *                   \       /
 *                      Last
 * 
 * Contracts `First` and `Second` inherit from `ParentContract`, and `Last` inherits from both `First` and `Second`.
 */

// Parent contract defining base functionality
contract ParentConract {
    // Event to trace function calls
    event Log(string message);

    /**
     * @dev Virtual function to represent a "buy" action.
     *      This function can be overridden by derived contracts.
     */
    function buy() public virtual {
        emit Log("ParentConract.buy called");
    }

    /**
     * @dev Virtual function to represent a "sold" action.
     *      This function can be overridden by derived contracts.
     */
    function sold() public virtual {
        emit Log("ParentConract.sold called");
    }
}

// First child contract inheriting from ParentContract
contract First is ParentConract {
    /**
     * @dev Overrides the `buy` function. Calls the parent contract's `buy` method explicitly.
     */
    function buy() public virtual override {
        emit Log("First.buy called");
        ParentConract.buy(); // Explicit call to the ParentContract's buy function
    }

    /**
     * @dev Overrides the `sold` function. Uses `super` to call the parent implementation.
     */
    function sold() public virtual override {
        emit Log("First.sold called");
        super.sold(); // Calls ParentContract.sold due to single inheritance path here
    }
}

// Second child contract inheriting from ParentContract
contract Second is ParentConract {
    /**
     * @dev Overrides the `buy` function. Calls the parent contract's `buy` method explicitly.
     */
    function buy() public virtual override {
        emit Log("Second.buy called");
        ParentConract.buy(); // Explicit call to the ParentContract's buy function
    }

    /**
     * @dev Overrides the `sold` function. Uses `super` to call the parent implementation.
     */
    function sold() public virtual override {
        emit Log("Second.sold called");
        super.sold(); // Calls ParentContract.sold due to single inheritance path here
    }
}

// Last contract inheriting from both First and Second
contract Last is First, Second {
    /**
     * @dev Resolves ambiguity in the inheritance chain for the `buy` function.
     *      Uses `super` to call the most derived implementations from both parents.
     */
    function buy() public override(First, Second) {
        super.buy(); // Calls First.buy or Second.buy based on Solidity's linearization
    }

    /**
     * @dev Resolves ambiguity in the inheritance chain for the `sold` function.
     *      Uses `super` to call the most derived implementations from both parents.
     */
    function sold() public override(First, Second) {
        super.sold(); // Calls First.sold or Second.sold based on Solidity's linearization
    }
}
