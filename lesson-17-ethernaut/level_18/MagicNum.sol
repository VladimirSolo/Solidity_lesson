// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MagicNum {
    address public solver;

    constructor() {}

    function setSolver(address _solver) public {
        solver = _solver;
    }

    /*
    ____________/\\\_______/\\\\\\\\\_____        
     __________/\\\\\_____/\\\///////\\\___       
      ________/\\\/\\\____\///______\//\\\__      
       ______/\\\/\/\\\______________/\\\/___     
        ____/\\\/__\/\\\___________/\\\//_____    
         __/\\\\\\\\\\\\\\\\_____/\\\//________   
          _\///////////\\\//____/\\\/___________  
           ___________\/\\\_____/\\\\\\\\\\\\\\\_ 
            ___________\///_____\///////////////__
    */
}

contract Some {
    function magicNumber() public view returns (uint256) {
        return 42;
    }
}

contract Creator {
    address public newAddress;
    bytes public result;

    function create() public {
        address addr;
        bytes memory bytecode = hex"600a600c600039600a6000f3602a600052602000f3";

        assembly {
            addr := create(0, add(bytecode, 0x20), mload(bytecode))
        }

        newAddress = addr;
    }

    function getSize() public view returns (uint256) {
        return newAddress.code.length;
    }

    function caller() public {
        (bool ok, bytes memory data) = newAddress.call("0x1234");
        require(ok);
        result = data;
    }
}

/* 
PUSH 2a value 60
PUSH 00 offset 600
MSTORE (offset, value) 52
PUSH 20
PUSH 00
RETURN (offset, size) f3
// 16*2 = 32 / 20 

// runtime bytecode
// 602a60505260206050f3

PUSH 0a
PUSH __
PUSH 00
CODECOPY (destoffset, offset, size) 39
PUSH 0a
PUSH 00
RETURN (offset, size) f3

600a600c600039600a6000f3602a60505260206050f3
 */
