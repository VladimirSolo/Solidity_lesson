// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

/**
 * @title Base contract X
 * @dev A simple contract to demonstrate inheritance with parameters.
 */
contract X {
    /// @notice Public variable to store the name.
    string public name;

    /**
     * @dev Constructor to initialize the name.
     * @param _name The name to be initialized.
     */
    constructor(string memory _name) {
        name = _name;
    }
}

/**
 * @title Base contract Y
 * @dev A simple contract to demonstrate inheritance with parameters.
 */
contract Y {
    /// @notice Public variable to store the text.
    string public text;

    /**
     * @dev Constructor to initialize the text.
     * @param _text The text to be initialized.
     */
    constructor(string memory _text) {
        text = _text;
    }
}

/**
 * @title Contract B
 * @dev Demonstrates passing parameters to parent constructors in the inheritance list.
 * 
 * The parameters for base contracts X and Y are directly specified in the inheritance list.
 */
contract B is X("Input to X"), Y("Input to Y") {}

/**
 * @title Contract C
 * @dev Demonstrates passing parameters to parent constructors in the child constructor.
 * 
 * The parameters for base contracts X and Y are passed through the constructor of C.
 */
contract C is X, Y {
    /**
     * @dev Constructor to initialize base contracts with parameters.
     * @param _name The name to be passed to contract X.
     * @param _text The text to be passed to contract Y.
     */
    constructor(string memory _name, string memory _text) X(_name) Y(_text) {}
}

/**
 * @title Contract D
 * @dev Demonstrates the order of constructor execution in multiple inheritance.
 * 
 * Regardless of the order of parent contracts in the constructor, the constructors are always
 * executed in the order of inheritance (X, Y, D in this case).
 */
contract D is X, Y {
    /**
     * @dev Constructor to initialize base contracts with fixed values.
     */
    constructor() X("X was called") Y("Y was called") {}
}
