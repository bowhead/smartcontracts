pragma solidity ^0.4.20;

import './personhelper.sol'; // Import PersonHelper contract.

/** @title PersonData.*/
contract PersonData is PersonHelper {
    
    // EVENTS
    
    event Data( address  from, uint  reward, string  dataType, bytes32 hash1, bytes14 hash2, uint timestamp );

    event Cycles( address user );
    
    // PUBLIC METHODS
    
    function saveHash( string _dataType, bytes32 _hash1, bytes14 _hash2, uint _timestamp )  public {
        
        _Person storage p = person[msg.sender]; // Person struct.
        require( dtint.getState( _dataType ) ); // Check if the Data Type state is true.
        //Check if the day is over to restart the available reward per day.
        if( dtint.isDayOver() ){
            dtint.restartReward();
        }
        // If the users stop using the app for a week, lose one level.
        //if( p.lastHourCero < getHourCero() - 1 weeks ){
        if( isMoreThanAWeek() ){
            // Check if the user is in the level 0.
            if( p.level != 0 ){
                p.level--; // Level down.
                //p.record = lvlint.getDayById( p.level ); // Reset to the last level consecutive days.
                p.record = 0; // Reset to the last level consecutive days.
                p.consecutiveDays = 0;
                emit Level( msg.sender, p.level, lvlint.getMultiplierById( p.level )); // Emit the Level event.
            }
        } 
        // Restart the record of the user if the user didn't the cycle in one day.
        //if( p.lastCompletedCycle + 1 days < getHourCero() ){
        if( isMoreThanADay() ){
            p.record = 0; // Reset to the last level consecutive days.
            p.consecutiveDays = 0;
        }
        if( ( dtint.getTimes( _dataType ) > p.info[_dataType].times ) && ( p.lastHourCero + dtint.getTime( _dataType ) >= now && p.lastHourCero <= now ) && ( dtint.getToCount( _dataType ) ) ){
            p.count++;
            if( p.count == dtint.getTimesPerDay() ){
                p.record++;
                p.count = 0;
                p.lastCompletedCycle = now;
                p.consecutiveDays++;
                emit Cycles( msg.sender );
            }
            p.info[_dataType].times++;
            p.info[_dataType].timestamp = _timestamp;
        } else if ( p.lastHourCero + dtint.getTime( _dataType ) < now && ( dtint.getToCount( _dataType ) ) ) {
            p.lastHourCero = getHourCero();
            p.info[_dataType].timestamp = _timestamp;
            for( uint i = 1; i < dtint.getDataTypesLength(); i++){
                if( dtint.getToCount( dtint.getDataTypeNameById( i ) ) ) {
                    p.info[ dtint.getDataTypeNameById( i ) ].times = 0;
                }
            }
            p.count = 1;
            p.info[_dataType].times++;
        } else if( p.info[_dataType].timestamp + dtint.getTime( _dataType ) < now && !( dtint.getToCount( _dataType ) ) ) {
            p.lastHourCero = getHourCero();
            p.info[_dataType].times = 1;
            p.info[_dataType].timestamp = _timestamp / 1000;
        } else if( dtint.getToCount( _dataType ) ){
            p.info[_dataType].times++;
            p.info[_dataType].timestamp = _timestamp;
        } else if( !( dtint.getToCount( _dataType ) ) ) {
            p.info[_dataType].times++;
        }
        p.info[_dataType].IPFSHash = _hash1;
        p.info[_dataType].IPFSHash2 = _hash2;

        // Reward.
        uint reward = dtint.getReward( _dataType ) * lvlint.getMultiplierById( p.level ); // Calculate the reward ofthe address.
        if ( p.info[_dataType].times > dtint.getTimes( _dataType ) ){
            emit Data( msg.sender, 0, _dataType, _hash1, _hash2, _timestamp);
        } else if( address(this).balance <= reward && address(this).balance >= 0 ){
            emit Data( msg.sender, address(this).balance, _dataType, _hash1, _hash2, _timestamp);// Emit the Data event.
            msg.sender.transfer( address(this).balance ); // Transfer.
        } else if( dtint.getRewardPerDay() >= reward ){
            msg.sender.transfer( reward ); // Transfer.
            emit Data( msg.sender, reward, _dataType, _hash1, _hash2, _timestamp);// Emit the Data event.
        } else if( dtint.getRewardPerDay() <= reward || dtint.getRewardPerDay() > 0 ) {
            msg.sender.transfer( dtint.getRewardPerDay() ); // Transfer.
            emit Data( msg.sender, dtint.getRewardPerDay(), _dataType, _hash1, _hash2, _timestamp); // Emit the Data event.
        }
        // Address level up.
        if( p.level != lvlint.getLevelLength() - 1){
            if( p.level + 1 <= lvlint.getLevelLength() - 1){
                if( p.record == lvlint.getDayById( p.level + 1 ) ){
                    p.level++; // Level down.
                    p.record = 0;
                    emit Level( msg.sender, p.level, lvlint.getMultiplierById( p.level ) ); // Emit the Level event.
                } else if ( p.record > lvlint.getDayById( p.level + 1 ) ){
                    p.level = getNewLevel( p );
                    p.record = 0;
                    emit Level( msg.sender, p.level, lvlint.getMultiplierById( p.level ) ); // Emit the Level event.
                }
            }
        }
        // Transfer the bonus to the address.
        if( p.level == 1 && p.recompenseSent ==  false && p.invited != 0 && p.invitedTimes <= bonusTimes ){
            if( address(this).balance <= bonus && address(this).balance >= 0 ){
                p.invited.transfer( address(this).balance ); // Transfer the bonus.
                p.recompenseSent = true;
                emit Invited( msg.sender, p.invited, address(this).balance); // Emit the Data event.
            } else if ( address(this).balance >= bonus * 2){
                p.invited.transfer( bonus ); // Transfer the bonus.
                msg.sender.transfer( bonus ); // Transfer the bonus.
                p.recompenseSent = true;
                emit Invited( msg.sender, p.invited, bonus ); // Emit the Data event.
                emit Invited( address(this), msg.sender, bonus ); // Emit the Data event.
            }
            p.invitedTimes++;
        }
    }
    
}