//SPDX-License-Identifier: MIT

// Smart Contract Wallet Requirements:
// - Wallet has 1 Owner - OK
// - Receive Funds with a callback function - OK
// - owner Spend Money on EOA and also Contract addresses - OK
// - Give allowance to other addresses (limited to a certain amount) - OK
// - Change owner to a different address, recovery functionality, 3out of 5 guardians - OK

pragma solidity 0.8.15;

contract SmartContractWallet {

    address payable public owner;

    struct Member {
        bool isAllowedToSend; //wouldn't it make sense to just check this with - allowance > 0 ?
        uint allowance;
        bool guardian;
    }

    mapping(address => Member) public members;

    mapping(address => uint8) newOwnerVotes;

    uint8 numFreeGuardianPos;
    uint8 numOwnerChangeNecessaryVote;

    constructor() {
        owner = payable(msg.sender);
        numFreeGuardianPos = 5;
        numOwnerChangeNecessaryVote = 3;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "The Function is only executable for the owner of the contract");
        _;
    }

    modifier memberOnly() {
        require(members[msg.sender].isAllowedToSend || msg.sender == owner, "Account not allowed to send anything from this contract");
        _;
    }

    receive() external payable{}

    function spendMoney(address payable _to, uint _amount, bytes memory _payload) public returns(bytes memory) {
        if(msg.sender != owner){
            require(members[msg.sender].isAllowedToSend || msg.sender == owner, "Account not allowed to send anything from this contract");
            require(members[msg.sender].allowance >= _amount, "You are trying to spend more than your allowance");

            members[msg.sender].allowance -= _amount;
            if (members[msg.sender].allowance == 0){
                members[msg.sender].isAllowedToSend = false;
            }
        }
        
        (bool success, bytes memory returnData) = _to.call{value: _amount}(_payload);
        require(success, "Aborting call was not successful");
        return returnData;
    }
    
    function addAllowance(address _for, uint _amount) public onlyOwner{
        require(_amount > 0, "The allowance can't be zero!");
       
        members[_for].isAllowedToSend = true;
        members[_for].allowance += _amount;
    }

    function setGuardian(address _newGuardian, bool _isGuardian) public onlyOwner{
        if(_isGuardian){
            require(!members[_newGuardian].guardian, "This address is already a guardian. Nothing to do here.");
            require(numFreeGuardianPos != 0, "No free guardian spots left. Unset a guardian first.");
            members[_newGuardian].guardian = true;
            numFreeGuardianPos--;
        }
        if(_isGuardian == false){
            require(members[_newGuardian].guardian, "This address was not a guardian anyways. Nothing to do here.");
            members[_newGuardian].guardian = false;
            numFreeGuardianPos++;
        }
    }

    function voteNewOwner(address newOwnerCandidate) public{
        require(members[msg.sender].guardian == true, "Sender is not a Guardian!");
        newOwnerVotes[newOwnerCandidate]++;
        if(newOwnerVotes[newOwnerCandidate] >= numOwnerChangeNecessaryVote){
            owner = payable(newOwnerCandidate);
        }
    }
}

contract ReceiverContract {
    receive() external payable{}
}