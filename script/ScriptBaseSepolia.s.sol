// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import {Script, console2} from "forge-std/Script.sol";
import {CrossChainSender} from "../src/CrossChainSender.sol";
import {HelperConfig} from "./HelperConfig.s.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {ITokenBridge} from "lib/wormhole-solidity-sdk/src/interfaces/ITokenBridge.sol";

contract ScriptBaseSepolia is Script {
    HelperConfig public helperConfig;
    CrossChainSender public crossChainSender;

    function run() external {
        helperConfig = new HelperConfig();
        vm.startBroadcast();
        crossChainSender = CrossChainSender(
            0xc54Ea818b4e46c2F997266df36369eB8Ff24Ee8E
        );
        uint256 fee = crossChainSender.quoteCrossChainDeposit(
            helperConfig.getOPSepoliaConfig().wormholeChainId
        );
        IERC20(helperConfig.getBaseSepoliaConfig().usdc).approve(
            address(crossChainSender),
            3 * 1e6
        );
        crossChainSender.sendCrossChainDeposit{value: fee}(
            helperConfig.getOPSepoliaConfig().wormholeChainId,
            0x53885340cEc92Edf309AE5573ebfe4a561F609c0,
            0x6680dfD1c6A4867476b2e60dA89354AC93272878,
            3 * 1e6,
            helperConfig.getBaseSepoliaConfig().usdc
        );
        vm.stopBroadcast();
    }
}
