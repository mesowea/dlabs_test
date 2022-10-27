// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.9;

import "/contracts/ISimpleToken.sol";

interface IMrGreedyToken {
    function treasury() external view returns (address);

    function getResultingTransferAmount(uint256 amount_) external view returns (uint256);
}

contract MrGreedyToken is IMrGreedyToken, SimpleToken {
    address public _treasury;
    constructor (string memory name_, string memory symbol_, address treasury_) SimpleToken(name_, symbol_){
        _treasury = treasury_;
    }

    function decimals() public pure override returns (uint8) {
        return 6;
    }

    function treasury() public view returns (address){
        return _treasury;
    }

    function getResultingTransferAmount(uint256 amount_) public pure returns (uint256){
        if (amount_ <= 10*10**decimals()) {
            return 0;
        }else{
            return amount_ - 10*10**decimals();
        }
    }

    function transfer (address _to, uint256 _amount) public override returns (bool){
        uint256 transferAmount = getResultingTransferAmount(_amount);
        //In 0.8.0 or better, math overflows revert by default 
        uint256 amountToTreasury = _amount - transferAmount;
        address owner = _msgSender();
        _transfer(owner, _to, transferAmount);
        _transfer(owner, treasury(), amountToTreasury);
        return true;
    }
}
