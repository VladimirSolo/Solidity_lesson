// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract Contact {
    string public name = "Joda";
    uint public age = 99;
    mapping(address => uint) public payments;

    function setData(string calldata _newName, uint _newAge) public  {
        name = _newName;
        age = _newAge;
    }

    function getName() public view returns(string memory) {
        return name;
    }

    function pay(address _payer) external  payable {
        payments[_payer] = msg.value;
    }
    

    fallback() external payable { 
        payments[msg.sender] = msg.value;
    }

} 