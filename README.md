# Encrypted Contracts

This repository contains a collection of smart contracts designed for secure and private operations using Zama's Fully Homomorphic Encryption (FHE) technology. The contracts are focused on encrypted token standards (ERC1155 and ERC20) and general-purpose encryption for blockchain-based applications.

## Overview

The project includes several smart contracts for various functionalities, including encrypted token management and arithmetic operations, designed to run on Ethereum-compatible blockchains. By leveraging Zama's FHE technology, these contracts ensure privacy for transactions and computations.

### Contracts

- **Addition.sol**: A contract for performing encrypted addition operations in different ways.
- **CrypticClue.sol**: A contract for secure, privacy-preserving operations (not a game).
- **EncryptedCounter.sol**: A contract for performing encrypted counting operations.
- **EncryptedERC1155.sol**: A custom implementation of the ERC1155 standard with FHE.
- **EncryptedERC20.sol**: A custom implementation of the ERC20 standard with FHE.
- **Operations.sol**: A contract for various encrypted operations (previously `Operatjons.sol`).

### Tests

The project also includes test scripts to validate the functionality of each contract:

- **addition.ts**: Test script for the Addition contract.
- **EncryptedCounter.ts**: Test script for the EncryptedCounter contract.
- **crypticClue.ts**: Test script for the CrypticClue contract.
- **EncryptedERC1155.ts**: Test script for the EncryptedERC1155 contract.
- **EncryptedERC20.fixture.ts**: Test fixture for the EncryptedERC20 contract.
- **EncryptedERC20.ts**: Test script for the EncryptedERC20 contract.
- **instance.ts**: A general test script for contract instances.

