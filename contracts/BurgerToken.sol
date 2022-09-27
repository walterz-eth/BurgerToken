//SPDX-License-Identifier: MIT

pragma solidity ^0.8.6;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

contract BurgerToken is ERC20, AccessControl {
    
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

    event BurgerPurchased (address indexed _receiver, address indexed _buyer, uint _amount);

    constructor() ERC20("Burger Token", "BUR") {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(MINTER_ROLE, msg.sender);
    }

    function mint(address to, uint256 amount) public onlyRole(MINTER_ROLE) {
        _mint(to, amount);
    }

    function purchaseBurger (uint _amount) external {
        _burn (_msgSender(), _amount);

        emit BurgerPurchased(_msgSender(), _msgSender(), _amount);
    }

}