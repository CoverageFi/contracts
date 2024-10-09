// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import {Script, console2} from "forge-std/Script.sol";
import {CrossChainReceiver} from "../src/CrossChainReceiver.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

contract DeployCrossChainReceiver is Script {
    HelperConfig public helperConfig;
    CrossChainReceiver public crossChainReceiver;

    function run() external {
        helperConfig = new HelperConfig();
        vm.startBroadcast();
        crossChainReceiver = new CrossChainReceiver(
            helperConfig.getSepoliaConfig().wormholeRelayer,
            helperConfig.getSepoliaConfig().tokenBridge,
            helperConfig.getSepoliaConfig().wormhole
        );
        vm.stopBroadcast();
        console2.log(
            "CrossChainReceiver deployed to: ",
            address(crossChainReceiver)
        );
    }
}
