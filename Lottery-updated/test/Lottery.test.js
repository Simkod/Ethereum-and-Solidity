const assert = require('assert');
const ganache = require('ganache');
const { Web3 } = require('web3');
const web3 = new Web3(ganache.provider());

const { abi, evm } = require('../compile');

let lottery;
let accounts;

beforeEach(async () => {
    accounts = await web3.eth.getAccounts();
    
    lottery = await new web3.eth.Contract(abi)
        .deploy({ data: evm.bytecode.object })
        .send({ from: accounts[0], gas: '1000000' });
});

describe('Lottery Contract', () => {
    it('Check contract deployment', () => {
        assert.ok(lottery.options.address);
    });

    it('Check 1 player enter', async () => {
        await lottery.methods.enter().send({
            from: accounts[0],
            value: web3.utils.toWei('2', 'ether')
        });
        
        const players = await lottery.methods.getPlayers().call({
            from: accounts[0]
        });
        assert.equal(1, players.length);
        assert.equal(accounts[0], players[0]);
    });

    it('Check multiple player enter', async () => {
        await lottery.methods.enter().send({
            from: accounts[0],
            value: web3.utils.toWei('2', 'ether')
        });

        await lottery.methods.enter().send({
            from: accounts[1],
            value: web3.utils.toWei('2', 'ether')
        });

        await lottery.methods.enter().send({
            from: accounts[2],
            value: web3.utils.toWei('2', 'ether')
        });
        
        const players = await lottery.methods.getPlayers().call({
            from: accounts[0]
        });

        assert.equal(3, players.length);
        assert.equal(accounts[0], players[0]);
        assert.equal(accounts[1], players[1]);
        assert.equal(accounts[2], players[2]);
    });

    it('Check player entry fee', async () => {
        try {
            await lottery.methods.enter().send({
                from: accounts[0],
                value: 0
            });
            assert(false);
        } catch (err) {
            assert(err);
        }
    });
    
    it('Check pickWinner caller', async () => {
        try{
            await lottery.methods.pickWinner().send({
                from: accounts[1]
            });
            assert(false);
        } catch (err){
            assert(err);
        }        
    }) 

    it('End-to-end', async () => {
        await lottery.methods.enter().send({
            from: accounts[1],
            value: web3.utils.toWei('2', 'ether')
        });

        const initBalance = await web3.eth.getBalance(accounts[1]);
        await lottery.methods.pickWinner().send({ from: accounts[0]})
        const finalBalance = await web3.eth.getBalance(accounts[1]);
        const difference = finalBalance - initBalance;

        assert(difference > web3.utils.toWei('1.95', 'ether'));

        const players = await lottery.methods.getPlayers().call({
            from: accounts[0]
        });
        assert.equal(0, players.length);

        const contractBalance = await web3.eth.getBalance(lottery.options.address);
        assert.equal(0, contractBalance);
    });

    it('Check previous winner', async () => {
        await lottery.methods.enter().send({
            from: accounts[1],
            value: web3.utils.toWei('2', 'ether')
        });

        await lottery.methods.enter().send({
            from: accounts[2],
            value: web3.utils.toWei('2', 'ether')
        });

        await lottery.methods.pickWinner().send({ from: accounts[0]})
        
        const previousWinner1 = await lottery.methods.previousWinner().call();
        assert(previousWinner1 == accounts[1] || previousWinner1 == accounts[2]);


        await lottery.methods.enter().send({
            from: accounts[3],
            value: web3.utils.toWei('2', 'ether')
        });

        await lottery.methods.pickWinner().send({ from: accounts[0]})

        const previousWinner2 = await lottery.methods.previousWinner().call();
        assert.equal(previousWinner2, accounts[3]);
    });
});