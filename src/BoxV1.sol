// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/contracts/access/OwnableUpgradeable.sol";
import {Initializable} from "@openzeppelin/contracts-upgradeable/contracts/proxy/utils/Initializable.sol";
import {UUPSUpgradeable} from "@openzeppelin/contracts-upgradeable/contracts/proxy/utils/UUPSUpgradeable.sol";

/// @notice uses UUPS proxy
/// @notice storage is stored in the proxy, NOT the implementation
/// @notice proxy will borrow the implementation functions
/// @notice proxy should deploy the implementation contract and then it should call some "initializer" function.

// Note: Storage is stored in proxy, Not in the implementation
// "When using proxies with upgradeable contracts, any changes made within the implementation contract's constructor wouldn't directly update the existing state of the deployed proxy contract".
// Therfore, implementation contract shouldn't have anything inside the constructor

contract BoxV1 is Initializable, OwnableUpgradeable, UUPSUpgradeable {
    uint256 internal number;

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
        // _disableInitializers will put here to say don't let any initialization happen here
    }

    // this `initialize` function will act as `constructor` for `proxy` contracts
    // when this contract is deployed
    // deployer has to call this `initialize` function
    // which will make `proxy` contract to be owner of this contract
    function initialize(address initialOwner) public initializer {
        __Ownable_init(initialOwner);
        __UUPSUpgradeable_init();
        // this fn dosen't change anything but since it is `UUPSUpgradeable` we have placed it here
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
