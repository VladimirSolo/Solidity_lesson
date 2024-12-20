// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.2 <0.9.0;

/**
 * @title Event
 * @notice  event emit
 */

// You can add the attribute indexed to up to three parameters which adds
// them to a special data structure known as “topics” instead of the data part of the log.
// A topic can only hold a single word (32 bytes) so if you use a reference type for an indexed argument,
// the Keccak-256 hash of the value is stored as a topic instead.
// All parameters without the indexed attribute are ABI-encoded into the data part of the log.

contract EventDemo { 
  mapping(address => uint) public tokenBalance; 
  event TokensSent(address _from, address _to, uint _amount); // <-- 
         
  constructor() { 
    tokenBalance[msg.sender] = 100; 
  } 
         
  function sendToken(address _to, uint _amount) public { 
    tokenBalance[msg.sender] -= _amount; 
    tokenBalance[_to] += _amount; 

    // Events are emitted using `emit`, followed by
    // the name of the event and the arguments
    // (if any) in parentheses. Any such invocation
    // (even deeply nested) can be detected from
    // the JavaScript API by filtering for `TokensSent`.
    emit TokensSent(msg.sender, _to, _amount); // <--
  } 
}

/* 
logs
[ 
  { 
    "from": "0xB7f8BC63BbcaD18155201308C8f3540b07f8df43", 
    "topic": "0xe607861baff3d292b19188affe88c1a72bdcb69d3015f18bb2cd0bf5349cc4r5", 
    "event": "TokensSent", 
    "args": { 
      "0": "0xf39Fd6e51aad88F6F4ce6aB8827279cffFb97777", 
      "1": "0xf39Fd6e51aad88F6F4ce6aB8827279cffFb97777", 
      "2": "1", 
      "_from": "0xf39Fd6e51aad88F6F4ce6aB8827279cffFb97777", 
      "_to": "0xf39Fd6e51aad88F6F4ce6aB8827279cffFb97777", 
      "_amount": "1" 
    } 
  }
]
 */