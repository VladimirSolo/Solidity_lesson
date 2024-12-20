// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;
// using on remix
// import "@openzeppelin/contracts/access/Ownable.sol";

contract SharedWallet is Ownable {
        struct Member {
            string name;
            uint limit;
            bool is_admin;
    }
    mapping(address => Member) public members;
    event LimitChanged(address indexed _from, uint _newAmount, uint _oldAmount);
    event AdminStatusChanged(address indexed _member, bool _isAdmin);

    constructor() Ownable(msg.sender) {}
    
    modifier ownerOrWithinLimitOrAdmin(uint _amount) {
    require(
        isOwner() || 
        (members[msg.sender].is_admin) || 
        (members[msg.sender].limit >= _amount), 
        "Not Allowed!"
    );
    _;
    }

    function isOwner() internal view  returns(bool) {
        return owner() == msg.sender;
    }

    function deleteMember(address _members) external onlyOwner {
        delete members[_members];
    }

    function makeAdmin(address _member) external onlyOwner {
        require(members[_member].limit > 0, "Member does not exist");
        members[_member].is_admin = true;
        emit AdminStatusChanged(_member, true);
    }

    function revokeAdmin(address _member) external onlyOwner {
        require(members[_member].is_admin, "Member is not an admin");
        members[_member].is_admin = false;
        emit AdminStatusChanged(_member, false);
    }

    function addLimit(address _members, uint _limit) external {
        uint _oldLimit = members[_members].limit;
        members[_members].limit = _limit;
        
        emit LimitChanged(_members, _limit, _oldLimit);
    }

    function deduceFromLimit(address _member, uint _amount) internal {
        members[_member].limit -=_amount;
    }

    function renounceOwnership() public view override onlyOwner {
        revert("Can't renounce");
    }
}
