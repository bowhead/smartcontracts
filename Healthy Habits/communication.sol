pragma solidity ^0.4.20;

import './levelinterface.sol'; // Import LevelInterface contract.
import './datainterface.sol'; // Import DataInterface contract.
import './ownable.sol'; // Import Ownable contract.

contract Communication is DataInterface, LevelInterface, Ownable {
    
    LevelInterface internal lvlint; // LevelInterface contract.
    
    DataInterface internal dtint; // DataInterfaceContract.
    
    address internal levelContractAddress; // Address to access to the Level contract.
    
    address internal dataContractAddress; // Address to access to the Data contract.
    
    /**
    * @param _address - Address - the levelContractAddress to set.
    */
    function setLevelContract( address _address )
        public
        onlyOwner
    {
        levelContractAddress = _address;
        lvlint = LevelInterface( levelContractAddress );
    }
    
    /**
    * @return Address - the levelContractAddress.
    */
    function getLevelContract()
        public 
        constant
        onlyOwner
        returns ( address )
    {
        return levelContractAddress;
    }
    
    /**
    * @param _address - Address - the dataContractAddress to set.
    */
    function setDataContract( address _address )
        public
        onlyOwner
    {
        dataContractAddress = _address;
        dtint = DataInterface(dataContractAddress);
    }
    
    /**
    * @return Address - the dataContractAddress.
    */
    function getDataContract()
        public
        constant
        onlyOwner
        returns ( address )
    {
        return dataContractAddress;
    }
    
}