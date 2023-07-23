const assert = require('assert');
const ganache = require('ganache');
const { Web3 } = require('web3');
const web3 = new Web3(ganache.provider());
const { abi, evm } = require('../compile');

let accounts;
let inbox;

const INITIAL_STRING = 'Initial message';

beforeEach(async () => {
    //Get list of accounts
    accounts = await web3.eth.getAccounts();

    // Use one account to deploy the contract
    inbox = await new web3.eth.Contract(abi)
        .deploy({
            data:bytecode,
            arguments: [INITIAL_STRING]
         })
        .send({ 
            from: accounts[0],
            gas: '1000000'
        })
});

describe('Inbox', () => {
    it('deploy a contract', () => {
        assert.ok(inbox.options.address);
    });

    it('check default message', async () => {
        const message = await inbox.methods.message().call();
        assert.equal(message, INITIAL_STRING);
    });

    it('check setmessage', async () => {
        //Update message
        const newMessage = 'new message';
        await inbox.methods.setMessage(newMessage).send({ from: accounts[0]});
        //check result
        const message = await inbox.methods.message().call();
        assert.equal(message, newMessage);
    });
});