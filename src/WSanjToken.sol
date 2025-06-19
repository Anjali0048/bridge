// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

import { ERC20 } from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";

contract WSanjToken is ERC20, Ownable {    

    constructor() ERC20("WSanjToken", "WSA") Ownable(msg.sender) {};

    function mint(address to, uint256 _amount) public onlyOwner {
        require(_amount > 0, "Amount must be greater than zero");
        _mint(to, _amount);
    }

    function burn(address from, uint256 _amount) public onlyOwner {
        require(_amount > 0, "Amount must be greater than zero");
        _burn(from, _amount);
    }
}