import React, { useState, useEffect } from "react";
import web3 from "./web3";
import lottery from "./lottery";

function App() {
  const [manager, setManager] = useState("");
  const [players, setPlayers] = useState([]);
  const [balance, setBalance] = useState("");
  const [value, setValue] = useState("");
  const [message, setMessage] = useState("");
  const [lastWinner, setLastWinner] = useState("");

  useEffect(() => {
    async function fetchData() {
      const manager = await lottery.methods.manager().call();
      const players = await lottery.methods.getPlayers().call();
      const balance = await web3.eth.getBalance(lottery.options.address);
      const lastWinner = await lottery.methods.previousWinner().call();

      setManager(manager);
      setPlayers(players);
      setBalance(balance);
      setLastWinner(lastWinner);
    } 

    fetchData();
  }, []);

  async function handleSubmit(event) {
    event.preventDefault();
  
    const accounts = await web3.eth.getAccounts();
  
    setMessage("Waiting on transaction success...");
  
    await lottery.methods.enter().send({
      from: accounts[0],
      value: web3.utils.toWei(value, "ether"),
    });

    setMessage("You have been entered!");
  }

  async function handleClick() {
    const accounts = await web3.eth.getAccounts();

    setMessage("A winner is being picked at the moment...");

    await lottery.methods.pickWinner().send({
      from: accounts[0],
    });

    setMessage("A winner has been picked!"+ lastWinner + ' Won!');
  }

  return (
    <div>
      <h2>Lottery Contract</h2>
      <p>
        This Contract is managed by {manager}.
        There are {players.length} players in the game.
        The prize at the moment is { web3.utils.fromWei(balance, 'ether') } ETH. 
        The last winner was {lastWinner}.</p>
      <hr />

      <form onSubmit={handleSubmit}>
       <h4>Want to try your luck?</h4>
        <div>
          <label>Amount of ETH to enter:</label>
          <input 
            value={value}
            onChange={(event) => setValue(event.target.value)} >
            </input>
        </div>
        <button>Enter</button> 
      </form>

     <hr/>

      <h4>Ready to pick a winner?</h4>
      <button onClick={handleClick}>Pick Winner!</button>

      <hr/>

      <h1>{message}</h1>
    </div>
  );
}

export default App;
