
const abi = [{"inputs":[],"stateMutability":"nonpayable","type":"constructor"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"bool","name":"result","type":"bool"}],"name":"Flipped","type":"event"},{"inputs":[{"internalType":"uint256","name":"choice","type":"uint256"}],"name":"flipACoin","outputs":[],"stateMutability":"payable","type":"function"},{"inputs":[],"name":"flipper","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function"}]

const fcContract = web3 => {
    return new web3.eth.Contract(
        abi,
        "0x8d8E68729aD2d8Ad9b99757296b0A9496E53d41a"
    )
}

export default fcContract;