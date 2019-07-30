pragma solidity ^0.4.20;

import './persondata.sol'; // Import Person contract.

/** @title BowheadGame.*/
contract BowheadGame is PersonData {
    
    // EVENTS
    
    event Received( address payer, uint256 amount, uint256 balance );
    
    constructor() public payable {}
    
    // PUBLIC METHODS
    
    /**
    * @return Uint - The contract balance.
    */
    function getContractBalance() 
        onlyOwner 
        public
        constant
        returns ( uint ) 
    {
        return address(this).balance;
    }
    
    /**
    * @dev Refill the contract balance.
    */
    function refill() 
        public
        payable
    {
        emit Received( msg.sender, msg.value, address(this).balance );
    }
    
}