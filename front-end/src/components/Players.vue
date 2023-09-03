<script setup>
    import { toNumber } from '@vue/shared';
    import { ref } from 'vue';

    const player = ref(100);
    const computer = ref(100);

    function addPlayer(amount){
        if(!isNaN(amount) && amount <= player.value){
            player.value += amount;
        }
    }

    function addComputer(amount){
        if(!isNaN(amount)){
            computer.value += amount;
        }
    }
</script>
<!--
    changed computer score to net score and set at 0 and then add buttons for picking heads or tails, add choice to smart contract
-->
<template>
    <div>
        <span>
            <h2>Player's Score</h2>
            <h3> {{ player }}</h3>

        </span>
        <span>
            <h2>Computer's Score</h2>
            <h3>{{ computer }}</h3>
        </span>
    </div>
    <input type="number" placeholder="Enter bet" v-model="value" @keypress.enter="addPlayer(toNumber(value))">
    <button @click="addPlayer(toNumber(value))">Wager</button>
</template>

<style scoped>
button{
    border-radius: 5%;
    font: 18px;
    background-color: gray;
    height: 30px;
}

input{
    font-size: 15px;
}
</style>