// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

import LockUSDT from "./LockUSDT.sol";
import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface IBUSDT {
    function burn(address from, uint256 amount) external;
    function mint(address to, uint256 amount) external;
}

contract BridgeEth is Ownable {

    address public sanjTokenAddress;

    mapping(address => uint256) public pendingBalance;

    event Lock(address indexed user, uint256 amount);
    event Withdraw(address indexed user, uint256 amount);

    constructor(address _sanjTokenAddress) Ownable(msg.sender) {
        sanjTokenAddress = _sanjTokenAddress;
    }

    function lock(IBUSDT _sanjTokenAddress, uint256 _amount) public {
        require(sanjTokenAddress == address(_sanjTokenAddress), "Invalid token address");
        require(_amount > 0, "Amount must be greater than zero");
        require(_sanjTokenAddress.allowance(msg.sender, address(this)) >= _amount, "Insufficient allowance");
        _sanjTokenAddress.transferFrom(msg.sender, address(this), _amount);
        // pendingBalance[msg.sender] += _amount;
 
        emit Lock(msg.sender, _amount);
    }

    function withdraw(IBUSDT _sanjTokenAddress, uint256 _amount) public {
        require(sanjTokenAddress == address(_sanjTokenAddress), "Invalid token address");
        require(_amount > 0, "Amount must be greater than zero");
        require(pendingBalance[msg.sender] >= _amount, "Insufficient pending balance");
        
        pendingBalance[msg.sender] -= _amount;
        _sanjTokenAddress.transfer(msg.sender, _amount);

        emit Withdraw(msg.sender, _amount);
    }

    function burnedOnOtherSide(address user, uint256 _amount) public onlyOwner {
        pendingBalance[user] += _amount;
    }
}