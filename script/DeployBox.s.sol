// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Script, console} from "forge-std/Script.sol";
import {BoxV1} from "../src/BoxV1.sol";
import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

contract DeployBox is Script {
    address deployer;

    constructor() {
        if (block.chainid == 31337) {
            deployer = vm.envAddress("ANVIL_KEYCHAIN");
        } else {
            deployer = vm.envAddress("SEPOLIA_KEYCHAIN");
        }
    }

    function run() external returns (address) {
        address proxy = deployBox();
        return proxy;
    }

    function deployBox() public returns (address) {
        vm.startBroadcast(deployer);

        // BoxV1 will be the implementation contract
        BoxV1 box = new BoxV1();

        // proxy will be the proxy contract
        ERC1967Proxy proxy = new ERC1967Proxy(address(box), "");

        BoxV1(address(proxy)).initialize(msg.sender);

        vm.stopBroadcast();

        return address(proxy);
    }
}
