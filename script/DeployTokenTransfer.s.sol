// // SPDX-License-Identifier: MIT
// pragma solidity ^0.8.8;

// import {Script, console2} from "forge-std/Script.sol";
// import {TokenTransfer} from "../src/WalletAbstraction.sol";
// import {HelperConfig} from "./HelperConfig.s.sol";

// contract DeployTokenTransfer is Script {
//     function run() external returns (TokenTransfer) {
//         HelperConfig helperConfig = new HelperConfig();
//         HelperConfig.NetworkConfig memory config;

//         if (block.chainid == 11_155_111) {
//             config = helperConfig.getSepoliaConfig();
//         } else if (block.chainid == 84_532) {
//             config = helperConfig.getBaseSepoliaConfig();
//         } else if (block.chainid == 11_155_420) {
//             config = helperConfig.getOPSepoliaConfig();
//         } else {
//             revert("unsupported network");
//         }

//         vm.startBroadcast();
//         TokenTransfer tokenTransfer = new TokenTransfer(
//             config.initialOwner,
//             config.tokenBridge
//         );
//         vm.stopBroadcast();

//         console2.log("TokenTransfer deployed to: ", address(tokenTransfer));
//         console2.log("InitialOwner: ", config.initialOwner);
//         console2.log("CrossChainManager: ", config.tokenBridge);

//         return tokenTransfer;
//     }
// }
