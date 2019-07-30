pragma solidity ^0.4.20;

/** @title DataInterface.*/
contract DataInterface {
    
    function restartReward() public pure returns ( bool ) {}
    
    function isDayOver() public pure returns ( bool ) {}
    
    function getIdByName( string ) public pure returns ( uint ) {}

    function getReward( string ) public pure returns ( uint ) {}

    function getTimes( string ) public pure returns ( uint ) {}

    function getTime( string ) public pure returns ( uint ) {}

    function getState( string ) public pure returns ( bool ) {}

    function getToCount( string ) public pure returns ( bool ) {}

    function getAvailable() public pure returns ( uint ) {}
    
    function getTimesPerDay() public pure returns ( uint ) {}
    
    function getRewardPerDay() public pure returns ( uint ) {}
    
    function getDataTypesLength() public pure returns ( uint ) {}
    
    function getDataTypeNameById( uint ) public pure returns( string ) {}

}