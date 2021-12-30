# How can I test landmanager smart contract with hardhat ?

Download all the content of this folder on your machine

Install nodejs


Install npm

```npm i npm```


Install hardhat (and all the required dependencies)

```npm i hardhat```



In the hardhat config file, set timeout to minimum 100000 (add this in hardhat.config.js :

 ```
 mocha: {
 timeout: 100000
 }
 ```


 Test the smart contract with the following command 
 
 ```npx hardhat test ```
