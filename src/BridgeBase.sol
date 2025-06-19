// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";

contract BridgeBase is Ownable {

    address public tokenAddress;

    mapping(address => uint256) public pendingBalance;

    event Burn(address indexed user, uint256 amount);

    constructor(address _tokenAddress) Ownable(msg.sender) {
        tokenAddress = _tokenAddress;
    }

    function burn(IERC20 _tokenAddress, uint256 _amount) public {
        require(tokenAddress == address(_tokenAddress), "Invalid token address");
        require(_amount > 0, "Amount must be greater than zero");
        _tokenAddress.burn(msg.sender, _amount);
    }

    function withdraw(IERC20 _tokenAddress, uint256 _amount) public {
        require(tokenAddress == address(_tokenAddress), "Invalid token address");
        require(_amount > 0, "Amount must be greater than zero");
        require(pendingBalance[msg.sender] >= _amount, "Insufficient pending balance");

        pendingBalance[msg.sender] -= _amount;
        _tokenAddress.mint(msg.sender, _amount);
    }

    function depositedOnOtherSide(address user, uint256 _amount) public onlyOwner {
        require(_amount > 0, "Amount must be greater than zero");
        pendingBalance[user] += _amount;
        emit Burn(user, _amount);
    }
}