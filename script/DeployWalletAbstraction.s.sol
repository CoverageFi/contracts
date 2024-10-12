// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import {Script, console2} from "forge-std/Script.sol";
import {WalletAbstraction} from "../src/WalletAbstraction.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

contract DeployWalletAbstraction is Script {
    // Deployed on sepolia 0xAaD1191f2Ef0c86F7c9faebfC4C2142DD4485055
    HelperConfig public helperConfig;
    WalletAbstraction public walletAbstraction;

    function run() external {
        helperConfig = new HelperConfig();
        vm.startBroadcast();
        walletAbstraction = new WalletAbstraction(
            helperConfig.getSepoliaConfig().initialOwner
        );
        vm.stopBroadcast();
    }
}
