// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract TokenTransfer is Ownable, ReentrancyGuard {
    using SafeERC20 for IERC20;

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

    constructor(address InitialOwner) Ownable(InitialOwner) {
        crossChainManagerAddress = address(0);
    }
}
