// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

/**
 * @title Loop studing
 * @notice Solidity supports for, while, and do while loops.
           Don't write loops that are unbounded as this can hit the gas limit, causing your transaction to fail.
           For the reason above, while and do while loops are rarely used.
 */

contract Loop {
    function loop() public pure {
        for (uint i = 0; i < 10; i++) {
            if (i == 3) {
                /// @dev Skip to next iteration with continue
                continue;
            }
            if (i == 5) {
                /// @dev Exit loop with break
                break;
            }
        }

        uint j;
        while (j < 10) {
            j++;
        }
    }
}

/**
 * @title add to list of guests
 * @dev change adress on msg sender
 */

contract Friend {
    struct Friends {
        string name;
        bool invited;
    }

    Friends[] public friendList;
    Friends[] public guestList;

    /**
     * @param _name name of friend
     * @param _invited bool - if have invited
     */
    function addFriend(string memory _name, bool _invited) public {
        friendList.push(Friends({name: _name, invited: _invited}));
    }

    /// @dev add to list of guests using loop
    function addGuest() public {
        for (uint i = 0; i < friendList.length; i++) {
            if (friendList[i].invited == true) {
                guestList.push(friendList[i]);
            }
        }
    }
}

/**
 * @title Converter
 * @notice  
          1 eth
          1000 finney
          1000000000 gwey
          1000000000000000000 wei
 */

contract Converter {
    string[] public units = ["Finney", "Gwei", "Wei"];

    function convertEth(uint _amount, uint _idx) public pure returns (uint) {
        if (_idx == 0) {
            return _amount * 10 ** 3;
        } else if (_idx == 1) {
            return _amount * 10 ** 9;
        } else if (_idx == 2) {
            return _amount * 10 ** 18;
        } else {
            return _amount;
        }
    }

    /*    uint[] public conversionFactors = [10**3, 10**9, 10**18];

    function convertEth(uint _amount, uint _idx) public pure returns (uint) {
        return _amount * conversionFactors[_idx];
    } */
}

/**
 * @title add adress
 * @dev change adress on msg sender
 */

contract Sender {
    address[] public addrList = [
        0x6119806E928EbF578e7ABC4F6ae73BFd8a8462cD,
        0x0F9c56371ab9f277280e0d2Ec68ea5C901a02CDb,
        0xc84772C4d95c4f2E12f829b99eB181ED3106611a,
        0x5A0CC2C6bF2cEB1cB9B57541fDAa1Fb794A1a1be,
        0xc74cB1F17de290348beA287Ae29F67e7AECd75dD
    ];

    function changeAddr() public {
        for (uint i = 1; i < addrList.length; i++) {
            if (i % 2 == 0) {
                addrList[i] = msg.sender;
            }
        }
    }
}

/**
 * @dev add number in array
 */

contract Diapason {
    uint[] public array;

    function addNum() public {
        for (uint i = 48; i <= 203; i++) {
            if (i % 5 == 0) {
                array.push(i);
            }
        }
    }
}

/**
 * @title find factorial
 */

contract Factorial {
    uint[] public array;

    function findFactorial(uint number) public pure returns (uint result) {
        result = 1;
        for (uint i = 1; i <= number; i++) {
            result = i * result;
        }
    }
}
