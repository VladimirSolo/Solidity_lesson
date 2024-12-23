// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

/**
 * @title AbstractContract
 * @dev An abstract contract defining two functions without implementations.
 * Abstract contracts cannot override an implemented virtual function with an unimplemented one.
 * Abstract contracts decouple the definition of a contract from its implementation providing better
 * extensibility and self-documentation and facilitating patterns like the Template method and removing code duplication. 
 */

abstract contract AbstractContract {
    // Declaring functions without implementation
    function getName(string memory _name) public view virtual returns (string memory);
    function setAge(uint _age) public virtual;
}

/**
 * @title DerivedContract
 * @dev A contract that implements AbstractContract and provides concrete implementations for its functions.
 */
contract DerivedContract is AbstractContract {
    uint public age;

    // Implementing abstract functions
    function getName(string memory _name) public pure override returns (string memory) {
        return _name;
    }
    function setAge(uint _age) public override {
        age = _age;
    }
}