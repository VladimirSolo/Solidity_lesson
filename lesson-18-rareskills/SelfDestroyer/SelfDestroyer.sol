// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.13;

contract SelfDestroyer {
    /* This exercise assumes you know the selfdestruct function works.
        1. The contract has some ether in it, 
        destroy the contract and send all ether to an address 
        2. The name of the function must be `destroy`,
        that takes a non-payable address input
    */

    constructor() payable {}

    function destroy(address taker) external {
        // your code here
        selfdestruct(payable(taker));
    }

    function getBalance() public view returns (uint256 balance) {
        balance = address(this).balance;
    }
}

/* 
Что делает selfdestruct:
Удаляет байткод контракта с адреса.

Очищает хранилище (storage).

Переводит весь оставшийся баланс на указанный адрес.

После этого вызовы к этому контракту больше невозможны 
(контракт как будто "никогда не существовал", но его следы останутся в истории транзакций).


pragma solidity ^0.8.0;

contract KillMe {
    address payable public owner;

    constructor() {
        owner = payable(msg.sender);
    }

    function destroy() public {
        require(msg.sender == owner, "Not the owner");
        selfdestruct(owner); // отправит весь эфир и удалит контракт
    }
}

 */
