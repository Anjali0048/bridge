// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract LockSA {

    address private usdtAddress;
    mapping (address => uint256) pendingBalance;

    constructor(address _usdtAddress) {
        usdtAddress = _usdtAddress;
    }

    function deposit(uint256 _amount) public {
        require(_amount > 0, "Amount must be greater than zero");
        require(IERC20(usdtAddress).allowance(msg.sender, address(this)) >= _amount, "Insufficient allowance");
        IERC20(usdtAddress).transferFrom(msg.sender, address(this), _amount);
        pendingBalance[msg.sender] += _amount;
    }

    function withdraw() public {
        unit256 remainingAmount = pendingBalance[msg.sender];
        IERC20(usdtAddress).transfer(msg.sender, remainingAmount);
        pendingBalance[msg.sender] = 0;
    }
}