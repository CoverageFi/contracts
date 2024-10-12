// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

/**
 * @title WalletAbstraction
 * @author CoverageFi
 * @notice A contract for managing user registration and mapping of user information like usernames and addresses.
 * @dev Inherits from Ownable for access control and ReentrancyGuard for security against reentrancy attacks.
 */

contract WalletAbstraction is Ownable, ReentrancyGuard {
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

    /// @dev Emitted when a new user is registered
    event UserRegistered(
        address indexed userAddress,
        uint256 indexed userId,
        string username
    );

    /**
     * @notice Initializes the contract with an initial owner
     * @param InitialOwner The address to be set as the initial owner of the contract
     */
    constructor(address InitialOwner) Ownable(InitialOwner) {}

    /**
     * @notice Registers a new user with a unique username
     * @param _username The desired username for the new user
     */
    function registerUser(
        string memory _username
    ) external returns (uint256 userId) {
        require(!users[msg.sender].isRegistered, UserAlreadyRegistered());
        require(
            usernameToAddress[_username] == address(0),
            UsernameAlreadyTaken()
        );
        require(
            bytes(_username).length > 0 && bytes(_username).length <= 20,
            InvalidUsernameLength()
        );

        userId = nextUserId++;
        users[msg.sender] = User(userId, _username, true);
        userIdToAddress[userId] = msg.sender;
        usernameToAddress[_username] = msg.sender;

        emit UserRegistered(msg.sender, userId, _username);
        return userId;
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
