// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import { Script, console2 } from "forge-std/Script.sol";
import { CrossChainReceiver } from "../src/CrossChainReceiver.sol";
import { HelperConfig } from "./HelperConfig.s.sol";

contract DeployCrossChainReceiver is Script {
    // Deployed on Arb sepolia 0x847a6c5a32F5Ed69c43a82f46a84Df75f9B9Bd2A
    // Deployed on Base sepolia 0xe3F3Fb3a7a5B046298817f0AB073a659f68cbdB3
    HelperConfig public helperConfig;
    CrossChainReceiver public crossChainReceiver;

    function run() external {
        helperConfig = new HelperConfig();
        vm.startBroadcast();
        crossChainReceiver = new CrossChainReceiver(
            helperConfig.getBaseSepoliaConfig().wormholeRelayer,
            helperConfig.getBaseSepoliaConfig().tokenBridge,
            helperConfig.getBaseSepoliaConfig().wormhole
        );
        crossChainReceiver.setRegisteredSender(
            helperConfig.getSepoliaConfig().wormholeChainId,
            bytes32(uint256(uint160(0x497047952A7F275B48D097cB0e8b7Ad843100a2A)))
        );
        vm.stopBroadcast();
        console2.log("CrossChainReceiver deployed to: ", address(crossChainReceiver));
    }
}
