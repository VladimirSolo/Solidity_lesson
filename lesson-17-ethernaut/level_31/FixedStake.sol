// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IWETH {
    function transfer(address to, uint256 amount) external returns (bool);

    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external returns (bool);

    function allowance(
        address owner,
        address spender
    ) external view returns (uint256);
}

contract FixedStake {
    uint256 public totalStakedETH;
    uint256 public totalStakedWETH;

    struct UserInfo {
        uint256 ethAmount;
        uint256 wethAmount;
    }

    mapping(address => UserInfo) public userStakes;
    mapping(address => bool) public stakers;
    address public immutable WETH;

    constructor(address _weth) payable {
        require(_weth != address(0), "Invalid WETH address");
        WETH = _weth;
        if (msg.value > 0) {
            totalStakedETH += msg.value;
        }
    }

    function stakeETH() public payable {
        require(msg.value > 0.001 ether, "Minimum stake: 0.001 ETH");

        totalStakedETH += msg.value;
        userStakes[msg.sender].ethAmount += msg.value;
        stakers[msg.sender] = true;
    }

    function stakeWETH(uint256 amount) public returns (bool) {
        require(amount > 0.001 ether, "Minimum stake: 0.001 WETH");

        // Безопасная проверка разрешения на перевод
        uint256 allowance = IWETH(WETH).allowance(msg.sender, address(this));
        require(allowance >= amount, "Insufficient allowance");

        // Перевод WETH на контракт
        bool transferred = IWETH(WETH).transferFrom(
            msg.sender,
            address(this),
            amount
        );
        require(transferred, "WETH transfer failed");

        totalStakedWETH += amount;
        userStakes[msg.sender].wethAmount += amount;
        stakers[msg.sender] = true;

        return true;
    }

    function unstakeETH(uint256 amount) public returns (bool) {
        require(
            userStakes[msg.sender].ethAmount >= amount,
            "Insufficient ETH balance"
        );

        userStakes[msg.sender].ethAmount -= amount;
        totalStakedETH -= amount;

        (bool success, ) = payable(msg.sender).call{value: amount}("");
        require(success, "ETH transfer failed");

        return success;
    }

    function unstakeWETH(uint256 amount) public returns (bool) {
        require(
            userStakes[msg.sender].wethAmount >= amount,
            "Insufficient WETH balance"
        );

        userStakes[msg.sender].wethAmount -= amount;
        totalStakedWETH -= amount;

        bool success = IWETH(WETH).transfer(msg.sender, amount);
        require(success, "WETH transfer failed");

        return success;
    }

    // Безопасные геттеры
    function getUserETHStake(address user) public view returns (uint256) {
        return userStakes[user].ethAmount;
    }

    function getUserWETHStake(address user) public view returns (uint256) {
        return userStakes[user].wethAmount;
    }

    function getTotalStaked() public view returns (uint256 eth, uint256 weth) {
        return (totalStakedETH, totalStakedWETH);
    }
}
