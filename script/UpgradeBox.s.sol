// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Script, console} from "forge-std/Script.sol";
import {BoxV1} from "../src/BoxV1.sol";
import {BoxV2} from "../src/BoxV2.sol";
import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";

contract UpgradeBox is Script {
    address deployer;
    BoxV2 boxV2;

    constructor() {
        if (block.chainid == 31337) {
            deployer = vm.envAddress("ANVIL_KEYCHAIN");
        } else {
            deployer = vm.envAddress("SEPOLIA_KEYCHAIN");
        }
    }

    function run() external returns (address) {
        address mostRecentlyDeployedProxy = DevOpsTools.get_most_recent_deployment("ERC1967Proxy", block.chainid);

        vm.startBroadcast(deployer);
        boxV2 = new BoxV2();
        vm.stopBroadcast();

        address proxy = upgradeBox(mostRecentlyDeployedProxy, address(boxV2));
        return proxy;
    }

    function upgradeBox(address proxyAddress, address newBox) public returns (address) {
        vm.startBroadcast(deployer);

        BoxV1 proxy = BoxV1(payable(proxyAddress));
        // since upgradeToCall is present inside the current implementation contract
        // we have to typecast proxy to BoxV1

        proxy.upgradeToAndCall(address(newBox), "");
        // proxy contract now points to this new implementation

        // address owner = BoxV2(newBox).owner();
        // console.log("owner", owner);

        vm.stopBroadcast();
        return address(proxy);
    }
}
