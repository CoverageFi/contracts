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
            helperConfig.getBaseSepoliaConfig().wormholeRelayer,
            helperConfig.getBaseSepoliaConfig().tokenBridge,
            helperConfig.getBaseSepoliaConfig().wormhole
        );
        crossChainReceiver.setRegisteredSender(
            helperConfig.getSepoliaConfig().wormholeChainId,
            bytes32(
                uint256(uint160(0x89AD215eF488E254B804162c83d6BC7DE0e1519c))
            )
        );
        vm.stopBroadcast();
        console2.log(
            "CrossChainReceiver deployed to: ",
            address(crossChainReceiver)
        );
    }
}
