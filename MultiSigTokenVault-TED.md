# Alpha Omega Coin (AOC), The Queen of cryptocurrencies
<br>

# Technical Explanatory Documentation (TED)
## About
# Alpha Omega Coin (AOC) - MultiSigTokenVault Smart Contract 
<br>

## Overview
The **MultiSigTokenVault** is a **secure smart contract** that _**requires** **multiple signers**_ to _**approve transactions before execution**_. This provides enhanced **security** for **managing** **ERC20 tokens** by **preventing any single person** from **transferring funds.**

# Part 1 : Alpha Omega Coin  (AOC) BEP20 V2.1 Token  Identification Core Details
- **Name**: Alpha Omega Coin
- **Symbol**: AOC
- **Decimals**: 18
- **Initial Fixed Supply** : 1,000,000,000,000 (**1 trillion**)
- **Total Maximum Fixed Supply** : 1,000,000,000,000 (**1 trillion**) _**No minting and No Burning**_
- **TYPE**: **U**tility, **D**onation, **C**harity and **P**ayment **T**oken (**UDCPT**) 
- **Network** / **Blockchain**: **B**inance **S**mart **C**hain (**BSC**)
- **Standard:** _**B**inance Smart Chain_ **E**volution **P**roposal **20** (**_BEP20_**)
- **Version** : Version 2.1 (_**V2.1**_)
- **Upgradeability**: Uses OpenZeppelin UUPS (Universal Upgradeable Proxy Standard)
- **Pausable**: Multi-sig Owners can pause/unpause transfers for security sake, migration sake or for a community-oriented intervention
- **Blacklist**: Multi-Sig Owners can block addresses from sending/receiving tokens for security sake, scam prevention, protection from malicious attacks and also for internal regulations sake


# Part 2 : _Smart Contract Testnet_ + _Mainnet Explorer_ + _Github Repository_
## Part 2.1 : AOC BEP20 V2.1 Token MultiSigTokenVault Smart Contract Testnet + Mainnet Codes Identification Urls 
### Testnet : 
**Explorer**:  https://testnet.bscscan.com/address/0x6cddB529f72Dccb700ADCB4C1c26eD01f6562F7E#code
  
**Github** : 
- **Branch Name:** Testnet-v1.0.0
- **Branch Link:** https://github.com/alphaomegacoinaoc/AOC-Bep20-V2-token-distribution-contract/blob/testnet-v2.4/contracts/BulkOperationsV2.1.sol


### Mainnet :
**Explorer**: https://bscscan.com/address/0x4B723e1FCcca5A883fEEf8923701AECbd46fEAd1#readProxyContract
  
**Github** : 
- **Branch Name:** main-v2.1
- **Branch Link:** https://github.com/alphaomegacoinaoc/alphaomegacoinaoc-Multi-Sig-Contract/blob/Mainnet-v1.0.0/MultiSigTokenVault.sol

## Part 2.2 : AOC BEP20 V2.1 Token BulkOperations  Multi-Sig Smart Contract Testnet + Mainnet Codes Identification Urls Testnet 
### Testnet : 
**Explorer**:  https://testnet.bscscan.com/address/0x115D01dD6723ed1BC0DF2EB6A64350341a29fbBC#code
  
### **Github** : 
- **Branch Name:** Testnet-v1.0.0
- **Branch Link:** https://github.com/alphaomegacoinaoc/alphaomegacoinaoc-Multi-Sig-Contract/blob/testnet-v1.0.0/MultiSigTokenVault.sol


### Mainnet :
**Explorer**: https://bscscan.com/address/0x7c40e3711b23f80af63fba90ac3094ca8baab137#writeProxyContract
  
### **Github** : 
- **Branch Name:** Mainnet-v1.0.0
- **Branch Link:** https://github.com/alphaomegacoinaoc/alphaomegacoinaoc-Multi-Sig-Contract/blob/Mainnet-v1.0.0/MultiSigTokenVault.sol

## Part 2.3 : Alpha Omega Coin  (AOC) BEP20 V2.1 and ERC20 V3 Locker Multi-Sig Smart Contract Testnet + Mainnet Codes Identification Urls 
### Testnet : _(Amoy)_
**Explorer:**  https://amoy.polygonscan.com/address/0x59952eE49399E847fC4550a06911Ca75a637D302#code

