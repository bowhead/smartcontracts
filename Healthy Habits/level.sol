pragma solidity ^0.4.20;

import "./ownable.sol"; // Import Ownable contract.


/** @title Level.*/
contract Level is Ownable {

    struct _Level { // Level struct.
        uint multiplier; // Multiplier.
        uint day; // Concurrent days to level up.
    }

    _Level[] internal levels; // Level struct array.

    constructor() public {
        // Default Levels.
        levels.push(_Level({
        multiplier: 1,
        day: 0
        }));
        // Level 1.
        levels.push(_Level({
        multiplier: 2,
        day: 1
        }));
        // Level 2.
        levels.push(_Level({
        multiplier: 3,
        day: 2
        }));
        // Level 3.
        levels.push(_Level({
        multiplier: 4,
        day: 5
        }));
        // Level 4.
        levels.push(_Level({
        multiplier: 5,
        day: 7
        }));
        // Level 5.
        levels.push(_Level({
        multiplier: 6,
        day: 10
        }));
        // Level 6.
        levels.push(_Level({
        multiplier: 7,
        day: 12
        }));
        // Level 7.
        levels.push(_Level({
        multiplier: 10,
        day: 15
        }));
        // Level 8.
        levels.push(_Level({
        multiplier: 13,
        day: 17
        }));
        // Level 9.
        levels.push(_Level({
        multiplier: 15,
        day: 20
        }));
        // Level 10.
        levels.push(_Level({
        multiplier: 20,
        day: 30
        }));
        // Level 11.
        levels.push(_Level({
        multiplier: 25,
        day: 60
        }));
        // Level 12.
        levels.push(_Level({
        multiplier: 30,
        day: 90
        }));
        // Level 13.
        levels.push(_Level({
        multiplier: 35,
        day: 120
        }));
        // Level 14.
        levels.push(_Level({
        multiplier: 40,
        day: 150
        }));
        // Level 15.
        levels.push(_Level({
        multiplier: 45,
        day: 180
        }));
        // Level 16.
        levels.push(_Level({
        multiplier: 50,
        day: 210
        }));
        // Level 17.
        levels.push(_Level({
        multiplier: 55,
        day: 240
        }));
        // Level 18.
        levels.push(_Level({
        multiplier: 60,
        day: 270
        }));
        // Level 19.
        levels.push(_Level({
        multiplier: 65,
        day: 300
        }));
        // Level 20.
        levels.push(_Level({
        multiplier: 70,
        day: 330
        }));
        // Level 21.
        levels.push(_Level({
        multiplier: 80,
        day: 360
        }));
    }

    // PUBLIC METHODS - ONLY OWNER


    /**
    * @param _multiplier Uint - multiplier to set.
    * @param _day Uint - concurrent days to set.
    */
    function createLevel( uint _multiplier, uint _day)
        public
        onlyOwner
    {
        levels.push(_Level({
            multiplier: _multiplier,
            day: _day
        }));
    }

    /**
    * @param _level Uint - level id to set
    * @param _multiplier Uint - multiplier to set.
    * @param _day Uint - concurrent days to set.
    */
    function setLevel( uint _level, uint _multiplier, uint _day )
    onlyOwner
    public
    {
        levels[_level].multiplier = _multiplier;
        levels[_level].day = _day;
    }

    /**
    * @param _level Uint - level id to set
    * @param _multiplier Uint - multiplier to set.
    */
    function setMultiplier( uint _level, uint _multiplier)
    onlyOwner
    public
    {
        levels[_level].multiplier = _multiplier;
    }

    /**
    * @param _level Uint - level id to set
    * @param _day Uint - concurrent days to set.
    */
    function setDay( uint _level, uint _day )
    onlyOwner
    public
    {
        levels[_level].day = _day;
    }

    /**
    * @dev Get the struct information
    * @param _level Uint - level id to get
    * @return Uint multiplier of the level id
    * @return Uint day of the level id
    */
    function getLevel( uint _level )
    onlyOwner
    public
    constant
    returns ( uint, uint )
    {
        return ( levels[_level].multiplier, levels[_level].day );
    }

    // PUBLIC METHODS

    /**
    * @return Uint - length of the level array
    */
    function getLevelLength()
    public
    constant
    returns ( uint )
    {
        return levels.length;
    }

    /**
    * @return Uint - multiplier of the level.
    */
    function getMultiplierById( uint _level )
    public
    constant
    returns ( uint )
    {
        return levels[_level].multiplier;
    }

    /**
    * @return Uint - day of the level.
    */
    function getDayById( uint _level )
    public
    constant
    returns ( uint )
    {
        return levels[_level].day;
    }

}
