
verified address - ``` 0xa9057d3BDFfCf0E969c34ff69E120C40336D1375 ```

# Assets - ATS 

- A Non Fungible Token developed using Hardhat development environment. 
- Implemented using ERC721 (Ethereum Request Comments 721) interface.
- It is deployed on the sepolia testnet (not deployed on any mainnet yet).

#### Getting started

- For briefing the commands you can refer the [Hardhat](https://katherineoelsner.com/) docs.

1. clone the project 
    ```  
    https://github.com/Gagan2095/ERC721-Assets.git
    ```
    
2. install the dependencies
    ```
    npm install
    ```

3. To compile the contracts run: 
    ```
    npm run compile
    ```
4. After compile write some test in test/Token.js file and run:
    ```
    npm run test
    ```
5. After testing the contract, deploy it on any testnet, here i am using sepolia testnet.
    ```
    npx hardhat ignition deploy ./ignition/modules/Token.js --network sepolia
    ```
or you can directly verify the Contract by running:
    ```
    npx hardhat ignition deploy ignition/modules/Token.js --network sepolia --verify
    ```

- You have to set some environment variables also which are set by using some hardhat commands as they are saved in the hardhat project.

- ```INFURA_API_KEY``` - create an account on INFURA and make an api key and use it here.
- ```SEPOLIA_PRIVATE_KEY``` - this will be your wallet private key (Here i have used my metamask wallet private key).
- ```ETHERSCAN_API_KEY``` - create an account on etherscan , create an api key and use it here.

- To see all the variables run: ``` npx hardhat vars setup ```
- To set the varaibles run: ``` npx hardhat vars set <varaible-name> ``` 