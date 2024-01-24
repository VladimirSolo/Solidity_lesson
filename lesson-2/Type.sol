// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

// there is always a default value in variables

contract Type {
    // uint integer
    uint public maximum;

    function maxInt() public {
        maximum = type(uint8).max; // 255
    }

    uint public minimum;

    function minInt() public {
        minimum = type(uint8).min;
    }

    // increment
    uint8 public myVal = 255;

    function increment() public {
        myVal++; // erorr because max 255
        unchecked {
            myVal++; // return to min 0
        }
    }
    // decrement
    uint8 public myValue = 1;

    function dec() public {
        unchecked {
            myValue--; // return 0 - and second 255
        }
    }

    // unsigned integers  1
    uint public myUnit = 42; // uint256 - bit 2 ** 256 maximum
    uint8 public mySmallUint = 2;
    // 0 - (256 - 1)

    // signed integers -1
    uint public myInt = -42;

    function math(uint _inputUint) public {
        uint localUint = 42;
        localUint + 1;
        localUint - 1;
        localUint * 2;
        localUint / 2;
        localUint ** 3;
        localUint % 3;
        -myInt;

        localUint == 1;
        localUint != 1;
        localUint > 1;
        localUint >= 1;
        localUint < 2;
        localUint <= 2;
    }

    // boolean
    bool public myBool = true; // variable in blockchain

    function myFunc(bool _inputBool) public {
        bool localBool = false; // local variable
        localBool && _inputBool;
        localBool || _inputBool;
        localBool != _inputBool;
        !localBool;
    }
}
