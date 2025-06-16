// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import { Test, console } from "forge-std/Test.sol";
import { BridgeETH } from "../src/BridgeETH.sol";
import { USDT } from "../src/USDT.sol";

contract CBridgeTest is Test {

    BridgeETH bridge;
    USDT usdt;
    
    function setUp() public {
        usdt = new USDT();
        bridge = new BridgeETH(address(usdt));
    }

    function test_Deposit() public {
        address addr = address(0x1234567890123456789012345678901234567890);

        usdt.mint(addr, 50);

        vm.startPrank(addr);
        usdt.approve(address(bridge), 50);

        bridge.deposit(usdt, 50);
        assertEq(usdt.balanceOf(addr), 0);
        assertEq(usdt.balanceOf(address(bridge)), 50);

        bridge.withdraw(usdt, 20);
        assertEq(usdt.balanceOf(addr), 20);
        assertEq(usdt.balanceOf(address(bridge)), 30);

        vm.stopPrank();

    }
}
