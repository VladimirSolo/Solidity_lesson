// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract CrowdFunding {
    struct Campaign {
        address owner;
        uint goal;
        uint pledged;
        uint startAt;
        uint endAt;
        bool claimed;
    }

    IERC20 public immutable token;
    mapping(uint => Campaign) public campaings;
    uint public currentId;
    mapping(uint => mapping(address => uint)) public pledges;
    uint public constant MAX_DURARITION = 100 days;
    uint public constant MIN_DURATION = 10;

    event Launched(uint id, address owner, uint goal, uint startAt, uint endAt);
    event Cancel(uint id);
    event Pledged(uint id, address pledger, uint amount);
    event UnPledged(uint id, address pledger, uint amount);
    event Claimed(uint id);
    event Refunded(uint id, address pledger, uint amount);

    constructor(address _token) {
        token = IERC20(_token);
    }

    function launch(uint _goal, uint _startAt, uint _endAt) external {
        require(_startAt >= block.timestamp, "Incorrect start at");
        require(_endAt >= _startAt + MIN_DURATION, "Incorrect end at"); // can use 1 day
        require(_endAt >= _startAt + MAX_DURARITION, "Too long!");

        campaings[currentId] = Campaign({
            owner: msg.sender,
            goal: _goal,
            pledged: 0,
            startAt: _startAt, // for testing can comment require and here use block.timestamp
            endAt: _endAt, //block.timestamp + 40
            claimed: false
        });

        emit Launched(currentId, msg.sender, _goal, _startAt, _endAt);
        currentId++;
    }

    function cancel(uint _id) external {
        Campaign memory campaing = campaings[_id];
        require(msg.sender == campaing.owner, "Not an owner!");
        require(block.timestamp < campaing.startAt, "Already started!");

        delete campaings[_id];
        emit Cancel(_id);
    }

    function pledge(uint _id, uint _amount) external {
        Campaign storage campaing = campaings[_id];
        require(block.timestamp >= campaing.startAt, "Not Started!");
        require(block.timestamp < campaing.endAt, "Ended!");

        campaing.pledged += _amount;
        pledges[_id][msg.sender] += _amount;
        token.transferFrom(msg.sender, address(this), _amount);

        emit Pledged(_id, msg.sender, _amount);
    }

    function unPledge(uint _id, uint _amount) external {
        Campaign storage campaing = campaings[_id];

        require(block.timestamp < campaing.endAt, "Ended!");

        campaing.pledged -= _amount;
        pledges[_id][msg.sender] -= _amount;
        token.transfer(msg.sender, _amount);
        emit UnPledged(_id, msg.sender, _amount);
    }

    function claim(uint _id) external {
        Campaign storage campaing = campaings[_id];
        require(msg.sender == campaing.owner, "Not an owner!");
        require(block.timestamp > campaing.endAt, "Not ended!");
        require(campaing.pledged >= campaing.goal, "Pledged is too low!");
        require(!campaing.claimed, "Already claimed!");

        campaing.claimed = true;
        token.transfer(msg.sender, campaing.pledged);
        emit Claimed(_id);
    }

    function refund(uint _id) external {
        Campaign storage campaing = campaings[_id];
        require(block.timestamp > campaing.endAt, "Not ended!");
        require(campaing.pledged < campaing.goal, "Reached goal!");

        uint pledgedAmount = pledges[_id][msg.sender];
        pledges[_id][msg.sender] = 0;
        token.transfer(msg.sender, pledgedAmount);

        emit Refunded(_id, msg.sender, pledgedAmount);
    }
}
