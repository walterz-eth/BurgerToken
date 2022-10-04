//SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

// Abstract ERC20 class to use as a "wrapper" for contract address when injected in constructor argument
abstract contract ERC20 {
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) public virtual returns (bool);
    function decimals() public view virtual returns (uint8);
}

contract BurgerTokenSale {

    uint private tokenPriceInWei = 1 ether; //TODO: implement an oracle to get price from outside the chain

    ERC20 private token;
    address public owner;

    constructor (address _tokenContract) {
        token = ERC20(_tokenContract);

        // note that this contract's owner might not be the same owner of BurgerToken contract
        owner  = msg.sender;
    }

    function buyOneBUR () external payable {
        require (msg.value >= tokenPriceInWei, "Amount of ETH is not enough to buy 1 BUR");

        uint tokensToTransfer = msg.value / tokenPriceInWei;
        uint remainder = msg.value - tokensToTransfer * tokenPriceInWei;

        // Pre conditions:
        // 1. owner of this contract had previously minted n amount of tokens using BurgerToken.mint
        // 2. this contract must be allowed to spend on behalf of this contract's owner
        //
        // Finally, what will happen is this: [this.contractAddress] tries to transfer from [owner] to [msg.sender]
        //
        token.transferFrom (owner, msg.sender, 1 * 10**token.decimals());
        payable (msg.sender).transfer (remainder);

    }
}