### **Github :** 
- **Branch Name:** Testnet-v1.0.0
- **Branch Link:** https://github.com/alphaomegacoinaoc/alphaomegacoinaoc-Multi-Sig-Contract/blob/testnet-v1.0.0/MultiSigTokenVault.sol
  
### Mainnet :
### _(BSC)_
**Explorer**:  https://bscscan.com/address/0x76cd3474153f16c8e38999e2a9107cc46705c085#readProxyContract
### _(Etherium)_
**Explorer**: https://etherscan.io/address/0x47d8f4f0604b859db5AA86ef864574821257F4eC#code

### **Github** : 
- **Branch Name:** Mainnet-v1.0.0
- **Branch Link:** https://github.com/alphaomegacoinaoc/alphaomegacoinaoc-Multi-Sig-Contract/blob/Mainnet-v1.0.0/MultiSigTokenVault.sol

## Alpha Omega Coin (AOC) - MultiSigTokenVault Key Features
- **Multi-signature requirement:** _**Transactions need approval**_ from a _**configurable number of signers**._
- **Transaction expiration:** **_Proposed transactions expire after a set time period_** (**_default 2 days_**)
- **Upgradeability:** _Contract can be upgraded_ using the **UUPS** pattern
- **Emergency pause:** _**Signers**_ can _**pause the contract**_ in case of **emergency**
- **Signer management:** **Add** or **remove** **signers** (_up to maximum of 5_)

## Part 3 How Alpha Omega Coin (AOC) - MultiSigTokenVault Signer Management Works
## Adding Signers
Any existing signer can add a new signer to the contract using the

_**addSigner(address newSigner)function**_, with these requirements:
- _**Only existing signers** can **add new signers**_
- _**Cannot add** a **zero address**_
- _**Cannot add an address** that's **already a signer**_
- **_Cannot add yourself_**
- _**Maximum** of **5 signers allowed**_
## Removing Signers
Any existing signer can remove another signer using the 

_**removeSigner(address signerToRemove) function**_, with these limitations:
- _**Only existing signers** can **remove other signers**_
- _**Cannot remove yourself**_
- _**Cannot remove signers**_ if it would _cause the number of signers to **fall below the required approvals**_
### How Transactions Work
#### Transaction Lifecycle
- Every transaction goes through the following lifecycle:
## Proposal: 
_A signer proposes a transaction using **proposeTransaction()** specifying:_
- Target address (_**AOC BEP20 V2.1 Contract Address**_)
- Data (_**encoded function call**_)
- Value (**amount of (_Native Currency_) if needed**)
- Description (_**human-readable explanation**_)

## Approval: 

_Other **signers approve** the **transaction** using **approveTransaction(txId)**_
- _Each **signer** can **only approve once**_
- _**Approvals** are **tracked on-chain**_
- _**Transaction executes automatically when required approvals are reached**_

## Execution or Expiration: 

**The transaction is either:**
- _**Executed automatically when approval threshold is met**_
- _**Marked** as **expired** if the **timeout period passes**_
## Security Features
**The contract includes several security measures:**
- **Transaction timeout:** _**Proposed transactions expire** **after** a **configurable period**_ (_**default: 2 days**_)
- **Reentrancy protection:** _Guards against **reentrant attacks**_
- **Pausability:** _**Emergency** **pause** functionality_
- **Input validation:** _Extensive checks on all inputs_

# Example Usage Scenarios
#### Scenario: Update Configuration
_To change the transaction timeout:_
- **Signer proposes** a **transaction** calling _**setTransactionTimeout()**_
- _**Required signers approve**_
- _Configuration is **updated when approval threshold is met**_

## Part 5 : Technical Details
_The contract leverages **several OpenZeppelin libraries**:_
- **UUPSUpgradeable:** For **_upgradeable contract pattern_**
- **OwnableUpgradeable:** For **_ownership management_**
- **ReentrancyGuardUpgradeable:** For _**protection against reentrancy attacks**_
- **PausableUpgradeable:** For _emergency **pause** functionality_

