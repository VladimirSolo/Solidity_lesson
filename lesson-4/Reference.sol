// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

contract Reference {
    function typesNotChange() public {
        uint a = 42; // will change
        uint b = a; // value will not change if you change the values of
        a++;
    }

    function referenceTypes() public view returns (uint[] memory) {
        uint[] memory a = new uint[](3);
        a[0] = 1;

        uint[] memory b = new uint[](3);
        b = a;
        b[1] = 42;

        return a; // [1,42,0]
    }

    uint[] public stateArr;

    // if we have array in memory myArr  and array in storage - stateArr - will independent copy array 
    function copyArrFunc(uint[] memory myArr) public returns (uint[] memory) {
        stateArr = myArr;
        myArr[0] = 42;
    }

    // if local varibales in func
    function moreReference() public {
        stateArr = [1, 2, 3];
        uint[] storage localStorageArr = stateArr; // a reference to the same place

        localStorageArr[0] = 42;

        internalFunc(localStorageArr);
    }

    // also will modify stateArr
    function internalFunc(uint[] storage arr) internal { // if add memory it will independent copy
        arr[1] = 717;
    }

    uint[] public stateArr2 = [1,2,3];

    function equalArr() public {
      stateArr = stateArr2; // it independent copy 
      stateArr2[0] = 42;
    }
}

// docs=====>

/* 
--> Assignments between storage and memory (or from calldata) always create an independent copy.

--> Assignments from memory to memory only create references. 
    This means that changes to one memory variable are also visible in all other memory variables that refer to the same data.

--> Assignments from storage to a local storage variable also only assign a reference.

--> All other assignments to storage always copy. 
    Examples for this case are assignments to state variables or to members of local variables of storage struct type,
    even if the local variable itself is just a reference.
*/

contract C {
    // The data location of x is storage.
    // This is the only place where the
    // data location can be omitted.
    uint[] x;

    // The data location of memoryArray is memory.
    function f(uint[] memory memoryArray) public {
        x = memoryArray; // works, copies the whole array to storage
        uint[] storage y = x; // works, assigns a pointer, data location of y is storage
        y[7]; // fine, returns the 8th element
        y.pop(); // fine, modifies x through y
        delete x; // fine, clears the array, also modifies y
        // The following does not work; it would need to create a new temporary /
        // unnamed array in storage, but storage is "statically" allocated:
        // y = memoryArray;
        // Similarly, "delete y" is not valid, as assignments to local variables
        // referencing storage objects can only be made from existing storage objects.
        // It would "reset" the pointer, but there is no sensible location it could point to.
        // For more details see the documentation of the "delete" operator.
        // delete y;
        g(x); // calls g, handing over a reference to x
        h(x); // calls h and creates an independent, temporary copy in memory
    }

    function g(uint[] storage) internal pure {}
    function h(uint[] memory) public pure {}
}