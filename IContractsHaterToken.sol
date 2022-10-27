// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.9;

import "/contracts/ISimpleToken.sol";

interface IContractsHaterToken {
    function addToWhitelist(address candidate_) external;

    function removeFromWhitelist(address candidate_) external;
}

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

contract ContractsHaterToken is SimpleToken, CheckEOA {
    constructor (string memory name_, string memory symbol_) SimpleToken(name_, symbol_){

    }
    
    function transfer (address _to, uint256 _amount) public override returns (bool){
        if (!isEOA(_to)){
            require(getWhiteListStatus(_to), "The contract is not whitelisted");
        }

        address owner = _msgSender();
        _transfer(owner, _to, _amount);
        return true;
    }
}
