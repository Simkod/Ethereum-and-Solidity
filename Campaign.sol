pragma solidity ^0.5.0;

contract Campaign {
    struct Request {
        string description;
        uint value;
        address recipient;
        bool complete;
    }

    address public manager;
    uint minimumContribution; 
    address[] public approvers;
    Request[] public requests;

    modifier restricted() {
        require(msg.sender == manager);
        _;
    }
    
    function createCampaign(uint minimum) public {
        manager = msg.sender;
        minimumContribution = minimum;
    }

    function contribute() public payable{
        require(msg.value > minimumContribution, "Contribution is smaller than the minimum!");
        approvers.push(msg.sender);
    }

    function createRequest(string memory description, uint value, address recipient) public restricted {
        require(value <= address(this).balance);
        
        Request memory newRequest = Request({
            value: value,
            description: description,
            recipient: recipient,
            complete: false
            });

        requests.push(newRequest);
    }
}

