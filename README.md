# DLab Test Task
I used the remix ide as the simpliest one for development and deployment. My contracts' calls and calling the "Validate" function was done via the web interface of the goerliscan as it allows easy encoding the arguments and calling the read/write functions with the browser injected wallet (Metamask in my case)

2 files for each contract: the general version and the flattened one (with all imported libraries included in the code)

The code of every SC is verified on the goerliscan and it matches with the flattened versions of the code published in this repository

#### Address used for deployment: [0x5fd0c3c8b84e914f34231dfb1eda39ef19bbb98c](https://goerli.etherscan.io/address/0x5fd0c3c8b84e914f34231dfb1eda39ef19bbb98c)

#### SimpleToken contract: [0x13449a12efe5a596e5429234cf302b861b95723c](https://goerli.etherscan.io/address/0x13449a12efe5a596e5429234cf302b861b95723c)

Instantinated with "SimpleToken", "ST"

#### ContractsHaterToken contract: [0x2fdb5F3cd7ef21Cd252fDeE8bE91DA7129209322](https://goerli.etherscan.io/address/0x2fdb5f3cd7ef21cd252fdee8be91da7129209322)

Instantinated with "ContractsHaterToken", "CHT"

#### MrGreedyToken contract: [0xd71e261D604D40a43cCA6597e8E3EBa25f519878](https://goerli.etherscan.io/address/0xd71e261d604d40a43cca6597e8e3eba25f519878)

Instantinated with "MrGreedyToken", "MRG", 0x5fd0c3c8b84e914f34231dfb1eda39ef19bbb98c (treasury). The decimals() function returns 6

The ownership over the contracts is transferred to the [validator contract](https://goerli.etherscan.io/address/0x4b2713aae6e378156ee3449c2eae7ed5b5ea78c2)

#### [My successfully confirmed TX](https://goerli.etherscan.io/tx/0x54bd7d275c98d72b538870af30b8890903fe7c68f293ea31a24bacbce4b47bda)

#### [⚠️ My unsuccessful TX](https://goerli.etherscan.io/tx/0x77b03e2d45baa52fd63c82dfb30826b47b56db63151bbf7e2e26e0aa028044d3) (missed the correct names of some functions (addToWhitelist(), removeFromWhitelist()) + there was a mistake of transferring 1 token to the treasury instead of 10)

----------------------------------------------------------------------------------------------------------------------------------------------------------------

Libraries used: OpenZeppelin Ownable.sol & ERC20.sol

   ⚠️There are no overflow checks because in the Solidity compiler 0.8.0 or better, math overflows revert by default. We use 0.8.9 so everything should be OK. OpenZeppelin libraries sometimes use the unchecked addition and subtraction where it is safe in order to use less gas during the execution. 

   Implemented the contract with the functions used to check whether the address is EOA or not (by checking the size of the code at a given address) and to add/remove the contract from the whitelist
   
The whitelist itself is a map from address to a boolean value (true if a contract is whitelisted)

```bash
abstract contract CheckEOA is Ownable {
    mapping (address => bool) public isWhiteListedContract;

    event AddedWhiteList(address _contract);

    event RemovedWhiteList(address _contract);

    function addToWhitelist (address _whitelistedContract) public onlyOwner {
        isWhiteListedContract[_whitelistedContract] = true;
        emit AddedWhiteList(_whitelistedContract);
    }

    function removeFromWhitelist (address _blacklistedContract) public onlyOwner {
        isWhiteListedContract[_blacklistedContract] = false;
        emit RemovedWhiteList(_blacklistedContract);
    }

    function isEOA(address _checkedAddress) public view returns (bool){
        uint size;
        assembly { size := extcodesize(_checkedAddress) }
        return size == 0;
    }

    function getWhiteListStatus(address _contract) public view returns (bool) {
        return isWhiteListedContract[_contract];
    } 
}
```
