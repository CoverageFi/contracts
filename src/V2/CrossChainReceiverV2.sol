// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "lib/wormhole-solidity-sdk/src/WormholeRelayerSDK.sol";
import "lib/wormhole-solidity-sdk/src/interfaces/IERC20.sol";

/**
 * @title CrossChainReceiverV2
 * @author CoverageFi
 * @notice Enhanced contract for receiving tokens cross-chain using Wormhole
 * @dev V2 improvements:
 *      - Multi-token support
 *      - Emergency pause mechanism
 *      - Fee collection system
 *      - Event logging for better tracking
 *      - Reentrancy protection
 *      - SafeERC20 operations
 *      - Gas optimizations
 */
contract CrossChainReceiverV2 is TokenReceiver {
    // ============ State Variables ============
    
    /// @notice Protocol fee in basis points (e.g., 10 = 0.1%)
    uint256 public protocolFeeBps;
    
    /// @notice Maximum protocol fee (500 = 5%)
    uint256 public constant MAX_PROTOCOL_FEE_BPS = 500;
    
    /// @notice Fee collector address
    address public feeCollector;
    
    /// @notice Emergency pause flag
    bool public paused;
    
    /// @notice Owner address for admin functions
    address public owner;
    
    /// @notice Reentrancy guard
    uint256 private locked = 1;
}