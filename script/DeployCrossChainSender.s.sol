// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import {Script, console2} from "forge-std/Script.sol";
import {CrossChainSender} from "../src/CrossChainSender.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

contract DeployCrossChainSender is Script {
    HelperConfig public helperConfig;
    CrossChainSender public crossChainSender;

    function run() external {
        helperConfig = new HelperConfig();
        vm.startBroadcast();
        crossChainSender = new CrossChainSender(
            helperConfig.getSepoliaConfig().wormholeRelayer,
            helperConfig.getSepoliaConfig().tokenBridge,
            helperConfig.getSepoliaConfig().wormhole
        );
        vm.stopBroadcast();
        console2.log(
            "CrossChainSender deployed to: ",
            address(crossChainSender)
        );
    }
}
