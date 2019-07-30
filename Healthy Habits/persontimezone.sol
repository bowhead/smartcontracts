pragma solidity^0.4.20;

import './personinvited.sol'; // Import PersonInvited contract.
import './datetime.sol'; // Import DateTime contract.

/** @title PersonTimeZone.*/
contract PersonTimeZone is PersonInvited, DateTime {
    
    // EVENTS
    
    event Zone( address user, string sign, uint hour, uint minute );
    
    // PUBLIC METHODS
    
    /**
    * @dev Set the timeZone struct and calculate the timestamp at 0:00 of that day.
    * @param _sign String - Timezone sign.
    * @param _hour Uint - Timezone hour.
    * @param _minute Uint - Timezone minute.
    */
    function setTimeZone( 
        string _sign, 
        uint _hour, 
        uint _minute 
        ) public 
    {
        _Person storage p = person[msg.sender];
        p.timeZone.sign = _sign;
        p.timeZone.hour = _hour;
        p.timeZone.minute = _minute;
        p.lastHourCero = getHourCero();
        emit Zone( msg.sender, _sign, _hour, _minute );
    }
    
    /**
    * @return String - Sign of the time zone.
    * @return Uint - Hour of the time zone.
    * @return Uint - Minute of the time zone.
    */
    function getTimeZone()
        public
        constant
        returns ( string,uint, uint )
    {
        _Person storage p = person[msg.sender];
        return ( p.timeZone.sign, p.timeZone.hour, p.timeZone.minute );
    }
    
    /**
    * @dev Calculate the current hour depending of your the zone.
    * @return Uint Int - The current hour in a specific time zone.
    */
    function getLocalHour() 
        internal 
        constant 
        returns( uint )
    {
        string storage sign = person[msg.sender].timeZone.sign;
        uint hour = person[msg.sender].timeZone.hour;
        uint minute = person[msg.sender].timeZone.minute;
        if( compareSigns ( sign, "-" ) ) {
            return getHour( now - ( 1 hours * hour ) - ( 1 minutes * minute ) );
        } else if( compareSigns ( sign, "+" ) ) {
            return getHour( now + ( 1 hours * hour ) + ( 1 minutes * minute ) );
        }
    }
    
    /**
    * @dev Calculate the current minute depending of your the zone.
    * @return Uint Int - The current minute in a specific time zone.
    */
    function getLocalMinutes() 
        internal 
        constant 
        returns( uint )
    {
        string storage sign = person[msg.sender].timeZone.sign;
        uint hour = person[msg.sender].timeZone.hour;
        uint minute = person[msg.sender].timeZone.minute;
        if( compareSigns( sign, "-") ){
            return getMinute( now - ( 1 hours * hour ) - ( 1 minutes * minute ) );
        } else if ( compareSigns( sign, "+" ) ) {
            return getMinute( now + ( ( 1 hours * hour ) ) - ( 1 minutes * minute ) );
        }
    }
    
    /**
    * @return Uint - Timestamp at 0:00 of that day.
    */
    function getHourCero() 
        internal 
        constant 
        returns ( uint )
    {
        return now - ( 1 hours * getLocalHour() ) - ( 1 minutes * getLocalMinutes() ) - getSecond(now);
    }
    
    /**
    * @dev Compare two strings.
    * @return Bool - True if the strings are equals.
    */
    function compareSigns (string _a, string _b) 
        internal 
        pure 
        returns ( bool )
    {
        return keccak256(abi.encodePacked(_a)) == keccak256(abi.encodePacked(_b));
    }

    function isMoreThanAWeek() internal constant returns( bool ) {
        _Person storage p = person[msg.sender];
        if( p.lastHourCero < getHourCero() - 1 weeks )
            return true;
        else
            return false;
    }

    function isMoreThanADay() internal constant returns( bool ) {
        _Person storage p = person[msg.sender];
        if( p.lastCompletedCycle + 1 days < getHourCero() )
            return true;
        else 
            return false;
    }
    
    
}