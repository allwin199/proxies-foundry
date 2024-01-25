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
