// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

// import {UUPSUpgradeable} from "@openzeppelin/contracts/proxy/utils/UUPSUpgradeable.sol";
// import {Initializable} from "@openzeppelin/contracts/proxy/utils/Initializable.sol";
// import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/contracts/access/OwnableUpgradeable.sol";

import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/contracts/access/OwnableUpgradeable.sol";
import {Initializable} from "@openzeppelin/contracts-upgradeable/contracts/proxy/utils/Initializable.sol";
import {UUPSUpgradeable} from "@openzeppelin/contracts-upgradeable/contracts/proxy/utils/UUPSUpgradeable.sol";

/// @notice uses UUPS proxy
/// @notice storage is stored in the proxy, NOT the implementation
/// @notice proxy will borrow the implementation functions
/// @notice proxy should deploy the implementation contract and then it should call some "initializer" function.
contract BoxV1 is Initializable, OwnableUpgradeable, UUPSUpgradeable {
    uint256 internal number;

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function initialize(address initialOwner) public initializer {
        __Ownable_init(initialOwner);
        __UUPSUpgradeable_init();
    }

    function getNumber() external view returns (uint256) {
        return number;
    }

    function version() external pure returns (uint256) {
        return 1;
    }

    function _authorizeUpgrade(address newImplementation) internal override {
        // if(msg.sender != owner){
        //     revert;
        // }
        // we have to set the owner initially
        // and make sure only owner can make changes
    }
    // since we haven't implemented any checks in _authorizeUpgrade
    // anyone can call this fn right now
    // but we have to restrict to only owner
}
