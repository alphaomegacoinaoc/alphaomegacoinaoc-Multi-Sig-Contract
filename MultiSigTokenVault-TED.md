## MultiSigTokenVault Contract Overview
  The MultiSigTokenVault is a secure smart contract that requires multiple signers to approve transactions before execution. This provides enhanced security for managing ERC20 tokens by preventing any single person from transferring funds.
## Key Features
# Multi-signature requirement: Transactions need approval from a configurable number of signers
# Transaction expiration: Proposed transactions expire after a set time period (default 2 days)
# Upgradeability: Contract can be upgraded using the UUPS pattern
# Emergency pause: Signers can pause the contract in case of emergency
# Signer management: Add or remove signers (up to maximum of 5)

## How Signer Management Works
Adding Signers
Any existing signer can add a new signer to the contract using the 
addSigner(address newSigner)function, with these requirements:
Only existing signers can add new signers
Cannot add a zero address
Cannot add an address that's already a signer
Cannot add yourself
Maximum of 5 signers allowed
Removing Signers
Any existing signer can remove another signer using the removeSigner(address signerToRemove) function, with these limitations:
Only existing signers can remove other signers
Cannot remove yourself
Cannot remove signers if it would cause the number of signers to fall below the required approvals
How Transactions Work
Transaction Lifecycle
- Every transaction goes through the following lifecycle:
## Proposal: 

A signer proposes a transaction using proposeTransaction() specifying:
Target address (AlphaOmegaCoin Contract Address)
Data (encoded function call)
Value (amount of ETH if needed)
Description (human-readable explanation)

## Approval: 

Other signers approve the transaction using approveTransaction(txId)
Each signer can only approve once
Approvals are tracked on-chain
Transaction executes automatically when required approvals are reached

## Execution or Expiration: 

The transaction is either:
Executed automatically when approval threshold is met
Marked as expired if the timeout period passes
Security Features
The contract includes several security measures:
Transaction timeout: Proposed transactions expire after a configurable period (default: 2 days)
Reentrancy protection: Guards against reentrant attacks
Pausability: Emergency pause functionality
Input validation: Extensive checks on all inputs

# Example Usage Scenarios
Scenario: Update Configuration
To change the transaction timeout:
Signer proposes a transaction calling setTransactionTimeout()
Required signers approve
Configuration is updated when approval threshold is met
Scenario: Blacklisting a User


## Technical Details
The contract leverages several OpenZeppelin libraries:
UUPSUpgradeable: For upgradeable contract pattern
OwnableUpgradeable: For ownership management
ReentrancyGuardUpgradeable: For protection against reentrancy attacks
PausableUpgradeable: For emergency pause functionality

## Read Functions (View Functions)
- getSigners(): Returns an array of all current signer addresses
- isSignerApproved(uint256 txId, address signer): Checks if a specific signer has approved a specific transaction
- getSignerCount(): Returns the current number of signers
- getRequiredApprovals(): Returns the number of approvals required for transaction execution
- getTransactionTimeout(): Returns the current timeout period for transactions (in seconds)
- getTransaction(uint256 txId): Returns all details of a specific transaction including target, value, data, description, status, etc.
- getTransactionCount(): Returns the total number of transactions ever proposed
- isPaused(): Returns whether the contract is currently paused
- isSigner(address account): Checks if an address is a current signer
- getApprovalCount(uint256 txId): Returns how many approvals a specific transaction has received
- getTransactionStatus(uint256 txId): Returns the current status of a transaction (Pending, Executed, Expired)

## Write Functions (State-Changing Functions)
# Transaction Management
- proposeTransaction(address target, bytes memory data, uint256 value, string memory description): 
Creates a new transaction proposal and automatically approves it from the proposer
- approveTransaction(uint256 txId): Approves a pending transaction, executes it if approval threshold is met
- revokeApproval(uint256 txId): Allows a signer to revoke their previous approval if the transaction is still pending
- executeTransaction(uint256 txId): Explicitly executes a transaction that has met the approval threshold (typically automatic)

## Signer Management
- addSigner(address newSigner): Adds a new signer to the contract (follows limitations as described in the selection)
- removeSigner(address signerToRemove): Removes an existing signer (follows limitations as described in the selection)
- setRequiredApprovals(uint256 newRequired): Changes the number of required approvals for transactions

## Configuration Functions
- setTransactionTimeout(uint256 newTimeout): Updates the transaction expiration timeout
- pause(): Pauses the contract, preventing new transactions
- unpause(): Unpauses the contract, allowing transactions again
- upgradeTo(address newImplementation): Upgrades the contract implementation (UUPS pattern)

## Token Management
- approveToken(address token, address spender, uint256 amount): Creates a transaction to approve a spender for token transfers
- transferToken(address token, address recipient, uint256 amount): Creates a transaction to transfer tokens to a recipient
- batchTransferToken(address token, address[] memory recipients, uint256[] memory amounts): Creates a transaction to transfer tokens to multiple recipients

## Events Emitted
- TransactionProposed(uint256 txId, address proposer): Emitted when a new transaction is proposed
- TransactionApproved(uint256 txId, address approver): Emitted when a transaction is approved
- TransactionExecuted(uint256 txId): Emitted when a transaction is executed
- TransactionExpired(uint256 txId): Emitted when a transaction expires
- ApprovalRevoked(uint256 txId, address signer): Emitted when an approval is revoked
- SignerAdded(address newSigner): Emitted when a new signer is added
- SignerRemoved(address removedSigner): Emitted when a signer is removed
- RequiredApprovalsChanged(uint256 newRequired): Emitted when required approvals count changes
- TransactionTimeoutChanged(uint256 newTimeout): Emitted when transaction timeout period changes


