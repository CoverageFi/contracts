// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

import {Script, console2} from "forge-std/Script.sol";
import {HelloUSDC} from "../src/HelloUSDC.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

contract DeployHelloUSDCOp is Script {
    HelloUSDC public helloUSDCTarget;
    HelperConfig public helperConfig;

    function run() external {
        // Deployed on op sepolia 0xc5A85312f910476A0cd6AFbDA85e3017C016803B
        helperConfig = new HelperConfig();
        vm.startBroadcast();
        helloUSDCTarget = HelloUSDC(0xc5A85312f910476A0cd6AFbDA85e3017C016803B);
        helloUSDCTarget.setRegisteredSender(
            helperConfig.getBaseSepoliaConfig().wormholeChainId,
            bytes32(
                uint256(
                    uint160(address(0xbFB1454E669e0E0dE3E78Bf07dA131f36D276516))
                )
            )
        );
        vm.stopBroadcast();
    }
}
