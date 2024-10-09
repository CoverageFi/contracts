// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import {Test, console2} from "forge-std/Test.sol";
import {HelperConfig} from "../../../script/HelperConfig.s.sol";
import {CrossChainSender} from "../../../src/CrossChainSender.sol";
import {CrossChainReceiver} from "../../../src/CrossChainReceiver.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract TestCrossChainTokenTransfer is Test {
    address public owner = address(1);
    address public recipient = address(2);
    uint256 public baseSepoliaFork;
    uint256 public opSepoliaFork;
    HelperConfig public helperConfig;
    CrossChainSender public crossChainSender;
    CrossChainReceiver public crossChainReceiver;

    function setUp() public {
        helperConfig = new HelperConfig();
        baseSepoliaFork = vm.createFork(vm.envString("BASE_SEPOLIA_RPC_URL"));
        opSepoliaFork = vm.createFork(vm.envString("OP_SEPOLIA_RPC_URL"));
        vm.startPrank(owner);
        vm.selectFork(baseSepoliaFork);
        vm.deal(owner, 1 ether);
        deal(helperConfig.getBaseSepoliaConfig().usdc, owner, 100 * 1e6);
        crossChainSender = new CrossChainSender(
            helperConfig.getBaseSepoliaConfig().wormholeRelayer,
            helperConfig.getBaseSepoliaConfig().tokenBridge,
            helperConfig.getBaseSepoliaConfig().wormhole
        );
        vm.selectFork(opSepoliaFork);
        crossChainReceiver = new CrossChainReceiver(
            helperConfig.getOPSepoliaConfig().wormholeRelayer,
            helperConfig.getOPSepoliaConfig().tokenBridge,
            helperConfig.getOPSepoliaConfig().wormhole
        );
        crossChainReceiver.setRegisteredSender(
            helperConfig.getBaseSepoliaConfig().wormholeChainId,
            bytes32(uint256(uint160(address(crossChainSender))))
        );
        vm.makePersistent(
            owner,
            address(crossChainSender),
            address(crossChainReceiver)
        );
        vm.stopPrank();
    }

    function testSendUSDC() public {
        vm.selectFork(baseSepoliaFork);
        uint256 fee = crossChainSender.quoteCrossChainDeposit(
            helperConfig.getOPSepoliaConfig().wormholeChainId
        );
        vm.startPrank(owner);
        IERC20(helperConfig.getBaseSepoliaConfig().usdc).approve(
            address(crossChainSender),
            3 * 1e6
        );

        vm.stopPrank();
        vm.startPrank(owner);
        crossChainSender.sendCrossChainDeposit{value: fee}(
            helperConfig.getOPSepoliaConfig().wormholeChainId,
            address(crossChainReceiver),
            address(recipient),
            3 * 1e6,
            helperConfig.getBaseSepoliaConfig().usdc
        );
        vm.stopPrank();
    }

    function test_two() public {}
}
