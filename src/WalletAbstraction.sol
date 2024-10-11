// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

/// @title TokenTransfer
/// @notice A contract for managing user registration and token transfers, including cross-chain capabilities
/// @dev Inherits from Ownable for access control and ReentrancyGuard for security against reentrancy attacks
contract TokenTransfer is Ownable, ReentrancyGuard {
    using SafeERC20 for IERC20;

    error OnlyCrossChainManagerCanCall();
    error InvalidManagerAddress();
    error UserAlreadyRegistered();
    error UsernameAlreadyTaken();
    error InvalidUsernameLength();
    error UserNotRegistered();
    error RecipientNotRegistered();
    error AmountMustBeGreaterThanZero();

    /// @dev Structure to store user information, used in the users mapping to keep track of registered users
    struct User {
        uint256 userId;
        string username;
        bool isRegistered;
    }

    /// @dev Mapping of user addresses to their User struct
    mapping(address => User) private users;

    /// @dev Mapping of user IDs to their addresses
    mapping(uint256 => address) private userIdToAddress;

    /// @dev Mapping of usernames to their addresses
    mapping(string => address) private usernameToAddress;

    /// @dev The next available user ID
    uint256 private nextUserId = 1;

    /// @dev The address of the CrossChainManager contract
    address public crossChainManagerAddress;

    /// @dev Emitted when a token transfer occurs
    event TokenTransferred(
        address indexed from,
        address indexed to,
        address indexed token,
        uint256 amount
    );

    /// @dev Emitted when a new user is registered
    event UserRegistered(
        address indexed userAddress,
        uint256 indexed userId,
        string username
    );

    /// @dev Emitted when the CrossChainManager address is updated
    event CrossChainManagerUpdated(address indexed newManager);

    /// @dev Restricts function access to the CrossChainManager
    modifier onlyCrossChainManager() {
        require(
            msg.sender == crossChainManagerAddress,
            OnlyCrossChainManagerCanCall()
        );
        _;
    }

    /**
     * @notice Initializes the contract with an initial owner
     * @param InitialOwner The address to be set as the initial owner of the contract
     */
    constructor(
        address InitialOwner,
        address _crossChainManager
    ) Ownable(InitialOwner) {
        crossChainManagerAddress = _crossChainManager;
    }

    /**
     * @notice Sets the address of the CrossChainManager contract
     * @dev Can only be called by the contract owner
     * @param _manager The address of the new CrossChainManager contract
     */
    function setCrossChainManager(address _manager) external onlyOwner {
        require(_manager != address(0), InvalidManagerAddress());
        crossChainManagerAddress = _manager;
        emit CrossChainManagerUpdated(_manager);
    }

    /**
     * @notice Registers a new user with a unique username
     * @param _username The desired username for the new user
     */
    function registerUser(string memory _username) external {
        require(!users[msg.sender].isRegistered, UserAlreadyRegistered());
        require(
            usernameToAddress[_username] == address(0),
            UsernameAlreadyTaken()
        );
        require(
            bytes(_username).length > 0 && bytes(_username).length <= 20,
            InvalidUsernameLength()
        );

        uint256 userId = nextUserId++;
        users[msg.sender] = User(userId, _username, true);
        userIdToAddress[userId] = msg.sender;
        usernameToAddress[_username] = msg.sender;

        emit UserRegistered(msg.sender, userId, _username);
    }

    /**
     * @notice Transfers tokens from the sender to a recipient using addresses
     * @param _token The address of the token to transfer
     * @param _recipient The address of the recipient
     * @param _amount The amount of tokens to transfer
     */
    function transferToken(
        address _token,
        address _recipient,
        uint256 _amount
    ) external nonReentrant {
        require(users[msg.sender].isRegistered, UserNotRegistered());
        require(users[_recipient].isRegistered, RecipientNotRegistered());
        require(_amount > 0, AmountMustBeGreaterThanZero());

        IERC20(_token).safeTransferFrom(msg.sender, _recipient, _amount);
        emit TokenTransferred(msg.sender, _recipient, _token, _amount);
    }

    /**
     * @notice Transfers tokens from the sender to a recipient using the recipient's username
     * @param _token The address of the token to transfer
     * @param _username The username of the recipient
     * @param _amount The amount of tokens to transfer
     */
    function transferTokenWithUsername(
        address _token,
        string memory _username,
        uint256 _amount
    ) external nonReentrant {
        require(users[msg.sender].isRegistered, UserNotRegistered());
        address recipient = usernameToAddress[_username];
        require(recipient != address(0), RecipientNotRegistered());
        require(_amount > 0, AmountMustBeGreaterThanZero());

        IERC20(_token).safeTransferFrom(msg.sender, recipient, _amount);
        emit TokenTransferred(msg.sender, recipient, _token, _amount);
    }

    /**
     * @notice Transfers tokens to a recipient as part of a cross-chain transaction
     * @dev Can only be called by the CrossChainManager contract
     * @param _token The address of the token to transfer
     * @param _userId The user ID of the recipient
     * @param _amount The amount of tokens to transfer
     */
    function transferTokenCrossChain(
        address _token,
        uint256 _userId,
        uint256 _amount
    ) external onlyCrossChainManager nonReentrant {
        address recipient = userIdToAddress[_userId];
        require(recipient != address(0), RecipientNotRegistered());
        require(_amount > 0, AmountMustBeGreaterThanZero());

        IERC20(_token).safeTransfer(recipient, _amount);
        emit TokenTransferred(address(this), recipient, _token, _amount);
    }

    /**
     * @notice Retrieves the user ID for a given address
     * @param _userAddress The address of the user
     * @return The user ID associated with the given address
     */
    function getUserId(address _userAddress) external view returns (uint256) {
        require(users[_userAddress].isRegistered, UserNotRegistered());
        return users[_userAddress].userId;
    }

    /**
     * @notice Retrieves the address associated with a given user ID
     * @param _userId The user ID to look up
     * @return The address associated with the given user ID
     */
    function getUserAddress(uint256 _userId) external view returns (address) {
        address userAddress = userIdToAddress[_userId];
        require(userAddress != address(0), UserNotRegistered());
        return userAddress;
    }

    /**
     * @notice Retrieves the username for a given address
     * @param _userAddress The address of the user
     * @return The username associated with the given address
     */
    function getUsername(
        address _userAddress
    ) external view returns (string memory) {
        require(users[_userAddress].isRegistered, UserNotRegistered());
        return users[_userAddress].username;
    }

    /**
     * @notice Checks if a given address is registered as a user
     * @param _userAddress The address to check
     * @return A boolean indicating whether the address is registered
     */
    function isUserRegistered(
        address _userAddress
    ) external view returns (bool) {
        return users[_userAddress].isRegistered;
    }
}
