// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// https://docs.soliditylang.org/en/latest/080-breaking-changes.html#solidity-v0-8-0-breaking-changes

// https://docs.soliditylang.org/en/v0.6.0/security-considerations.html#two-s-complement-underflows-overflows

/* Arithmetic operations revert on underflow and overflow. => 
 You can use unchecked { ... } to use the previous wrapping behavior.

Checks for overflow are very common, so we made them the default to increase readability of code,
 even if it comes at a slight increase of gas costs. */

/*  uint8 a = 255;
a = a + 1;  // a == 0 (переполнение) Overflow

uint8 b = 0;
b = b - 1;  // b == 255 (потеря данных) Underflow

===>>>
require(value <= 200, "Слишком большое значение!"); 

using SafeMath for uint256;
uint256 c = a.add(b);  // Это вызовет revert при переполнении

require((balanceOf[_to] + _value) >= balanceOf[_to], "Переполнение баланса!");

 */

contract Demo {
    function add(uint256 a, uint256 b) public pure returns (uint256) {
        return a + b;
    }

    function sbu(uint256 a, uint256 b) public pure returns (uint256) {
        // ERROR!!!
        return a - b;
    }

    function sbu2(uint256 a, uint256 b) public pure returns (uint256) {
        // WORKING!!!
        unchecked {
            return a - b;
        }
    }
}
