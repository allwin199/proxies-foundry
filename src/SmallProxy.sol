// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Proxy} from "@openzeppelin/contracts/proxy/Proxy.sol";

contract SmallProxy is Proxy {
    // This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1
    bytes32 private constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;

    function setImplementation(address newImplementation) public {
        assembly {
            sstore(_IMPLEMENTATION_SLOT, newImplementation)
        }
    }

    function _implementation() internal view override returns (address implementationAddress) {
        assembly {
            implementationAddress := sload(_IMPLEMENTATION_SLOT)
        }
    }

    receive() external payable {}

    // helper function
    // check the implementation A & B below
    // If we call the getDataToTransact()
    // it has setValue() but setValue() is not present inside this contract
    // therfore smallProxy will do delegateCall to the implementation contract
    function getDataToTransact(uint256 numberToUpdate) public pure returns (bytes memory) {
        return abi.encodeWithSignature("setValue(uint256)", numberToUpdate);
    }

    // by calling the above function
    // we are making changes to the smallProxy contract storage

    function readStorage() public view returns (uint256 valueAtStorageSlotZero) {
        assembly {
            valueAtStorageSlotZero := sload(0)
        }
    }

    // when getDataToTransact is called with a number
    // it will return the functionSignature hash
    // use the functionSignature hash and give this as a input to the CALLDATA and trigger transact
    // then call the readStorage to check the updated number
}

// This is minimal proxy smart contract from openzeppelin
// Inside the proxy contract in openzeppelin we have a fallback() and receive()
// fallback() will be called when callData is not empty
// whenver fallback() receives a fn that dosen't recognize
// fallback() calls the _delegate()
// _delegate() now will delegateCall the implementation contract
// _delegate() will send this function to the implementation contract using delegate call

// In out minimal contract we can set the implementation contract using setImplementation();
// implementation() will read where the implementation contract is
// To work with proxy we don't want anything in storage
// but we definitely need to store the implementation contract
// to store the implementation contract we are using special storage allocated for it => _IMPLEMENTATION_SLOT
// _IMPLEMENTATION_SLOT will store the contract address that has to be implemented.

// Whenever smallProxy is called, with a function that dosen't exist in smallProxy using fallback()
// it will do delegateCall to that implementation contract

contract ImplementationA {
    uint256 public value;

    function setValue(uint256 newValue) public {
        value = newValue;
    }
}

contract ImplementationB {
    uint256 public value;

    function setValue(uint256 newValue) public {
        value = newValue + 2;
    }
}

// we have 2 implementation contracts
// both implementation contracts have setValue()
// but has different logics.
// let's say we used ImplementationA as first Implementation
// then after quite a while we switched to ImplementationB
// just by calling the setImplementation() inside the SmallProxy we can change the implementation contract

//////////
// function setImplementation(){}
// Transparent Proxy -> Ok, only admins can call functions on the proxy
// anyone else ALWAYS gets sent to the fallback contract.

// UUPS -> Where all upgrade logic is in the implementation contract, and
// you can't have 2 functions with the same function selector.
