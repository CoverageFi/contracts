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
            helperConfig.getOPSepoliaConfig().wormholeRelayer,
            helperConfig.getOPSepoliaConfig().tokenBridge,
            helperConfig.getOPSepoliaConfig().wormhole
        );
        crossChainReceiver.setRegisteredSender(
            helperConfig.getBaseSepoliaConfig().wormholeChainId,
            bytes32(
                uint256(uint160(0xc54Ea818b4e46c2F997266df36369eB8Ff24Ee8E))
            )
        );
        vm.stopBroadcast();
        console2.log(
            "CrossChainReceiver deployed to: ",
            address(crossChainReceiver)
        );
    }
}
