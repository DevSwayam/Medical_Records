import web3 from './web3';
import Record from './build/Record.json';

const instance = new web3.eth.Contract(
    Record,
    '0x930bdFCAD1D1b0F260BA0816327f7DeD9Fb56446' //Deployed Contract Code //Everytime contract code is changed and compiled, need to update this
);

export default instance;

//Whenever there is a change in Solidity code, use this few commands
//Step 1: cd ethereum
//Step 2: node compile.js
//Step 3: node deploy.js
//Step 4: Paste the contract deployed address above