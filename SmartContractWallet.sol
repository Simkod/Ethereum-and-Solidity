//SPDX-License-Identifier: MIT

// Smart Contract Wallet Requirements:
// - Wallet has 1 Owner - OK
// - Receive Funds with a callback function - OK
// - owner Spend Money on EOA and also Contract addresses - OK
// - Give allowance to other addresses (limited to a certain amount) - OK
// - Change owner to a different address, recovery functionality, 3out of 5 guardians - OK

pragma solidity 0.8.15;

contract SmartContractWallet {

    address public owner;

    struct Member {
        bool guardian;
        uint allowance;
    }
    mapping(address => Member) public members;

    mapping(address => uint8) newOwnerVotes;

    uint8 numFreeGuardianPos;
    uint8 numOwnerChangeNecessaryVote;

    constructor() {
        owner = msg.sender;
        numFreeGuardianPos = 5;
        numOwnerChangeNecessaryVote = 3;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    receive() external payable{}

    function spendMoney(address payable _to, uint amount) payable public onlyOwner {
        _to.transfer(amount);
    }
    
    function setAllowance(address _allowed, uint _allowance) public onlyOwner{
        members[_allowed].allowance = _allowance;
    }

    function alloweeSpendMoney(address payable _to, uint amount) public{
        require(members[msg.sender].allowance >= amount);
        _to.transfer(amount);
    }        

    function setGuardian(address newGuardian) public onlyOwner{
        require(numFreeGuardianPos > 0, "No more free guardian spots");
        members[newGuardian].guardian = true;
        numFreeGuardianPos--;
    }

    function voteNewOwner(address newOwnerCandidate) public{
        require(members[msg.sender].guardian == true, "Sender is not a Guardian!");
        newOwnerVotes[newOwnerCandidate]++;
        if(newOwnerVotes[newOwnerCandidate] >= numOwnerChangeNecessaryVote){
            owner = newOwnerCandidate;
        }
    }
}

contract ReceiverContract {
    receive() external payable{}
}