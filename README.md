# dlab_test
2 files for each contract: the general version and the flattened one (with all imported libraries included in the code)

Libraries used: OpenZeppelin Ownable.sol & ERC20.sol

    ⚠️There are no overflow checks because in the Solidity compiler 0.8.0 or better, math overflows revert by default. We use 0.8.9 so everything should be OK. OpenZeppelin libraries sometimes use the unchecked addition and subtraction where it is safe in order to use less gas during the execution. 

    Implemented the contract with the functions used to check whether the address is EOA or not (by checking the size of the code at a given address) and to add/remove the contract from the whitelist
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
