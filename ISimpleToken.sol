// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.9;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";

interface ISimpleToken {
    function mint(address to_, uint256 amount_) external;

    function burn(uint256 amount_) external;
}

contract SimpleToken is ERC20, ISimpleToken, Ownable {

    constructor(string memory name_, string memory symbol_) ERC20(name_, symbol_){

    }

    function mint(address to_, uint256 amount_) public onlyOwner {
        //In 0.8.0 or better, math overflows revert by default 
        _mint(to_, amount_);
    }

    function burn(uint256 amount_) public {
        _burn(msg.sender, amount_);
    }

}
