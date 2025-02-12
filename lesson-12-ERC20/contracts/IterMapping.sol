// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

contract IterMapping {
    mapping(string => uint256) public ages;
    string[] public keys;
    mapping(string => bool) public isInserted;

    function set(string memory _name, uint256 _age) public {
        ages[_name] = _age;

        if (!isInserted[_name]) {
            isInserted[_name] = true;
            keys.push(_name);
        }
    }

    function length() public view returns (uint256) {
        return keys.length;
    }

    function get(uint256 _index) public view returns (uint256) {
        string memory key = keys[_index];

        return ages[key];
    }

    function getValues() public view returns (uint256[] memory) {
        uint[] memory values = new uint[](keys.length);

        for (uint i = 0; i < keys.length; i++) {
            values[i] = ages[keys[i]];
        }

        return values;
    }
}
