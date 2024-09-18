//SPDX-License-Identifier: MIT

pragma solidity ^0.8.16;

contract Owned {
    address owner;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "You are not the owner of the contract, you are not permitted to do this action.");
        _;
    }
}

//To split the 2 contracts in 2 different files, just add: import "./Ownable.sol" before InheritanceModifierExample

contract InheritanceModifierExample is Owned {

    mapping(address => uint) public tokenBalance;

    uint tokenPrice = 1 ether;

    constructor() {
        tokenBalance[owner] = 100;
    }

    function createNewToken() public onlyOwner {
        tokenBalance[owner]++;
    }

    function burnToken() public onlyOwner {
        tokenBalance[owner]--;
    }

    function purchaseToken() public payable {
        uint ownerTokenValue = tokenBalance[owner] * tokenPrice;
        require(ownerTokenValue / msg.value > 0, "not enough tokens"); //In Solidity, division rounds towards zero
        tokenBalance[owner] -= msg.value / tokenPrice;
        tokenBalance[msg.sender] += msg.value / tokenPrice;
    }

    function sendToken(address _to, uint _amount) public {
        require(tokenBalance[msg.sender] >= _amount, "Not enough tokens");
        assert(tokenBalance[_to] + _amount >= tokenBalance[_to]);
        assert(tokenBalance[msg.sender] - _amount <= tokenBalance[msg.sender]);
        tokenBalance[msg.sender] -= _amount;
        tokenBalance[_to] += _amount;
    }

}
