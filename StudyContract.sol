//SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

contract MyContract {
    //Wallet Smart Contract example
    //  Deposit - ok
    //  Get Balance - ok
    //  Withdraw all funds - ok
    //  Send all(or withdraw) funds to external account - ok

    address public contractOwner;

    constructor () {
        contractOwner = msg.sender;
    }

    modifier onlyOwner {
      require(msg.sender == contractOwner);
      _;
   }

    receive() external payable{
    }

    fallback() external payable{
    }

    function getBalance() public view returns(uint){
        return address(this).balance;
    }

    function withdraw() public onlyOwner{
        require(msg.sender == contractOwner);
        payable(msg.sender).transfer(address(this).balance);
    }

    function withdrawToAddress(address _receiver) public onlyOwner{
        require(msg.sender == contractOwner);
        payable(_receiver).transfer(address(this).balance);
    }

    // PAYABLE, RECEIVE, FALLBACK
    /*
    uint public lastValueSent;
    string public lastFunctionCalled;

    uint public myUint;

    function setMyUint(uint _myNewUint) public{
        myUint = _myNewUint;
    }

    receive() external payable {
        lastValueSent = msg.value;
        lastFunctionCalled = "receive";
    }

    fallback() external payable {
        lastValueSent = msg.value;
        lastFunctionCalled = "fallback";
    }
    */

    // STRING lecture
    /*
    string public ourString = "Hello World";

    /*function updateOurString(string memory myString) public {
        ourString = myString;
    } */

    // BOOL lecture
    /*bool public myBool;

    function setMyBool(bool _myBool) public{
        myBool = _myBool;
    } */

    // UINTs lecture
    /*
    uint256 public myUint; //note: Initializing with default value costs gas! 
    uint8 public myUint8 = 2**4;

    function setMyUint(uint _myUint) public {
        myUint = _myUint;
    }

    //trigger an error with uint8
    function incrementUint8() public {
        myUint8++;
    } 

    function decrementUint() public {
        unchecked {
        myUint--;
        }
    }
    */

    // COMPARE/MODIFY STRINGS
    /*
    string public myString = "Hello World";
    bytes public myBytes = unicode"Hello Wörld";

    function setMyString(string memory _myString) public {
        myString = _myString;
    }

    function compareTwoStrings(string memory _myString) public view returns(bool){
        return keccak256(abi.encodePacked(myString)) == keccak256(abi.encodePacked(_myString));
    }

    function getBytesLength() public view returns(uint) {
        return myBytes.length;
    }
    */

    // CONSTRUCTOR, ADDRESS
    /*
    address public myAddress;

    constructor (address _someAddress) {
        myAddress = _someAddress;
    }

    function setMyAddress(address _myAddress) public {
        myAddress = _myAddress;
    }

    function setMyAddressToMsgSender() public {
        myAddress = msg.sender;
    }

    function getAddressBalance() public view returns(uint){
        return myAddress.balance;
    }
    */

    //Blockchain Messenger example
    // store string on blockchain - ok
    // Make it publicly readable - ok
    // Only the contract deployer can write the string - ok
    // How many times the string was updated - ok

    /*
    string public storedString;
    uint8 public updateCounter;
    address public contractDeployer;
    
    constructor() {
        contractDeployer = msg.sender;
    }

    function updateStoredString(string memory _newString) public payable {
        require(msg.sender == contractDeployer);
        require(msg.value >= 1 ether);
        storedString = _newString;
        updateCounter++;
    }
    */
}