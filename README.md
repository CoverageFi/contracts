# CoverageFi 

## Table of Contents
- [CoverageFi](#coveragefi)
  - [Table of Contents](#table-of-contents)
  - [Cross-Chain Stablecoin Transfers](#cross-chain-stablecoin-transfers)
  - [Problem Statement](#problem-statement)
  - [Features](#features)
  - [Technologies Used](#technologies-used)
  - [Architecture Overview](#architecture-overview)
    - [1. Token Transfer Contract (`TokenTransfer.sol`)](#1-token-transfer-contract-tokentransfersol)
    - [2. Cross-Chain Transfer Contract (`CrossChainTransfer.sol`)](#2-cross-chain-transfer-contract-crosschaintransfersol)
  - [Smart Contracts](#smart-contracts)
    - [Token Transfer Contract](#token-transfer-contract)
    - [Cross-Chain Transfer Contract](#cross-chain-transfer-contract)
    - [TokenVault Contract (Optional)](#tokenvault-contract-optional)
  - [Roadmap](#roadmap)
  - [License](#license)

## Cross-Chain Stablecoin Transfers
CoverageFi is a Web3 application designed to simplify stablecoin transfers by allowing users to send and receive digital dollars (USDC, DAI, USDT) across different blockchain networks. Users can easily send crypto to vendors or peers by scanning a QR code or entering a wallet address. CoverageFi also supports cross-chain transfers using Chainlink CCIP or LayerZero to ensure seamless token movement between chains.

## Problem Statement
CoverageFi addresses the challenge of providing **global access to digital dollars**. This project offers financial stability to users worldwide by enabling them to hold and transact stablecoins without needing a traditional bank account. CoverageFi makes it easy for individuals and businesses to move funds across blockchain networks, leveraging decentralized finance to reach users anywhere.

---

## Features

- **Simple Token Transfers**: Users can send stablecoins (USDC, DAI, USDT) to anyone by scanning a QR code or entering an address.
- **Cross-Chain Transfers**: Transfer stablecoins across multiple chains, including Ethereum, Optimism, and Base, using Chainlink CCIP or LayerZero.
- **Non-Custodial Wallet Support**: Users can import their existing non-custodial wallets (e.g., Coinbase Wallet) or create platform wallets via WalletConnect.
- **User Mapping**: Each user is assigned a unique ID for tracking transactions in the smart contracts, while usernames are managed in the frontend.
- **Stable Store of Value**: Provides users worldwide with access to stablecoins for holding and transacting, offering financial stability in volatile markets.

---

## Technologies Used

- **Blockchain Networks**: Ethereum, Optimism, Base
- **Cross-Chain Technology**: LayerZero, Chainlink CCIP
- **Smart Contracts**: Solidity (ERC20)
- **Frontend**: Next.js, TailwindCSS, shadcn
- **Wallet Integration**: WalletConnect, Coinbase Wallet
- **Token Support**: USDC, DAI, USDT

---

## Architecture Overview

The architecture consists of the following smart contracts:

### 1. Token Transfer Contract (`TokenTransfer.sol`)

- Handles local transfers of stablecoins (USDC, DAI, USDT).
- Manages user IDs and mappings between users and wallet addresses.
- Emits events for each token transfer, allowing easy tracking.

### 2. Cross-Chain Transfer Contract (`CrossChainTransfer.sol`)

- Manages cross-chain token transfers using LayerZero or Chainlink CCIP.
- Encodes and sends messages to other blockchain networks.
- Receives tokens on destination chains and transfers them to the intended recipients.

---

## Smart Contracts

### Token Transfer Contract
This contract allows users to send stablecoins and manage user IDs. It's designed to be efficient and user-friendly while ensuring that every token transfer is securely recorded on the blockchain.

### Cross-Chain Transfer Contract
This contract facilitates cross-chain token transfers using LayerZero or Chainlink CCIP. It handles sending and receiving stablecoins across different blockchain networks.

### TokenVault Contract (Optional)
 Stores tokens during cross-chain transfers (if required).

## Roadmap

 - Multi-token support: Add more stablecoins and tokens based on user needs.
 - Expanded network support: Support additional blockchain networks beyond Ethereum, Optimism, and Base.
 - Crosschain Integration: Full cross-chain functionality using LayerZero and Chainlink CCIP.
 - QR Code Payments: Implement QR code-based payments for vendors.
 - Mobile App: Release a mobile version of CoverageFi for broader adoption.

## License
This project is licensed under the MIT License - see the LICENSE file for details.