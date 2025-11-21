//SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts-upgradeable/token/ERC20/IERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";

contract MultiSigTokenVault is 
    Initializable, 
    UUPSUpgradeable, 
    OwnableUpgradeable,
    ReentrancyGuardUpgradeable,
    PausableUpgradeable
{
    address[] public signers;
    uint256 public requiredApprovals;
    IERC20Upgradeable public token;

    mapping(address => bool) public isSigner;

    struct Transaction{
        address target;
        bytes data;
        uint256 value;
        uint256 approvals;
        bool executed;
        uint256 createdAt;
        uint256 expiresAt;
        string description;
    }

    Transaction[] public transactions;
    mapping(uint256 => mapping(address => bool)) public transactionApprovals;
    
    // Security features (only expiry is enforced)
    uint256 public constant MAX_SIGNERS = 10;
    uint256 public transactionTimeout;

    modifier onlySigner(){
        require(isSigner[msg.sender], "Not an authorized signer");
        _;
    }

    modifier txExists(uint256 txId){
        require(txId < transactions.length, "Transaction does not exist");
        _;
    }
    
    modifier notExecuted(uint256 txId){
        require(!transactions[txId].executed, "Transaction already executed");
        _;
    }

    modifier notApproved(uint256 txId) {
        require(!transactionApprovals[txId][msg.sender], "Transaction already approved");
        _;
    }

    modifier validTransaction(uint256 txId) {
        require(txId < transactions.length, "Invalid transaction ID");
        require(!transactions[txId].executed, "Transaction already executed");
        require(block.timestamp <= transactions[txId].expiresAt, "Transaction expired");
        _;
    }

    modifier onlyMultiSig() {
    require(msg.sender == address(this), "Only via multisig");
    _;
}

    // modifier notEmergencyPaused() {
    //     require(!paused(), "Contract is paused");
    //     _;
    // }

    // Events
    event TransactionProposed(uint256 indexed txId, address indexed proposer, string description);
    event TransactionApproved(uint256 indexed txId, address indexed signer);
    event TransactionExecuted(uint256 indexed txId, address indexed executor);
    event TransactionExpired(uint256 indexed txId);
    event SignerAdded(address indexed signer);
    event SignerRemoved(address indexed signer);
    event ConfigUpdated(uint256 requiredApprovals, uint256 transactionTimeout);
    event UpdatedApprovals(uint256 requiredApprovals);

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
    _disableInitializers();
    }

    //Initialize
    function initialize(
        address[] memory signers_,
        uint256 requiredApprovals_,
        address tokenAddress_
    ) public initializer{
        require(signers_.length > 0, "Signers required");
        require(signers_.length <= MAX_SIGNERS, "Too many signers");
        require(requiredApprovals_ > 0 && requiredApprovals_ <= signers_.length, "Invalid threshold");
        require(tokenAddress_ != address(0), "Invalid token address");

        for(uint256 i = 0; i < signers_.length; i++){
            require(signers_[i] != address(0), "Zero address signer");
            require(!isSigner[signers_[i]], "Duplicate signer");
            isSigner[signers_[i]] = true;
        }

        signers = signers_;
        requiredApprovals = requiredApprovals_;
        token = IERC20Upgradeable(tokenAddress_);
        transactionTimeout = 2 days; // Default timeout (can be updated in seconds)

        __Ownable_init();
        __ReentrancyGuard_init();
        __Pausable_init();
    }

    //Authorization to allow contract upgrades
    function _authorizeUpgrade(address newImplementation) internal override onlyOwner{}

    //Add a new signer
    function addSigner(address newSigner) external onlyMultiSig {
        require(newSigner != address(0), "Zero address signer");
        require(!isSigner[newSigner], "Already a signer");
        require(signers.length < MAX_SIGNERS, "Maximum signers limit reached");
        
        isSigner[newSigner] = true;
        signers.push(newSigner);
        
        emit SignerAdded(newSigner);
    }

    //Remove an existing Signer
    function removeSigner(address signerToRemove) external onlyMultiSig {
        require(isSigner[signerToRemove], "Not a signer");
        require(signers.length - 1 >= requiredApprovals, "Cannot remove - would violate minimum requirements");
        require(signers.length > 1, "Cannot remove the last signer");
        
        isSigner[signerToRemove] = false;

        //Find and remove more efficiently
        uint256 signerIndex = 0;
        for (uint256 i = 0; i < signers.length; i++) {
            if (signers[i] == signerToRemove) {
                signerIndex = i;
                break;
            }
        }
        
        //Move last element to the position of the element to delete
        signers[signerIndex] = signers[signers.length - 1];
        signers.pop();
        
        emit SignerRemoved(signerToRemove);
    }
    
    // //Deposit ERC20 tokens into the vault
    // function deposit(uint256 amount) external nonReentrant {
    //     require(amount > 0, "Amount must be greater than 0");
    //     require(token.balanceOf(msg.sender) >= amount, "Insufficient balance");

    //     token.transferFrom(msg.sender, address(this), amount);
    // }

    //Propose a transaction for approval for signers (supports arbitrary contract calls)
    function proposeTransaction(
        address target,
        bytes calldata data,
        uint256 value,
        string calldata description
    ) external onlySigner whenNotPaused nonReentrant returns (uint256) {
        require(target != address(0), "Zero target address");
        require(data.length > 0, "Empty transaction data");
        require(bytes(description).length > 0, "Empty description");
        
        uint256 txId = transactions.length;
        uint256 expiresAt = block.timestamp + transactionTimeout;
        
        transactions.push(Transaction({
            target: target,
            data: data,
            value: value,
            approvals: 0,
            executed: false,
            createdAt: block.timestamp,
            expiresAt: expiresAt,
            description: description
        }));
        
        emit TransactionProposed(txId, msg.sender, description);
        return txId;
    }
    
    //Approve a proposed Transaction
    function approveTransaction(uint256 txId) 
        external
        onlySigner
        validTransaction(txId)
        notApproved(txId)
        whenNotPaused
        nonReentrant
    {
        Transaction storage txn = transactions[txId];
        transactionApprovals[txId][msg.sender] = true;
        txn.approvals += 1;

        emit TransactionApproved(txId, msg.sender);

        if(txn.approvals >= requiredApprovals){
            _executeTransaction(txId);
        }
    }

    //Execute transactions if enough approvals are received
    function _executeTransaction(uint256 txId) internal {
        Transaction storage txn = transactions[txId];
        require(txn.approvals >= requiredApprovals, "Not enough approvals");

        txn.executed = true;
        
        (bool success, ) = txn.target.call{value: txn.value}(txn.data);
        require(success, "Transaction execution failed");
        
        emit TransactionExecuted(txId, transactions[txId].target);
    }

    // Emergency controls
    function pause() external onlySigner {
        _pause();
    }

    function unpause() external onlySigner {
        _unpause();
    }

    // Configuration: update only the transaction timeout (in seconds)
    function setTransactionTimeout(uint256 newTransactionTimeoutSeconds)
        external
        onlySigner
        whenNotPaused
    {
        require(newTransactionTimeoutSeconds > 0, "Timeout must be > 0");
        transactionTimeout = newTransactionTimeoutSeconds;
        emit ConfigUpdated(requiredApprovals, newTransactionTimeoutSeconds);
    }

    // Expire old transactions
    function expireTransaction(uint256 txId) external {
        require(txId < transactions.length, "Invalid transaction ID");
        Transaction storage transaction = transactions[txId];
        require(!transaction.executed, "Transaction already executed");
        require(block.timestamp > transaction.expiresAt, "Transaction not expired");
        
        transaction.executed = true; // Mark as executed to prevent further actions
        emit TransactionExpired(txId);
    }

    //View the current signers
    function getSigners() external view returns(address[] memory) {
        return signers;
    }

    //Get details about a transaction by ID
    function getTransaction(uint256 txId)
        external
        view
        txExists(txId)
        returns (
            address target,
            bytes memory data,
            uint256 value,
            uint256 approvals,
            bool executed,
            uint256 createdAt,
            uint256 expiresAt,
            string memory description
        )
    {
        Transaction memory txn = transactions[txId];
        return(
            txn.target,
            txn.data,
            txn.value,
            txn.approvals,
            txn.executed,
            txn.createdAt,
            txn.expiresAt,
            txn.description
        );
    }

    // Get configuration
    function getConfig() external view returns (
        uint256 _requiredApprovals,
        uint256 _transactionTimeout,
        bool pausedState
    ) {
        return (
            requiredApprovals,
            transactionTimeout,
            paused()
        );
    }

    // Get transaction count
    function getTransactionCount() external view returns (uint256) {
        return transactions.length;
    }

    // Check if transaction is approved by specific signer
    function isTransactionApprovedBy(uint256 txId, address signer) external view returns (bool) {
        require(txId < transactions.length, "Invalid transaction ID");
        return transactionApprovals[txId][signer];
    }

    // Rate limiting helpers removed as daily limits are not enforced

    // // Receive ETH (for contract calls that send ETH)
    // receive() external payable {}

    function updateRequireApprovals(uint256 _newRequiredApprovals) external onlyMultiSig whenNotPaused {
        require(_newRequiredApprovals > 0 && _newRequiredApprovals <= signers.length, "Invalid Approvals");
        requiredApprovals = _newRequiredApprovals;
        emit UpdatedApprovals(_newRequiredApprovals);
    }
}
