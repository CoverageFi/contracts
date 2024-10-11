// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script, console2} from "forge-std/Script.sol";
import {HelloUSDC} from "../src/HelloUSDC.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

contract DeployHelloUSDCBase is Script {
    //Deployed on base sepolia 0xbFB1454E669e0E0dE3E78Bf07dA131f36D276516
    HelloUSDC public helloUSDCSource;
    HelperConfig public helperConfig;

    function run() external {
        helperConfig = new HelperConfig();
        vm.startBroadcast();
        helloUSDCSource = new HelloUSDC(
            helperConfig.getBaseSepoliaConfig().wormholeRelayer,
            helperConfig.getBaseSepoliaConfig().wormhole,
            helperConfig.getBaseSepoliaConfig().messageTransmitter,
            helperConfig.getBaseSepoliaConfig().tokenMessenger,
            helperConfig.getBaseSepoliaConfig().usdc
        );
        vm.stopBroadcast();
    }
}
