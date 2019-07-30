pragma solidity ^0.4.20;

import './persontimezone.sol'; // Import PersonTimeZone contract.

/** @title PersonHelper.*/
contract PersonHelper is PersonTimeZone {
    
    // EVENTS.
    
    event Level( address user, uint level, uint multiplier );
    
    event Badge( address user, uint badge );
    
    // INTERNAL METHODS.

    /**
    * @dev Get the new level of an specific struct.
    * @param p - _Person - _Person struct.
    */
    function getNewLevel( _Person p)
        internal
        constant
        returns ( uint )
    {
        uint newLevel;
        if( p.record >= lvlint.getDayById( lvlint.getLevelLength() - 1 )){
            newLevel = lvlint.getLevelLength() - 1;
        } else {
            for( uint lvl = p.level + 1 ; lvl < lvlint.getLevelLength() ; lvl++ ){
                if( p.record >= lvlint.getDayById(lvl) && p.record <= lvlint.getDayById(lvl + 1) ){
                    newLevel = lvl; // Set the new level.
                    break;
                }
            }
        }
        return newLevel;
    }

    // PUBLIC METHODS

    /**
    * @dev Push the new badge id.
    * @param _id String - ID of the badge.
    */
    function setBadges( uint _id ) public {
        _Person storage p = person[msg.sender];
        p.badges.push(_id);
        emit Badge( msg.sender, _id );
    }

    /**
    * @return Uint[] - The badges array.
    */
    function getBadges()
        public
        constant
        returns ( uint[] )
    {
        uint[] memory temp = new uint[](1);
        if ( person[msg.sender].badges.length == 0 ){
            temp[0] = 0;
            return temp;
        }
        else {
            return person[msg.sender].badges;
        }
    }

    /**
    * @return count Uint - DataType per day count.
    * @return record Uint - Consecutive days.
    * @return level Uint - Level of the address.
    * @return hourCero Uint - Timestamp at 0:00 of that day.
    */
    function getLevelData()
    public
    constant
    returns ( 
        uint count, 
        uint record, 
        uint level, 
        uint multiplier, 
        uint hourCero, 
        uint lastCycle, 
        uint levelDays,
        uint consecutiveDays
        )
    {
        _Person storage p = person[msg.sender];
        if( isMoreThanAWeek() && ( p.level != 0) ){
            return ( 
                0, 
                0, 
                p.level - 1, 
                lvlint.getMultiplierById( p.level - 1 ),
                p.lastHourCero, 
                p.lastCompletedCycle, 
                lvlint.getDayById( p.level ), 
                0 
            );
        } else if ( isMoreThanADay() && ( p.level == lvlint.getLevelLength() - 1 ) ){
            return ( 
                0, 
                0, 
                p.level, 
                lvlint.getMultiplierById( p.level ),
                p.lastHourCero, 
                p.lastCompletedCycle, 
                lvlint.getDayById(p.level ), 
                0 
            );
        } else if ( isMoreThanADay() ){
            return ( 
                0, 
                0, 
                p.level, 
                lvlint.getMultiplierById( p.level ),
                p.lastHourCero, 
                p.lastCompletedCycle, 
                lvlint.getDayById( p.level + 1 ), 
                0 
            );
        } else if ( p.level == lvlint.getLevelLength() - 1 ){
            return ( 
                p.count, 
                p.record, 
                p.level, 
                lvlint.getMultiplierById( p.level ),
                p.lastHourCero, 
                p.lastCompletedCycle, 
                lvlint.getDayById( p.level ), 
                p.consecutiveDays 
            );
        } else {
            return ( 
                p.count, 
                p.record, 
                p.level, 
                lvlint.getMultiplierById( p.level ),
                p.lastHourCero, 
                p.lastCompletedCycle, 
                lvlint.getDayById( p.level + 1 ), 
                p.consecutiveDays 
            );
        }
    }
    
}
