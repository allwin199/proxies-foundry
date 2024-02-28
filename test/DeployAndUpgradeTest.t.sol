// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {DeployBox} from "../script/DeployBox.s.sol";
import {UpgradeBox} from "../script/UpgradeBox.s.sol";
import {BoxV1} from "../src/BoxV1.sol";
import {BoxV2} from "../src/BoxV2.sol";

contract DeployAndUpgradeTest is Test {
    DeployBox public deployer;
    UpgradeBox public upgrader;
    BoxV2 public boxV2;

    address public owner = makeAddr("owner");

    address public proxy;

    function setUp() external {
        deployer = new DeployBox();
        upgrader = new UpgradeBox();
        boxV2 = new BoxV2();

        proxy = deployer.run();
        // proxy right now points to boxV1
    }

    function test_proxyStartsWith_BoxV1() public {
        uint256 expectedVersion = 1;
        uint256 actualVersion = BoxV1(proxy).version();

        assertEq(expectedVersion, actualVersion, "proxyInitalVersion");
    }

    function test_RevertsIf_SetNumberCalledIn_BoxV1() public {
        vm.expectRevert();
        BoxV2(proxy).setNumber(12);
    }

    function test_ProxyUpgraded_ToBoxV2() public {
        upgrader.upgradeBox(proxy, address(boxV2));

        uint256 expectedVersion = 2;
        uint256 actualVersion = BoxV2(proxy).version();
        // since proxy is pointing to BoxV2
        // proxy has to be typecasted into BoxV2

        assertEq(expectedVersion, actualVersion, "proxyCurrentVersion");
    }

    function test_SetNumber_SetsNumberIn_BoxV2() public {
        upgrader.upgradeBox(proxy, address(boxV2));

        BoxV2(proxy).setNumber(12);

        uint256 actualNumber = BoxV2(proxy).getNumber();
        uint256 expectedNumber = 12;

        assertEq(actualNumber, expectedNumber, "setNumber");
    }
}
