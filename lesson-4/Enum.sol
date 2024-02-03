// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

// Enums cannot have more than 256 members.
// Using type(NameOfEnum).min and type(NameOfEnum).max you can get the smallest and respectively largest value of the given enum
// Enums can also be declared on the file level, outside of contract or library definitions.

contract Enum {
  enum PurchaseStatuses { Started, Paid, Delivered, Received } // start from zero 0

  PurchaseStatuses currentStatus;

   function addToCart() public {
    currentStatus = PurchaseStatuses.Started;
    // ...
  }

  function deliver() public {
    currentStatus = PurchaseStatuses.Delivered;
    // ...
  }

   function isDelivered() public {
    if(currentStatus == PurchaseStatuses.Delivered) {
      // ...
    }
  }

  // docs

  enum ActionChoices { GoLeft, GoRight, GoStraight, SitStill }
    ActionChoices choice;
    ActionChoices constant defaultChoice = ActionChoices.GoStraight;

    function setGoStraight() public {
        choice = ActionChoices.GoStraight;
    }

    // Since enum types are not part of the ABI, the signature of "getChoice"
    // will automatically be changed to "getChoice() returns (uint8)"
    // for all matters external to Solidity.
    function getChoice() public view returns (ActionChoices) {
        return choice;
    }

    function getDefaultChoice() public pure returns (uint) {
        return uint(defaultChoice);
    }

    function getLargestValue() public pure returns (ActionChoices) {
        return type(ActionChoices).max;
    }

    function getSmallestValue() public pure returns (ActionChoices) {
        return type(ActionChoices).min;
    }
}
