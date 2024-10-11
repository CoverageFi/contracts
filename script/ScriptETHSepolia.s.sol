// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import {Script, console2} from "forge-std/Script.sol";
import {CrossChainSender} from "../src/CrossChainSender.sol";
import {HelperConfig} from "./HelperConfig.s.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {ITokenBridge} from "lib/wormhole-solidity-sdk/src/interfaces/ITokenBridge.sol";

contract ScriptETHSepolia is Script {
    HelperConfig public helperConfig;
    CrossChainSender public crossChainSender;

    function run() external {
        helperConfig = new HelperConfig();
        vm.startBroadcast();
        crossChainSender = CrossChainSender(
            0x89AD215eF488E254B804162c83d6BC7DE0e1519c
        );
        uint256 fee = crossChainSender.quoteCrossChainDeposit(
            helperConfig.getBaseSepoliaConfig().wormholeChainId
        );
        IERC20(helperConfig.getSepoliaConfig().usdc).approve(
            address(crossChainSender),
            1 * 1e6
        );
        crossChainSender.sendCrossChainDeposit{value: fee}(
            helperConfig.getBaseSepoliaConfig().wormholeChainId,
            0xC6Ab09b398BDae7b8A473faD24F4773d4f8Aa47a,
            0x12B2434a1022d5787bf06056F2885Fe35De62Bf8,
            1 * 1e6,
            helperConfig.getSepoliaConfig().usdc
        );
        vm.stopBroadcast();
    }
}
