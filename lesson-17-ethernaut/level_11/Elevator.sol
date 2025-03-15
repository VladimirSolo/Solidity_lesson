// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/* 
You can use the view function modifier on an interface in order to prevent state modifications.
 The pure modifier also prevents functions from modifying the state. Make sure you read Solidity's documentation and learn its caveats.

An alternative way to solve this level is to build a view function which returns different results depends
 on input data but don't modify state, e.g. gasleft().
 */

// interface Building {
//     function isLastFloor(uint256) external returns (bool); // NOT VIEW FUNCTION
// }

contract Building {
    Elevator public elevtor;
    uint256 public lastFloor = 42;

    constructor(Elevator _elevator) {
        elevtor = _elevator;
    }

    function isLastFloor(uint256 _floor) external view returns (bool) {
        if (_floor != lastFloor) {
            lastFloor == _floor;
            return false;
        } else {
            return true;
        }
    }

    function move(uint256 _floor) public {
        elevtor.goTo(_floor);
    }
}

contract Elevator {
    bool public top;
    uint256 public floor;

    function goTo(uint256 _floor) public {
        Building building = Building(msg.sender);

        if (!building.isLastFloor(_floor)) {
            floor = _floor;
            top = building.isLastFloor(floor);
        }
    }
}

/* 
The function isLastFloor is called twice, with the returned value changing for the same input as the state is changed.

If the isLastFloor had been restricted to view, then this attack wouldn't be possible (unless it was calling a library,
 which doesn't have runtime checks to make sure it doesn't modify the state when it says it's view)
 */
