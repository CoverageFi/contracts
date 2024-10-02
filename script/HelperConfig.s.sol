// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import { Script, console2 } from "forge-std/Script.sol";

contract HelperConfig is Script {
    error HelperConfig__InvalidChainId();

    struct NetworkConfig {
        address initialOwner;
        address crossChainManagerAddress;
    }

    /*//////////////////////////////////////////////////////////////
                                CONFIGS
    //////////////////////////////////////////////////////////////*/

    function getSepoliaConfig() public view returns (NetworkConfig memory) {
        NetworkConfig memory SepoliaConfig =
            NetworkConfig({ initialOwner: msg.sender, crossChainManagerAddress: address(0) });
        return SepoliaConfig;
    }

    function getBaseSepoliaConfig() public view returns (NetworkConfig memory) {
        return NetworkConfig({ initialOwner: msg.sender, crossChainManagerAddress: address(0) });
    }

    function getOPSepoliaConfig() public view returns (NetworkConfig memory) {
        return NetworkConfig({ initialOwner: msg.sender, crossChainManagerAddress: address(0) });
    }

    /*//////////////////////////////////////////////////////////////
                              LOCAL CONFIG
    //////////////////////////////////////////////////////////////*/
    function getAnvilConfig() public pure returns (NetworkConfig memory) {
        console2.log("Testing On Anvil Network");
        NetworkConfig memory AnvilConfig =
            NetworkConfig({ initialOwner: address(1), crossChainManagerAddress: address(0) });
        return AnvilConfig;
    }
}
