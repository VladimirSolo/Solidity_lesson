// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Size {
    function getSize(address _address) public view returns (uint256) {
        uint256 size;
        assembly {
            size := extcodesize(_address)
        }

        return size;
    }

    function getSize2(address _address) public view returns (uint256) {
        return _address.code.length;
    }
}
