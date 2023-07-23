pragma solidity ^0.4.17;

contract Lottery {
    address public manager;
    address[] public players;
    uint8 managerRewardPercentage; 

    function Lottery(uint8 managerPercentage) public{
        manager = msg.sender;
        managerRewardPercentage = managerPercentage;
    }

    function enter() public payable {
        require(msg.value == 25 ether);
        
        players.push(msg.sender);
    }

    function random() private view returns (uint) {
        return uint(keccak256(block.difficulty, now, players));
    }

    function pickWinner() public {
        require(msg.sender == manager); 
        uint winnerIndex = random() % players.length;
        players[winnerIndex].send((this.balance * (100 - managerRewardPercentage)) / 100);

        manager.send(this.balance);

        players = new address[](0);
    }

    function returnEntries() public {
        require(msg.sender == manager);
        
    }
}