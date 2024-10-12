# CoverageFi 

## Table of Contents
- [CoverageFi](#coveragefi)
  - [Table of Contents](#table-of-contents)
  - [Cross-Chain Stablecoin Transfers](#cross-chain-stablecoin-transfers)
  - [Problem Statement](#problem-statement)
  - [Features](#features)
  - [Technologies Used](#technologies-used)
  - [Architecture Overview](#architecture-overview)
    - [1. WalletAbstraction Contract (WalletAbstraction.sol)](#1-walletabstraction-contract-walletabstractionsol)
    - [2. CrossChainSender Contract (CrossChainSender.sol)](#2-crosschainsender-contract-crosschainsendersol)
    - [3. CrossChainReceiver Contract (CrossChainReceiver.sol)](#3-crosschainreceiver-contract-crosschainreceiversol)
  - [Smart Contracts](#smart-contracts)
    - [WalletAbstraction Contract](#walletabstraction-contract)
    - [CrossChainSender Contract](#crosschainsender-contract)
    - [CrossChainReceiver Contract](#crosschainreceiver-contract)
  - [Roadmap](#roadmap)
  - [License](#license)

## Cross-Chain Stablecoin Transfers
CoverageFi is a Web3 application designed to simplify stablecoin transfers by allowing users to send and receive digital dollars (USDC) across different blockchain networks. Users can easily send crypto to vendors or peers by scanning a QR code or entering a wallet address. CoverageFi supports cross-chain transfers using Wormhole's Cross-chain Token Transfer and Cross-chain Message Transfer to ensure seamless token movement between chains.

## Problem Statement
CoverageFi addresses the challenge of providing **global access to digital dollars**. This project offers financial stability to users worldwide by enabling them to hold and transact stablecoins without needing a traditional bank account. CoverageFi makes it easy for individuals and businesses to move funds across blockchain networks, leveraging decentralized finance to reach users anywhere.

---

## Features

- **User Registration and Management**: Users can register with unique usernames and manage their identities across chains.
- **Simple Token Transfers**: Users can send stablecoins (USDC) to anyone by scanning a QR code or entering an address.
- **Cross-Chain Transfers**: Transfer stablecoins across multiple chains, including Ethereum, Avalanche, and Celo, using Wormhole's Cross-chain Token Transfer.
- **Non-Custodial Wallet Support**: Circle User-Controlled Wallets
- **User Mapping**: Each user is assigned a unique ID for tracking transactions in the smart contracts, while usernames are managed in the frontend.
- **Stable Store of Value**: Provides users worldwide with access to stablecoins for holding and transacting, offering financial stability in volatile markets.

---

## Technologies Used

- **Blockchain Networks**: Sepolia, Avalanche-Fuji, Celo-Alfajores, Optimism sepolia, Base sepolia
- **Cross-Chain Technology**: Wormhole Cross-chain Token Transfer and Cross-chain Message Transfer
- **Smart Contracts**: Solidity
- **Developer Framework**: Foundry
- **Frontend**: Next.js, TailwindCSS, shadcn
- **Wallet Integration**: Circle User-Controlled Wallets
- **Token Support**: USDC
- **Libraries**: OpenZeppelin and Wormhole

---

## Architecture Overview

The architecture consists of the following smart contracts:

### 1. WalletAbstraction Contract (WalletAbstraction.sol)

- Manages user registration and mapping of user information like usernames and addresses.
- Assigns unique user IDs to registered users.
- Provides functions to retrieve user information and check registration status.

### 2. CrossChainSender Contract (CrossChainSender.sol)

- Handles the initiation of cross-chain token transfers.
- Interacts with Wormhole's Cross-chain Token Transfer to send tokens to other chains.
- Manages the locking and burning of tokens on the source chain.

### 3. CrossChainReceiver Contract (CrossChainReceiver.sol)

- Receives and processes incoming cross-chain token transfers.
- Verifies the validity of incoming transfers using Wormhole's protocol.
- Mints or unlocks tokens on the destination chain and distributes them to the intended recipients.

---

## Smart Contracts

### WalletAbstraction Contract
This contract serves as the foundation for user management within the CoverageFi ecosystem. It allows users to register with unique usernames, maps addresses to user IDs, and provides functions to retrieve user information. Key features include:

- User registration with unique usernames
- Mapping of user addresses to User structs
- Mapping of user IDs to addresses
- Username to address mapping
- Functions to get user information and check registration status

### CrossChainSender Contract
This contract facilitates the initiation of cross-chain token transfers using Wormhole's Cross-chain Token Transfer. It handles the process of locking or burning tokens on the source chain and preparing them for transfer to the destination chain.

### CrossChainReceiver Contract
This contract is responsible for receiving and processing incoming cross-chain token transfers. It verifies the validity of transfers using Wormhole's protocol, mints or unlocks tokens on the destination chain, and ensures they are correctly distributed to the intended recipients.

## Roadmap

- Multi-token support: Add more stablecoins and tokens based on user needs.
- Expanded network support: Support additional blockchain networks beyond Ethereum, Avalanche, and Celo.
- Cross-chain Integration: Enhance cross-chain functionality using Wormhole's Cross-chain Token Transfer and Cross-chain Message Transfer.
- QR Code Payments: Implement QR code-based payments for vendors.
- Mobile App: Release a mobile version of CoverageFi for broader adoption.
- Advanced User Features: Implement additional features like transaction history, balance tracking across chains, and user profile management.

## License
This project is licensed under the MIT License - see the LICENSE file for details.