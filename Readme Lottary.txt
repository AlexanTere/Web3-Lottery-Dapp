Here's a README file for the `ThreeItemsLottery` smart contract, providing an overview of its functionality, usage, and the purpose of each component.

---

# ThreeItemsLottery Smart Contract

## Overview

The `ThreeItemsLottery` is an Ethereum smart contract that allows users to participate in a lottery system with three distinct items. Each item serves as a lottery category, where participants can buy tickets. Once the lottery concludes, a winner is randomly selected from each item category's participants.

## Key Features

- **Multi-item Lottery**: Supports three items, each with its own set of participants and ticket counts.
- **Random Winner Selection**: A random winner is selected from the participants of each item category.
- **Manager Controls**: Only the manager has control over sensitive operations like setting a new manager, ending the lottery, or withdrawing contract funds.
- **Event-Driven Updates**: Emits events for key actions, including when a player joins, a winner is selected, or a new manager is set.
- **Secure Withdrawals**: Ether funds collected by the contract can only be withdrawn by the manager.
- **Self-Destruct Functionality**: Allows the manager to permanently disable the contract.

## Contract Details

- **License**: MIT
- **Language**: Solidity (>=0.8.17)
- **Author**: Ethereum address of the deployer

## Deployment & Setup

Deploy the contract using Solidity compatible platforms such as [Remix](https://remix.ethereum.org/), or by using Truffle or Hardhat frameworks. The deployer of the contract will be set as the manager by default.

## Contract Structure

### State Variables

- **`manager`**: The contract's manager with elevated permissions.
- **`players`**: An array holding the addresses of all players in the lottery.
- **`ticketPrice`**: The price for a single ticket (set to `0.01 ether`).
- **`lotteryEnded`**: A boolean to control if the lottery is open or ended.
- **`winningItemIndex`**: The index of the winning item for the lottery.
- **`winner`**: Address of the current winner.
- **`items`**: An array of items (categories) with associated players and ticket counts.
- **`playersMap`**: A mapping to track players and their winning items.
- **`allWinners`**: An array of all winners from past lotteries.

### Structs

- **`Item`**: Represents each lottery item with:
  - `id`: Item ID.
  - `participants`: Array of participant addresses for the item.
  - `totalTickets`: Total tickets sold for the item.

- **`Player`**: Tracks each player's winnings with:
  - `winningItems`: Array storing IDs of items won by the player.

### Events

- **`NewPlayer(address indexed player)`**: Triggered when a player enters the lottery.
- **`LotteryEnded(address indexed winner, uint indexed winningItemIndex)`**: Triggered when the lottery ends, showing the winner and winning item.
- **`ManagerSet(address indexed oldManager, address indexed newManager)`**: Triggered when a new manager is assigned.

## Key Functions

### Public Functions

- **`enter(uint id)`**: Allows players to join the lottery by buying a ticket for a specified item.
- **`pickWinner(uint id)`**: Selects a random winner from the participants of the specified item and ends the lottery.
- **`getPlayers()`**: Returns the list of all players.
- **`getBalanceOfEther()`**: Returns the Ether balance in the contract.
- **`getItem(uint id)`**: Returns details of a specific item.
- **`iamWinner(address player)`**: Returns an array of items won by a specified player.
- **`getAllWinners()`**: Returns an array of all previous winners.

### Manager-Only Functions

- **`withdraw()`**: Allows the manager to withdraw the contract’s balance.
- **`enableBuyingTickets()`**: Resets the lottery state to allow a new round of ticket purchases.
- **`setNewManager(address newManager)`**: Assigns a new manager for the contract.
- **`destroyContract()`**: Permanently destroys the contract and transfers the remaining balance to the manager.

## Usage

1. **Enter Lottery**: Participants call `enter()` with a specified item ID and ticket price to join the lottery for that item.
2. **Pick Winner**: Manager calls `pickWinner()` to end the lottery and randomly select a winner from the participants.
3. **Get Winnings**: Players can use `iamWinner()` to check their winnings.
4. **Manage Contract**: Manager can withdraw funds, reset the lottery for a new round, or assign a new manager.
5. **Contract Termination**: Manager can call `destroyContract()` to end the contract and withdraw all remaining funds.

## Security & Restrictions

- **Only Manager Access**: Sensitive functions such as ending the lottery, assigning a new manager, or contract withdrawal are restricted to the manager.
- **Random Number Generation**: The random number for winner selection uses `block.timestamp`, `block.difficulty`, and `participants.length` for pseudo-randomness.
- **Self-Destruction**: Only the manager can call `destroyContract()` to disable the contract.

---

This contract demonstrates a lottery system with fair controls and transparent operations. All participants should understand that joining involves a payment and randomness in winner selection, and only the manager can withdraw funds or modify certain contract states.