pragma solidity ^0.4.20;

import './personfactory.sol'; // Import PersonFactory contract.

/** @title PersonInvited.*/
contract PersonInvited is PersonFactory {
    
    // TYPES
    
    uint internal bonus; // Invited reward.
    
    uint internal bonusTimes; 
    
    // EVENTS
    
    event Invited( address  from, address  to, uint  reward );
    
    // PUBLIC METHODS
    
    constructor() public {
        bonus = 1000000000000000;
        bonusTimes = 2;
    }
    
    /**
    * @param _address - Set the address.
    */
    function setInvited( address _address ) public {
        person[msg.sender].invited = _address;
    }
    
    function getInvited()
        public 
        constant
        returns ( address )
    {
        return person[msg.sender].invited;
    }
    
    /**
    * @dev _bonus Uint -  Set bonus.
    * @param _bonus String - Data Type name.
    */
    function setBonus( uint _bonus ) 
        onlyOwner
        public 
    {
        bonus = _bonus;
    }
    
    /**
    * @return Uint - The bonusTimes.
    */
    function getBonusTimes() 
        onlyOwner
        public
        constant
        returns ( uint )
    {
        return bonusTimes;
    }
    
    /**
    * @dev _bonusTimes Uint -  Set bonusTimes.
    * @param _bonusTimes String - Data Type name.
    */
    function setBonusTimes( uint _bonusTimes ) 
        onlyOwner
        public 
    {
        bonusTimes = _bonusTimes;
    }
    
    /**
    * @return Uint - The bonus.
    */
    function getBonus() 
        onlyOwner
        public
        constant
        returns ( uint )
    {
        return bonus;
    }
    
}