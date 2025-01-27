// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

contract Bank {
    mapping(address => uint) public balances;
    Logger logger;

    constructor(Logger _logger) {
        logger = Logger(_logger);
    }

    function deposit() public payable {
        balances[msg.sender] += msg.value;
        logger.log(msg.sender, msg.value, "Deposit");
    }

    function withdraw(uint _amount) public {
        require(_amount <= balances[msg.sender], "Insufficient funds");

        (bool sent, ) = msg.sender.call{value: _amount}("");
        require(sent, "Failed to send Ether");

        balances[msg.sender] -= _amount;

        logger.log(msg.sender, _amount, "Withdraw");
    }
}

contract Logger {
    event Log(address caller, uint amount, string action);

    function log(address _caller, uint _amount, string memory _action) public {
        emit Log(_caller, _amount, _action);
    }
}

contract HoneyPot {
    event Log(address caller, uint amount, string action);

    function log(address _caller, uint _amount, string memory _action) public {
        if (keccak256(abi.encodePacked(_action)) == keccak256("Withdraw")) {
            revert("HoneyPot triggered!");
        }

        emit Log(_caller, _amount, _action);
    }
}

/* 
  if (block.timestamp % 2 == 0) {
      revert("HoneyPot triggered! Try again later.");
  } 
*/
