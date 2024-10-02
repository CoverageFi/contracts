// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import { Script } from "forge-std/Script.sol";
import { TokenTransfer } from "../src/TokenTransfer/TokenTransfer.sol";
import { HelperConfig } from "./HelperConfig.s.sol";

contract DeployTokenTransfer is Script {
    function run() external returns (TokenTransfer) {
        HelperConfig config = new HelperConfig();
    }
}
