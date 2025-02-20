// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract Ownable {
    address[] public owners;
    mapping(address => bool) public isOwner;

    constructor(address[] memory _owners) {
        require(_owners.length > 0, "Not owners!");

        for (uint i; i < _owners.length; i++) {
            address owner = _owners[i];

            require(owner != address(0), "Zero address!");
            require(!isOwner[owner], "Not unique!");

            owners.push(owner);
            isOwner[owner] = true;
        }
    }

    modifier onlyOwners() {
        require(isOwner[msg.sender], "Not an owner!");
        _;
    }

    //TODO: can add new owners - add onlyOwners
}
