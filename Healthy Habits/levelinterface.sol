pragma solidity ^0.4.20;

/** @title LevelInterface.*/
contract LevelInterface {

    function getLevelLength() public pure returns ( uint ) {}

    function getMultiplierById( uint ) public pure returns ( uint ) {}

    function getDayById( uint ) public pure returns ( uint ) {}

}