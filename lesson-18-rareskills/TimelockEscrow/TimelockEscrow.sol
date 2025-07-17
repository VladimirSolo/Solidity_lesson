// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.13;

contract TimelockEscrow {
    address public seller;
    uint256 constant ESCROW_DURATION = 3 days;
    struct Escrow {
        uint256 amount;
        uint256 startTime;
        bool withdrawn;
    }

    mapping(address => Escrow) public escrows;

    /**
     * The goal of this exercise is to create a Time lock escrow.
     * A buyer deposits ether into a contract, and the seller cannot withdraw it until 3 days passes. Before that, the buyer can take it back
     * Assume the owner is the seller
     */

    constructor() {
        seller = msg.sender;
    }

    /**
     * creates a buy order between msg.sender and seller
     * escrows msg.value for 3 days which buyer can withdraw at anytime before 3 days
     * but after that only seller can withdraw
     * should revert if an active escrow still exists or last escrow hasn't been withdrawn
     */
    function createBuyOrder() external payable {
        Escrow storage escrow = escrows[msg.sender];

        require(escrow.amount == 0 || escrow.withdrawn, "Active escrow exists");
        require(msg.value > 0, "Must send ETH");

        escrows[msg.sender] = Escrow({
            amount: msg.value,
            startTime: block.timestamp,
            withdrawn: false
        });
    }

    /**
     * allows seller to withdraw after 3 days of the escrow with @param buyer has passed
     */
    function sellerWithdraw(address buyer) external {
        require(msg.sender == seller, "Only seller can withdraw");

        Escrow storage escrow = escrows[buyer];

        require(!escrow.withdrawn, "Already withdrawn");
        require(escrow.amount > 0, "No active escrow");
        require(
            block.timestamp >= escrow.startTime + ESCROW_DURATION,
            "Timelock not expired"
        );

        uint256 amount = escrow.amount;
        escrow.withdrawn = true;
        escrow.amount = 0;

        payable(seller).transfer(amount);
    }

    /**
     * allows buyer to withdraw at anytime before the end of the escrow (3 days)
     */
    function buyerWithdraw() external {
        Escrow storage escrow = escrows[msg.sender];

        require(!escrow.withdrawn, "Already withdrawn");
        require(escrow.amount > 0, "No active escrow");
        require(
            block.timestamp < escrow.startTime + ESCROW_DURATION,
            "Too late to withdraw"
        );

        uint256 amount = escrow.amount;
        escrow.withdrawn = true;
        escrow.amount = 0;

        payable(msg.sender).transfer(amount);
    }

    // returns the escrowed amount of @param buyer
    function buyerDeposit(address buyer) external view returns (uint256) {
        return escrows[buyer].amount;
    }
}
