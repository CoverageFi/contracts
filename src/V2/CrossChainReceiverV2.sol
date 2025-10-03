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

    // ============ Events ============

    event TokensReceived(
        uint16 indexed sourceChain,
        bytes32 indexed sourceAddress,
        address indexed recipient,
        address[] tokens,
        uint256[] amounts,
        uint256 timestamp
    );

    event ProtocolFeeCollected(address indexed token, uint256 amount, address indexed collector);

    event ProtocolFeeUpdated(uint256 oldFee, uint256 newFee);
    event FeeCollectorUpdated(address oldCollector, address newCollector);
    event Paused(address account);
    event Unpaused(address account);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    // ============ Errors ============

    error Unauthorized();
    error ContractPaused();
    error InvalidFee();
    error InvalidAddress();
    error NoTokensReceived();
    error TransferFailed();
    error ReentrancyGuard();

    // ============ Modifiers ============

    modifier onlyOwner() {
        if (msg.sender != owner) revert Unauthorized();
        _;
    }

    modifier whenNotPaused() {
        if (paused) revert ContractPaused();
        _;
    }

    modifier nonReentrant() {
        if (locked != 1) revert ReentrancyGuard();
        locked = 2;
        _;
        locked = 1;
    }
    // ============ Constructor ============

    constructor(
        address _wormholeRelayer,
        address _tokenBridge,
        address _wormhole,
        address _feeCollector,
        uint256 _protocolFeeBps
    )
        TokenBase(_wormholeRelayer, _tokenBridge, _wormhole)
    {
        if (_feeCollector == address(0)) revert InvalidAddress();
        if (_protocolFeeBps > MAX_PROTOCOL_FEE_BPS) revert InvalidFee();

        owner = msg.sender;
        feeCollector = _feeCollector;
        protocolFeeBps = _protocolFeeBps;

        emit OwnershipTransferred(address(0), msg.sender);
    }

    // ============ Main Functions ============

    /**
     * @notice Receives cross-chain payload and tokens with enhanced validation
     * @dev Supports multiple tokens and protocol fee collection
     */
    function receivePayloadAndTokens(
        bytes memory payload,
        TokenReceived[] memory receivedTokens,
        bytes32 sourceAddress,
        uint16 sourceChain,
        bytes32 // deliveryHash
    )
        internal
        override
        onlyWormholeRelayer
        isRegisteredSender(sourceChain, sourceAddress)
        whenNotPaused
        nonReentrant
    {
        if (receivedTokens.length == 0) revert NoTokensReceived();

        // Decode recipient and optional custom logic flag
        (address recipient, bool directTransfer) = abi.decode(payload, (address, bool));
        if (recipient == address(0)) revert InvalidAddress();

        uint256 tokenCount = receivedTokens.length;
        address[] memory tokens = new address[](tokenCount);
        uint256[] memory amounts = new uint256[](tokenCount);

        // Process each token
        for (uint256 i = 0; i < tokenCount; i++) {
            TokenReceived memory token = receivedTokens[i];
            tokens[i] = token.tokenAddress;

            // Calculate protocol fee
            uint256 fee = 0;
            if (protocolFeeBps > 0) {
                fee = (token.amount * protocolFeeBps) / 10_000;

                // Transfer fee to collector
                if (fee > 0) {
                    _safeTransfer(token.tokenAddress, feeCollector, fee);
                    emit ProtocolFeeCollected(token.tokenAddress, fee, feeCollector);
                }
            }

            // Calculate amount after fee
            uint256 amountAfterFee = token.amount - fee;
            amounts[i] = amountAfterFee;

            if (directTransfer) {
                // Direct transfer to recipient
                _safeTransfer(token.tokenAddress, recipient, amountAfterFee);
            } else {
                // Approve recipient to pull tokens (useful for contract recipients)
                IERC20(token.tokenAddress).approve(recipient, amountAfterFee);
            }
        }

        emit TokensReceived(sourceChain, sourceAddress, recipient, tokens, amounts, block.timestamp);
    }
}
