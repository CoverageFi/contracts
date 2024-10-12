// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import {Script, console2} from "forge-std/Script.sol";

contract HelperConfig is Script {
    error HelperConfig__InvalidChainId();

    struct NetworkConfig {
        address initialOwner;
        uint16 wormholeChainId;
        address wormholeRelayer;
        address tokenBridge;
        address wormhole;
        address usdc;
    }

    /*//////////////////////////////////////////////////////////////
                                CONFIGS
    //////////////////////////////////////////////////////////////*/

    function getSepoliaConfig() public view returns (NetworkConfig memory) {
        NetworkConfig memory SepoliaConfig = NetworkConfig({
            initialOwner: msg.sender,
            wormholeChainId: 10002,
            wormholeRelayer: 0x7B1bD7a6b4E61c2a123AC6BC2cbfC614437D0470,
            tokenBridge: 0xDB5492265f6038831E89f495670FF909aDe94bd9,
            wormhole: 0x4a8bc80Ed5a4067f1CCf107057b8270E0cC11A78,
            usdc: 0x1c7D4B196Cb0C7B01d743Fbc6116a902379C7238
        });
        return SepoliaConfig;
    }

    function getBaseSepoliaConfig() public view returns (NetworkConfig memory) {
        return
            NetworkConfig({
                initialOwner: msg.sender,
                wormholeChainId: 10004,
                wormholeRelayer: 0x93BAD53DDfB6132b0aC8E37f6029163E63372cEE,
                tokenBridge: 0x86F55A04690fd7815A3D802bD587e83eA888B239,
                wormhole: 0x79A1027a6A159502049F10906D333EC57E95F083,
                usdc: 0x036CbD53842c5426634e7929541eC2318f3dCF7e
            });
    }

    function getOPSepoliaConfig() public view returns (NetworkConfig memory) {
        return
            NetworkConfig({
                initialOwner: msg.sender,
                wormholeChainId: 10005,
                wormholeRelayer: 0x93BAD53DDfB6132b0aC8E37f6029163E63372cEE,
                tokenBridge: 0x99737Ec4B815d816c49A385943baf0380e75c0Ac,
                wormhole: 0x31377888146f3253211EFEf5c676D41ECe7D58Fe,
                usdc: 0x5fd84259d66Cd46123540766Be93DFE6D43130D7
            });
    }

    function getArbSepoliaConfig() public view returns (NetworkConfig memory) {
        return
            NetworkConfig({
                initialOwner: msg.sender,
                wormholeChainId: 10003,
                wormholeRelayer: 0x7B1bD7a6b4E61c2a123AC6BC2cbfC614437D0470,
                tokenBridge: 0xC7A204bDBFe983FCD8d8E61D02b475D4073fF97e,
                wormhole: 0x6b9C8671cdDC8dEab9c719bB87cBd3e782bA6a35,
                usdc: 0x75faf114eafb1BDbe2F0316DF893fd58CE46AA4d
            });
    }

    function getAvalancheFujiConfig()
        public
        view
        returns (NetworkConfig memory)
    {
        return
            NetworkConfig({
                initialOwner: msg.sender,
                wormholeChainId: 6,
                wormholeRelayer: 0xA3cF45939bD6260bcFe3D66bc73d60f19e49a8BB,
                tokenBridge: 0x61E44E506Ca5659E6c0bba9b678586fA2d729756,
                wormhole: 0x7bbcE28e64B3F8b84d876Ab298393c38ad7aac4C,
                usdc: 0x5425890298aed601595a70AB815c96711a31Bc65
            });
    }

    /*//////////////////////////////////////////////////////////////
                              LOCAL CONFIG
    //////////////////////////////////////////////////////////////*/
    function getAnvilConfig() public view returns (NetworkConfig memory) {
        console2.log("Testing On Anvil Network");
        NetworkConfig memory AnvilConfig = NetworkConfig({
            initialOwner: msg.sender,
            wormholeChainId: 0,
            wormholeRelayer: address(0),
            tokenBridge: address(0),
            wormhole: address(0),
            usdc: address(0)
        });
        return AnvilConfig;
    }
}
