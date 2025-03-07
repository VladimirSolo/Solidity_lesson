// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Demo {
    string public phrase;

    function setPhrase(string memory _phrase) public {
        phrase = _phrase;
    }
}

contract Caller {
    string public phrase;
    address public demo;

    constructor(address _demo) {
        demo = _demo;
    }

    //state change in Demo
    function call() public {
        (bool result, ) = demo.call(
            abi.encodeWithSignature("setPhrase(string)", "Hello, call")
        );
        require(result);
    }

    //state change in Caller
    function delegateCall() public {
        (bool result, ) = demo.delegatecall(
            abi.encodeWithSignature("setPhrase(string)", "Hello, delegatecall")
        );
        require(result);
    }
}
