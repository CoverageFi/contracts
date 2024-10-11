// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script, console2} from "forge-std/Script.sol";
import {HelloUSDC} from "../src/HelloUSDC.sol";
import {HelperConfig} from "./HelperConfig.s.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract BaseSepolia is Script {
    HelloUSDC public helloUSDCSource;
    HelperConfig public helperConfig;

    function run() external {
        helperConfig = new HelperConfig();
        vm.startBroadcast();
        helloUSDCSource = HelloUSDC(0xbFB1454E669e0E0dE3E78Bf07dA131f36D276516);
        helloUSDCSource.setRegisteredSender(
            helperConfig.getBaseSepoliaConfig().wormholeChainId,
            bytes32(
                uint256(
                    uint160(address(0xc5A85312f910476A0cd6AFbDA85e3017C016803B))
                )
            )
        );
        uint256 fee = helloUSDCSource.quoteCrossChainDeposit(
            helperConfig.getOPSepoliaConfig().wormholeChainId
        );
        IERC20(helperConfig.getBaseSepoliaConfig().usdc).approve(
            0xbFB1454E669e0E0dE3E78Bf07dA131f36D276516,
            2 * 1e6
        );
        helloUSDCSource.sendCrossChainDeposit{value: fee}(
            helperConfig.getOPSepoliaConfig().wormholeChainId,
            helperConfig.getOPSepoliaConfig().usdc,
            0x6680dfD1c6A4867476b2e60dA89354AC93272878,
            2 * 1e6
        );
        //  uint16 targetChain,
        // address targetHelloUSDC,
        // address recipient,
        // uint256 amount
        vm.stopBroadcast();
    }
}
