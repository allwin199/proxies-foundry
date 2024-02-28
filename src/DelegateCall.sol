// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// NOTE: Deploy this contract first
contract B {
    // NOTE: storage layout must be the same as contract A
    uint256 public num;
    address public sender;
    uint256 public value;

    function setVars(uint256 _num) public payable {
        num = _num;
        sender = msg.sender;
        value = msg.value;
    }
}

contract A {
    uint256 public num;
    address public sender;
    uint256 public value;

    function setVars(address _contract, uint256 _num) public payable {
        // A's storage is set, B is not modified.
        (bool success, bytes memory data) = _contract.delegatecall(abi.encodeWithSignature("setVars(uint256)", _num));
        if (!success) {}
    }
}

// Explanation
// delegatecall is a low level function similar to call.
// When contract A executes delegatecall to contract B, B's code is executed
// with contract A's storage, msg.sender and msg.value.
// NOTE: contract A & B should have same storage layout
// contract A has a setVars fn
// when setVars is called in contract A, it delgates the call to contract B
// now setVars inside contract B will get executed but it will update the storage in contract A

// when setVars inside contract A is called
// It borrows the functionality of setVars from contract B for one execution and return it after the function call
// function setVars(uint256 _num) public payable {
//     num = _num;
//     sender = msg.sender;
//     value = msg.value;
//  }
// when doing delegate call, contract B dosen't look at storage names, it looks at storage slot and update it
// for eg
// function setVars(uint256 _num) public payable {
//     storageSlot[0] = _num;
//     storageSlot[1] = msg.sender;
//     storageSlot[2] = msg.value;
//  }
// storageSlot[0] in contract A will be updated with `_num` value
