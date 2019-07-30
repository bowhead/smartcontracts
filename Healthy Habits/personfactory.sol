pragma solidity ^0.4.20;

import './communication.sol'; // Import Communication contract.

/** @title Person.*/
contract PersonFactory is Communication {

    // TYPES

    struct _Person { // Person Data struct.
        mapping ( string => Info ) info; // Mapping.
        TimeZone timeZone; // TimeZone struct.
        uint lastHourCero; // Timestamp at 0:00 of that day.
        uint count; // DataType per day count.
        uint record; // Consecutive days.
        uint level; // Level of the address.
        address invited; // Address that invite the address.
        uint invitedTimes; // Times to receive the bonus.
        bool recompenseSent; // Know if the bonus has already been sent.
        uint lastCompletedCycle;
        uint[] badges;
        uint consecutiveDays;
    }

    struct TimeZone { // Time Zone struct.
        string sign; // Sign of the time zone.
        uint hour; // Hour of the time zone.
        uint minute; // Minute of the time zone.
    }

    struct Info { // Info struct.
        bytes32 IPFSHash; // IPFS 32 chars.
        bytes14 IPFSHash2; // IPFS 14 chars.
        uint times; // Time per in the day (example).
        uint timestamp; // Timestamp.
    }

    // Mapping of the _Person struct with an address.
    mapping ( address => _Person ) person;

    // PUBLIC METHODS

    /**
    * @param _dataType String - Data Type name.
    * @return name Bytes32 - IPFS 32 chars.
    * @return hash1 Bytes32 - IPFS 32 chars.
    * @return hash2 Bytes14 - IPFS 14 chars.
    * @return times Uint - Times to complete the cycle per day.
    * @return timestamp Uint -
    */
    function getInformationData( string _dataType )
    public
    constant
    returns ( string name, bytes32 hash1, bytes14 hash2, uint times, uint timestamp )
    {
        _Person storage p = person[msg.sender];
        return ( _dataType, p.info[_dataType].IPFSHash, p.info[_dataType].IPFSHash2, p.info[_dataType].times, p.info[_dataType].timestamp );
    }
    
    function getTaskArray()
        public
        constant 
        returns ( uint[] )
    {
        _Person storage p = person[msg.sender];
        uint[] memory array = new uint[]( dtint.getDataTypesLength());
        array[0] = 0;
        if ( p.lastHourCero + 1 days < now ){
            for( uint i = 1; i < dtint.getDataTypesLength(); i++){
                array[i] = 0;
            }
        } else {
            for( uint x = 1; x < dtint.getDataTypesLength(); x++){
                array[x] = p.info[ dtint.getDataTypeNameById(x)].times;
            }
        }
        return array;
    }

}
