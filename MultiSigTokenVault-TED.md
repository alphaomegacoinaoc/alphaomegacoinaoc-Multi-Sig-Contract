# MultiSigTokenVault Contract 
## Overview
The **MultiSigTokenVault** is a **secure smart contract** that _**requires** **multiple signers**_ to _**approve transactions before execution**_. This provides enhanced **security** for **managing** **ERC20 tokens** by **preventing any single person** from **transferring funds.**
## Key Features
- **Multi-signature requirement:** _**Transactions need approval**_ from a _**configurable number of signers**._
- **Transaction expiration:** **_Proposed transactions expire after a set time period_** (**_default 2 days_**)
- **Upgradeability:** _Contract can be upgraded_ using the **UUPS** pattern
- **Emergency pause:** _**Signers**_ can _**pause the contract**_ in case of **emergency**
- **Signer management:** **Add** or **remove** **signers** (_up to maximum of 5_)

## How Signer Management Works
## Adding Signers
Any existing signer can add a new signer to the contract using the

_**addSigner(address newSigner)function**_, with these requirements:
- _**Only existing signers** can **add new signers**_
- _**Cannot add** a **zero address**_
- _**Cannot add an address** that's **already a signer**_
- **_Cannot add yourself_**
- **_Maximum** of **5 signers allowed**_
## Removing Signers
Any existing signer can remove another signer using the 

_**removeSigner(address signerToRemove) function**_, with these limitations:
- _**Only existing signers** can **remove other signers**_
- **_Cannot remove yourself**_
- _**Cannot remove signers**_ if it would _cause the number of signers to **fall below the required approvals**_
### How Transactions Work
#### Transaction Lifecycle
- Every transaction goes through the following lifecycle:
## Proposal: 
_A signer proposes a transaction using **proposeTransaction()** specifying:_
- Target address (_**AOC BEP20 V2.1 Contract Address**_)
- Data (_**encoded function call**_)
- Value (**amount of _ETH if needed_**)
- Description (_**human-readable explanation**_)

## Approval: 

_Other signers approve the transaction using **approveTransaction(txId)**_
- _Each signer can only approve once_
- _**Approvals** are **tracked on-chain**_
- _**Transaction executes automatically when required approvals are reached**_

## Execution or Expiration: 

**The transaction is either:**
- _**Executed automatically when approval threshold is met**_
- _**Marked** as **expired** if the **timeout period passes**_
## Security Features
**The contract includes several security measures:**
- **Transaction timeout:** _Proposed transactions expire after a configurable period_ (_**default: 2 days**_)
- **Reentrancy protection:** _Guards against reentrant attacks_
- **Pausability:** _Emergency **pause** functionality_
- **Input validation:** _Extensive checks on all inputs_

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


