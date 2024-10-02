// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
import { ReentrancyGuard } from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import { SafeERC20 } from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

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

    struct User {
        uint256 userId;
        string username;
        bool isRegistered;
    }

    mapping(address => User) private users;
    mapping(uint256 => address) private userIdToAddress;
    mapping(string => address) private usernameToAddress;

    uint256 private nextUserId = 1;
    address public crossChainManagerAddress;

    event TokenTransferred(address indexed from, address indexed to, address indexed token, uint256 amount);
    event UserRegistered(address indexed userAddress, uint256 indexed userId, string username);
    event CrossChainManagerUpdated(address indexed newManager);

    modifier onlyCrossChainManager() {
        require(msg.sender == crossChainManagerAddress, OnlyCrossChainManagerCanCall());
        _;
    }

    constructor(address InitialOwner) Ownable(InitialOwner) {
        crossChainManagerAddress = address(0);
    }

    function setCrossChainManager(address _manager) external onlyOwner {
        require(_manager != address(0), InvalidManagerAddress());
        crossChainManagerAddress = _manager;
        emit CrossChainManagerUpdated(_manager);
    }

    function registerUser(string memory _username) external {
        require(!users[msg.sender].isRegistered, UserAlreadyRegistered());
        require(usernameToAddress[_username] == address(0), UsernameAlreadyTaken());
        require(bytes(_username).length > 0 && bytes(_username).length <= 20, InvalidUsernameLength());

        uint256 userId = nextUserId++;
        users[msg.sender] = User(userId, _username, true);
        userIdToAddress[userId] = msg.sender;
        usernameToAddress[_username] = msg.sender;

        emit UserRegistered(msg.sender, userId, _username);
    }

    function transferToken(address _token, address _recipient, uint256 _amount) external nonReentrant {
        require(users[msg.sender].isRegistered, UserNotRegistered());
        require(users[_recipient].isRegistered, RecipientNotRegistered());
        require(_amount > 0, AmountMustBeGreaterThanZero());

        IERC20(_token).safeTransferFrom(msg.sender, _recipient, _amount);
        emit TokenTransferred(msg.sender, _recipient, _token, _amount);
    }

    function transferTokenWithUsername(
        address _token,
        string memory _username,
        uint256 _amount
    )
        external
        nonReentrant
    {
        require(users[msg.sender].isRegistered, UserNotRegistered());
        address recipient = usernameToAddress[_username];
        require(recipient != address(0), RecipientNotRegistered());
        require(_amount > 0, AmountMustBeGreaterThanZero());

        IERC20(_token).safeTransferFrom(msg.sender, recipient, _amount);
        emit TokenTransferred(msg.sender, recipient, _token, _amount);
    }

    function transferTokenCrossChain(
        address _token,
        uint256 _userId,
        uint256 _amount
    )
        external
        onlyCrossChainManager
        nonReentrant
    {
        address recipient = userIdToAddress[_userId];
        require(recipient != address(0), RecipientNotRegistered());
        require(_amount > 0, AmountMustBeGreaterThanZero());

        IERC20(_token).safeTransfer(recipient, _amount);
        emit TokenTransferred(address(this), recipient, _token, _amount);
    }

    function getUserId(address _userAddress) external view returns (uint256) {
        require(users[_userAddress].isRegistered, UserNotRegistered());
        return users[_userAddress].userId;
    }

    function getUserAddress(uint256 _userId) external view returns (address) {
        address userAddress = userIdToAddress[_userId];
        require(userAddress != address(0), UserNotRegistered());
        return userAddress;
    }

    function getUsername(address _userAddress) external view returns (string memory) {
        require(users[_userAddress].isRegistered, UserNotRegistered());
        return users[_userAddress].username;
    }

    function isUserRegistered(address _userAddress) external view returns (bool) {
        return users[_userAddress].isRegistered;
    }
}