## Part 6: Alpha Omega Coin (AOC) - MultiSigTokenVault Smart Contract Read + Write Functions
## Read Functions (View Functions)
- **getSigners():** _Returns an array of **all current signer addresses**_
- **isSignerApproved(uint256 txId, address signer):** _**Checks** if **a specific signer has approved** a **specific transaction**_
- **getSignerCount():** _Returns the **current number** of **signers**_
- **getRequiredApprovals():** _Returns **the number of approvals required** for **transaction execution**_
- **getTransactionTimeout():** **Returns _the current timeout period_ for _transactions_ (_in seconds_)**
- **getTransaction(uint256 txId):** _Returns **all details** of a **specific transaction** including **target**, **value**, **data**, **description**, **status**, etc._
- **getTransactionCount():** _Returns the **total number** of **transactions ever proposed**_
- **isPaused():** _Returns whether the **contract** is **currently paused**_
- **isSigner(address account):** _Checks if an **address** is a **current signer**_
- **getApprovalCount(uint256 txId):** _Returns **how many approvals** a **specific transaction has received**_
- **getTransactionStatus(uint256 txId):** _Returns **the current status of a transaction** (**Pending**, **Executed**, **Expired**)_
# Write Functions (State-Changing Functions)
## Transaction Management
- **proposeTransaction**(**address** target, **bytes memory data**, uint256 **value**, string memory **description**): 
_**Creates** a **new transaction proposal** and **automatically approves it from the proposer**_
- **approveTransaction(uint256 txId):** _**Approves a pending transaction**, **executes** it if **approval threshold is met**_
- **revokeApproval(uint256 txId):** _**Allows a signer** to **revoke their previous approval** if the **transaction is still pending**_
- **executeTransaction(uint256 txId):** _**Explicitly executes a transaction** that **has met the approval threshold** (**typically automatic**)_

## Signer Management
- **addSigner(address newSigner):** _**Adds** a **new signer** to the **contract** (**follows limitations as described in the selection**)_
- **removeSigner(address signerToRemove):** _**Removes** an **existing signer** (**follows limitations as described in the selection**)_
- **setRequiredApprovals(uint256 newRequired):** _**Changes the number** of **required approvals for transactions**_

## Configuration Functions
- **setTransactionTimeout(uint256 newTimeout):** _**Updates** the **transaction expiration timeout**_
- **pause():** _**Pauses** the **contract**, **preventing new transactions**_
- **unpause():** _**Unpauses** the **contract**, **allowing transactions again**_
- **upgradeTo(address newImplementation):** _**Upgrades** the **contract implementation** (**UUPS pattern**)_

## Token Management
- **approveToken**(address **token**, address **spender**, uint256 **amount**): _**Creates** a **transaction** to **approve** a **spender for token transfers**_
- **transferToken**(address **token**, address **recipient**, uint256 **amount**): _**Creates** a **transaction** to **transfer tokens** to a **recipient**_
- **batchTransferToken**(address **token**, **address[]** memory **recipients**, uint256[] memory **amounts**): _**Creates** a **transaction** to **transfer tokens** to **multiple recipients**_

## Events Emitted
- **TransactionProposed(uint256 txId, address proposer):** _**Emitted** when a **new transaction is proposed**_
- **TransactionApproved(uint256 txId, address approver):** _**Emitted** when a **transaction** is **approved_**
- **TransactionExecuted(uint256 txId):** _**Emitted** when a **transaction** is **executed**_
- **TransactionExpired(uint256 txId):** _**Emitted** when a **transaction expires**_
- **ApprovalRevoked(uint256 txId, address signer):** _**Emitted** when an **approval is revoked**_
- **SignerAdded(address newSigner):** _**Emitted** when a **new signer is added**_
- **SignerRemoved(address removedSigner):** _**Emitted** when a **signer is removed**_
- **RequiredApprovalsChanged(uint256 newRequired):** _**Emitted** when **required approvals count changes**_
- **TransactionTimeoutChanged(uint256 newTimeout):** _**Emitted** when **transaction timeout period changes**_


