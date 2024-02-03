// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

contract Struct {
    // Declaration of the Struct contract.

    struct Payment {
        // Definition of the Payment structure representing a payment.
        uint amount; // Field to store the payment amount.
        uint timestamp; // Field to store the timestamp of the payment.
        // Payment my_payment; // <--- Error! Including an instance of its own structure inside itself is not allowed!!!!!!.
    }

    struct Balance {
        // Definition of the Balance structure representing an address balance.
        uint totalBalance; // Field to store the total balance.
        uint numPayments; // Field to store the number of payments.
        mapping(uint => Payment) payments; // Mapping to store information about each payment.
    }

    mapping(address => Balance) public balanceReceived;
    // Mapping to track the balance of each address.

    function receiveMoney() public payable {
        // Function to receive Ether.

        balanceReceived[msg.sender].totalBalance += msg.value;
        // Increase the total balance of the address by the received Ether amount.

        Payment memory payment = Payment(msg.value, block.timestamp);
        // Create an instance of the Payment structure to store information about the current payment.

        balanceReceived[msg.sender].payments[balanceReceived[msg.sender].numPayments] = payment;
        // Save information about the payment in the mapping.

        balanceReceived[msg.sender].numPayments++;
        // Increase the payment count.
    }

    function withdrawAllMoney(address payable _to) public {
        // Function to withdraw all funds.

        uint balanceToSend = balanceReceived[msg.sender].totalBalance;
        // Get the total balance of the address for withdrawal.

        balanceReceived[msg.sender].totalBalance = 0;
        // Reset the total balance of the address.

        _to.transfer(balanceToSend);
        // Transfer funds to the specified address.
    }
}

// docs ======>

// Defines a new type with two fields.
// Declaring a struct outside of a contract allows
// it to be shared by multiple contracts.
// Here, this is not really needed.
struct Funder {
    address addr;
    uint amount;
}

contract CrowdFunding {
    // Structs can also be defined inside contracts, which makes them
    // visible only there and in derived contracts.
    struct Campaign {
        address payable beneficiary;
        uint fundingGoal;
        uint numFunders;
        uint amount;
        mapping(uint => Funder) funders;
    }

    uint numCampaigns;
    mapping(uint => Campaign) campaigns;

    function newCampaign(address payable beneficiary, uint goal) public returns (uint campaignID) {
        campaignID = numCampaigns++; // campaignID is return variable
        // We cannot use "campaigns[campaignID] = Campaign(beneficiary, goal, 0, 0)"
        // because the right hand side creates a memory-struct "Campaign" that contains a mapping.
        Campaign storage c = campaigns[campaignID];
        c.beneficiary = beneficiary;
        c.fundingGoal = goal;
    }

    function contribute(uint campaignID) public payable {
        Campaign storage c = campaigns[campaignID];
        // Creates a new temporary memory struct, initialised with the given values
        // and copies it over to storage.
        // Note that you can also use Funder(msg.sender, msg.value) to initialise.
        c.funders[c.numFunders++] = Funder({addr: msg.sender, amount: msg.value});
        c.amount += msg.value;
    }

    function checkGoalReached(uint campaignID) public returns (bool reached) {
        Campaign storage c = campaigns[campaignID];
        if (c.amount < c.fundingGoal)
            return false;
        uint amount = c.amount;
        c.amount = 0;
        c.beneficiary.transfer(amount);
        return true;
    }
}

/* 
    The contract does not provide the full functionality of a crowdfunding contract,
    but it contains the basic concepts necessary to understand structs.
    Struct types can be used inside mappings and arrays and they can themselves contain mappings and arrays
 */
/* 
      Note how in all the functions, a struct type is assigned to a local variable with data location storage.
      This does not copy the struct but only stores a reference so 
      that assignments to members of the local variable actually write to the state.
 */