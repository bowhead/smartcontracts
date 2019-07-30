pragma solidity ^0.4.20;

/** @title Ownable.*/
contract Ownable {

    // TYPES

    address private owner; // Owner of the contract

    // MODIFIERS

    // Check if the sender is the owner of the contract.
    modifier onlyOwner {
        require( msg.sender == owner );
        _;
    }

    /**
    * @dev This function is executed at initialization and sets the owner of the contract
    */
    constructor() public {
        owner = msg.sender;
    }

    // PUBLIC METHODSS

    /**
    * @dev Function to recover the funds on the contract
    */
    function kill() onlyOwner public {
        selfdestruct( owner );
    }

}