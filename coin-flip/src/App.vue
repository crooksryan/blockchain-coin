<script setup>
import Web3 from 'web3';
import { ref, onMounted, watch } from 'vue';
import { toNumber } from '@vue/shared';
import fcContract from '../blockchain/coinFlip.js';


const connected = ref(false); // boolean to reference if the wallet is connected
const address = ref('');      // string that will store the address of the current wallet
const error = ref('');        // string to display any errors that occur
const amount = ref(0);        // int to hold account balance in Ether
const net = ref(0);           // int to keep track of users gain/lose in current session
const contract = ref(null);   // reference to smart contract
const message = ref('');      // message to display if user one or lost
const choice = ref(0);        // int for choice, heads = 0 and tails = 1
const value = ref('')         // value of input field
const loader = ref(0);


let web3;

// connects Metamask wallet
const connectWalletHandler = async () =>{
  if (window.ethereum){
    try{
      await window.ethereum.request({method: 'eth_requestAccounts'})
      web3 = new Web3(window.ethereum)
      error.value = '';

      // new 
      contract.value = fcContract(web3);
      isConnected();
    }
    catch (err){
      error.value = err.message;
    }
  }
  else{
    console.log("Please Install MetaMask")
  }
}

// gets the balance of account in Ether 
const getAmountHandler = async ()=>{
  if(connected){
    try{
      web3 = new Web3(window.ethereum)
      let balance = await web3.eth.getBalance(address.value);
      balance = web3.utils.fromWei(balance, 'ether')
      amount.value = balance;

    } catch(err){
      console.log(err);
    }
  }
}

// function to check if a wallet is connected
const isConnected = async ()=>{
  const account = await window.ethereum.request({'method': 'eth_accounts'})
  
  if(account.length == 0){
    connected.value = false;
  }
  else{
    connected.value = true;
    address.value = account[0];

    web3 = new Web3(window.ethereum);
    contract.value = fcContract(web3);
    getAmountHandler();

  }
}

// check to see if wallet is connected on mount
onMounted(()=>{
  isConnected();
});

// places bet and sends to smart contract
const bet = async(cost) => {

  // bet must be a number, less than the accounts holding, and positive
  if(!isNaN(cost) && cost <= amount.value && cost > 0 && connected){
    // call to contract function
    try{
      loader.value = 1;

      const outcomeBlock = await contract.value.methods.flipACoin(choice.value).send({
        from: address.value,
        value: web3.utils.toWei(cost.toString(), 'ether'),
      })

      const outcome = outcomeBlock.events.Flipped.returnValues.result;
      
      loader.value = 0;
      if (outcome){
        message.value = `You Won ${cost * 2} Ether`;
        net.value += 2 * cost;
      } else{
        message.value = `You Lost ${cost} Ether`;
        net.value -= cost;
      }
      getAmountHandler();
    } catch(err){
      console.log(err);
      loader.value = 0;
    }

    error.value = '';
  }
  else{
    if(!connected){
      error.value = "Connected Wallet before betting";
    }
    else{
      error.value = "Invalid bet";
    }
  }
};


// watch used to observe if site is loading a recent bet
watch(loader, (isLoading)=>{

  // transaction is loading
  if(isLoading === 1){
    message.value = "";
  }
});
</script>



<template>
  <div class="header">
    <h1>Coin Flip</h1>
    <button @click="connectWalletHandler" id="connect" v-if="!connected">Connect Wallet</button>
  </div>

  <div class="block">
  <h2>Balance: {{ amount }} ETH</h2>
  <h3>Net Change: {{ net }} ETH</h3>
  
  <div>
    <h3>Choice is:</h3>
    <button class="choice" @click="choice = 1" v-if="!choice">Heads</button>
    <button class="choice" @click="choice = 0" v-else>Tails</button>
  </div>

  <input type="number" placeholder="Enter Bet" v-model="value" @keypress.enter="bet(toNumber(value))"/>
  <button @click="bet(toNumber(value))">Click to bet</button>

  <div>
    <a href="https://www.infura.io/faucet" target="_blank" rel="noopener">Need More Sepolia?</a>
  </div>

  <div><p>{{ error }}</p></div>
  <h3 class="outcome">{{ message }}</h3>

  <span class="loader" v-if="loader"></span>
  </div>

  <div class="footer">
    <h3 v-if="address == ''">Connect Wallet</h3>
    <h3 v-else>Wallet: {{ address.substring(0, 5) }}...{{ address.substring(38) }}</h3>
    <p class="warning">*Gamble responsibly</p>
  </div>
</template>



<style scoped>

</style>
