// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";

// Not related to the Bridge contract, but a simple example of an upgradable contract.

// To make the contract upgradeable
// Proxy contract
// using delegatecall to call functions in the implementation contract

contract ProxyContract is Ownable {
    // storage slot 0 is Ownable because it is equivalent to writing "address public owner;"    
    uint public num; // storage slot 1
    address impl; // storage slot 2

    constructor(address _impl) Ownable(msg.sender) {
        num = 0;
        impl = _impl;
    }

    function setNum(uint _num) public {
        (bool success, ) = impl.delegatecall( abi.encodeWithSignature("setNum(uint256)", _num) );
        require(success, "Delegate call failed");
    }

    function setImplementation(address _impl) onlyOwner public {
        impl = _impl;
    }
}

// Logic contract
contract ImplementationV1 {
    address public owner; // storage slot 0, added this dummy address so that the storage slot of num is not 0
    uint public num; // storage slot 1

    function setNum(uint _num) public {
        num = 2 * _num;
    }
}

// Logic contract
contract ImplementationV2 {
    address public owner; // storage slot 0, added this dummy address so that the storage slot of num is not 0
    uint public num; // storage slot 1

    function setNum(uint _num) public {
        num = 5 * _num;
    }
}

// *******************************************************************************************************

// A better proxy contract which uses fallbacks
contract BetterProxyContract is Ownable {
    uint public num;
    address impl;

    constructor(address _impl ) Ownable(msg.sender) {
        num = 0;
        impl = _impl;
    }

    fallback() external payable {
        (bool success, ) = impl.delegatecall(msg.data);

        if( !success ) {
            revert("Delegate call failed");
        }
    }

    function setImplementation(address _impl) onlyOwner public {
        impl = _impl;
    }
}

// Take hash of first 4 bytes (8 char) of the function signature and prepend with 0x and then paste it in CALLDATA in remix and then transact. If the function is not defined in the BetterProxyContract then it will go into the fallback and call the function that is defined in ImplV1 contract.
// Use Keccak-256 for this
contract ImplV1 {
    uint public num; 

    function setNum(uint _num) public {
        num = 2 * _num;
    }
}

// CALLDATA for setNum() is 0x2ferg15d
// CALLDATA for setNum(uint256) is 0x2f2ff15d000000000000000000000000002
// Can use AtAddress button in remix instead of using CALLDATA also. Because we gets a UI there so no need to find the CALLDATA manually.

contract ImplV2 {
    uint public num; 

    function setNum(uint _num) public {
        num = 2 * _num;
    }

    function setNum5(uint _num) public view returns (uint) {
        return 5 * _num;
    }
}