// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

contract Type {
    // enum
    enum Status { Paid, Delivered, Received }
    Status public currentStatus;

    function paid() public {
        currentStatus = Status.Paid;
    }

    function delivered() public {
        currentStatus = Status.Delivered;
    }

    // Array
    // Fixed size:
    uint[10] public arrayNumbers;  // max length 10  uint numbers only in array 
    string[5] public  arrayString; // string only array

    function arrayAddNumber() public {
        arrayNumbers[0] = 10;
        arrayNumbers[4] = 14;
        //another will be 0
    }
  
    uint[3][2] public items; //  two-dimensional array

    function fixedSize() public {
        items = [
            [3,4,5],
            [6,7,8]
        ];
    }

     // Dynamic
    uint[] public itemsDynamic; 
    uint public arrayLength;

        function arrayPush() public {
        itemsDynamic.push(1); // push only Dynamic []
       itemsDynamic.push(2);
        arrayLength = itemsDynamic.length;
    }

    function sampleMemory() public view returns(uint[] memory) {
        uint[] memory tempArray = new uint[](10); // new array only working in function
        tempArray[0] = 1;
        return tempArray; // 0:uint256[]: 1,0,0,0,0,0,0,0,0,0
    }

     // Byte
     // fixed 
    bytes32 public myVar = "test here"; //  0:bytes32: 0x7465737420686572650000000000000000000000000000000000000000000000
     // dynamic 
    bytes public myDynVar = "test here"; //0:bytes: 0x746573742068657265
    bytes public myDynVarUnicode = unicode"привет солид"; // bytes: 0xd0bfd180d0b8d0b2d0b5d18220d181d0bed0bbd0b8d0b4
    // 1 --> 32
    // 32 * 8 = 256 max
    // uint256

    function func() public view returns(uint) {
        return myDynVarUnicode.length; // uint256: 23
    }

   function firstByte() public view returns(bytes1) {
        return myDynVar[0]; // bytes1: 0x74 return byte first 't'
    }

 // Struct
    struct Payment {
        uint amount;
        uint timestamp;
        address from;
        string message;
        // Payment payment; not recurs
    }

    struct Balance {
        uint totalPayments;
        mapping(uint => Payment) payments;
    }

    mapping(address => Balance) public balances;

    function getPayment(address _addr, uint _index) public view returns(Payment memory) {
        return balances[_addr].payments[_index]; // tuple(uint256,uint256,address,string): 0,1706298334,0x5B38Da6a701c568545dCfcB03FcB875f56beddC4,'ho'
    }

    function pay(string memory message) public payable {
        uint paymentNum = balances[msg.sender].totalPayments;
        balances[msg.sender].totalPayments++;

        Payment memory newPayment = Payment( // temporary struct
            msg.value,
            block.timestamp,
            msg.sender,
            message
        );

        balances[msg.sender].payments[paymentNum] = newPayment;
    }
}
