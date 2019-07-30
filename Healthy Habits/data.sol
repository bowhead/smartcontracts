pragma solidity ^0.4.0;

import './ownable.sol'; // Import Ownable contract.

/** @title Data.*/
contract Data is Ownable {

    // TYPES

    uint internal time; // Time of the last refill.
    uint internal rewardPerDay; // Reward per day.
    uint internal available; // Available per day.
    uint internal timesPerDay; // Times you have to save all types of data per day to complete the cycle.

    struct DataType { // Struct.
        string name; // Data Type name.
        uint reward; // Reward in Cell.
        uint times; // Times to complete the cycle per day.
        uint time; // Time to complete the cycle per day.
        bool state; // State of the struct tobe used.
        bool toCount; // True if it were counted for the cycle per day.
    }

    mapping ( string => uint ) internal data; // Saving the id of each DataType.name.

    DataType[] internal dataTypes; // DataType struct array.

    modifier isValidData( string dataType ){
        require( data[dataType] != 0 );
        _;
    }

    constructor() public {
        
        rewardPerDay = 2000000000000000000000;
        available = 2000000000000000000000;
        time  = now; // Set to time.

        // Default.
        uint id = dataTypes.push(DataType({
        name: "",
        reward: 0,
        times: 0,
        time: 0,
        state: false,
        toCount: false
        }));
        data[""] = id;
        // Energy.
        id = dataTypes.push(DataType({
        name: "Energy",
        reward: 100000000000000,
        times: 1,
        time: 1 days,
        state: true,
        toCount: true
        })) - 1;
        data["Energy"] = id;
        // Water.
        id = dataTypes.push(DataType({
        name: "Water",
        reward: 100000000000000,
        times: 8,
        time: 1 days,
        state: true,
        toCount: true
        })) - 1;
        data["Water"] = id;
        // Meditation.
        id = dataTypes.push(DataType({
        name: "Meditation",
        reward: 100000000000000,
        times: 1,
        time: 1 days,
        state: true,
        toCount: true
        })) - 1;
        data["Meditation"] = id;
        // Stool.
        id = dataTypes.push(DataType({
        name: "Stool",
        reward: 100000000000000,
        times: 1,
        time: 1 days,
        state: true,
        toCount: true
        })) - 1;
        data["Stool"] = id;
        // Sleep.
        id = dataTypes.push(DataType({
        name: "Sleep",
        reward: 100000000000000,
        times: 1,
        time: 1 days,
        state: true,
        toCount: true
        })) - 1;
        data["Sleep"] = id;
        // Survey.
        id = dataTypes.push(DataType({
        name: "Survey",
        reward: 100000000000000,
        times: 1,
        time: 30 days,
        state: true,
        toCount: false
        })) - 1;
        data["Survey"] = id;
        // Profile.
        id = dataTypes.push(DataType({
        name: "Profile",
        reward: 0,
        times: 1,
        time: 0,
        state: true,
        toCount: false
        })) - 1;
        data["Profile"] = id;
        //MRI.
        id = dataTypes.push(DataType({
        name: "MRI",
        reward: 0,
        times: 0,
        time: 0,
        state: false,
        toCount: false
        })) - 1;
        data["MRI"] = id;
        
        setTimesPerDay(); // Set timtimesPerDay.
    }

    // PUBLIC METHODS - ONLY OWNER

    /**
    * @dev Create DataType
    * @param _dataType String - Data Type name.
    * @param _times Uint - Times to complete the cycle per day.
    * @param _reward Uint - Reward in Cell.
    * @param _time Uint - Time to complete the cycle per day.
    * @param _state Bool - State of the struct tobe used.
    * @param _toCount Bool - True if it were counted for the cycle per day.
    */
    function createDataType( string _dataType, uint _times, uint _reward, uint _time, bool _state, bool _toCount )
        onlyOwner
        public
    {
        uint id = dataTypes.push(DataType({
        name: _dataType,
        reward: _reward,
        times: _times,
        time: _time,
        state: _state,
        toCount: _toCount
        })) - 1;
        data[_dataType] = id;
        setTimesPerDay();
    }

    /**
    * @dev Update a DataType
    * @param _dataType String - Data Type name.
    * @param _times Uint - Times to complete the cycle per day.
    * @param _reward Uint - Reward in Cell.
    * @param _time Uint - Time to complete the cycle per day.
    * @param _state Bool - State of the struct tobe used.
    * @param _toCount Bool - True if it were counted for the cycle per day.
    */
    function updateDataType( string _dataType, uint _times, uint _reward, uint _time, bool _state, bool _toCount )
        onlyOwner
        isValidData( _dataType )
        public
    {
        uint id = data[_dataType];
        dataTypes[id].times  = _times;
        dataTypes[id].reward = _reward;
        dataTypes[id].time   = 1 hours * _time;
        dataTypes[id].state  = _state;
        dataTypes[id].toCount = _toCount;
        setTimesPerDay();
    }

    /**
    * @param _dataType String -
    * @return _dataType String - Data Type name.
    * @return _times Uint - Times to complete the cycle per day.
    * @return _reward Uint - Reward in Cell.
    * @return _time Uint - Time to complete the cycle per day.
    * @return _state Bool - State of the struct tobe used.
    * @return _toCount Bool - True if it were counted for the cycle per day.
    */
    function getDataType( string _dataType )
        onlyOwner
        isValidData( _dataType )
        public
        constant
        returns( string name, uint reward, uint times, uint timeInSecond, bool state, bool toCount )
    {
        uint id = data[_dataType];
        DataType storage dt = dataTypes[id];
        return ( dt.name, dt.reward, dt.times, dt.time, dt.state, dt.toCount );
    }

    /**
    * @dev Change the state of the DataType
    * @param _dataType String - Data type.
    */
    function changeState( string _dataType )
        onlyOwner
        isValidData( _dataType )
        public
    {
        uint id = data[_dataType];
        DataType storage dt = dataTypes[id];
        dt.state = !dt.state;
    }

    /**
    * @dev Change the toCount of the toCount
    * @param _dataType String - Data type.
    */
    function changeToCount( string _dataType )
        onlyOwner
        isValidData( _dataType )
        public
    {
        uint id = data[_dataType];
        DataType storage dt = dataTypes[id];
        dt.toCount = !dt.toCount;
        setTimesPerDay();
    }

    /**
    * @dev Change the reward of the DataType
    * @param _dataType String - Data type.
    * @param _reward Uint - Reward in Cell.
    */
    function setReward( string _dataType, uint _reward)
        onlyOwner
        isValidData( _dataType )
        public
    {
        uint id = data[_dataType];
        DataType storage dt = dataTypes[id];
        dt.reward = _reward;
    }

    /**
    * @dev Change the time of the DataType
    * @param dataType String - Data type.
    * @param _time Uint - Time to complete the cycle per day.
    */
    function setTime( string dataType, uint _time)
        onlyOwner
        isValidData( dataType )
        public
    {
        uint id = data[dataType];
        DataType storage dt = dataTypes[id];
        dt.time = 1 hours * _time;
    }

    /**
    * @dev Change times of the DataType.
    * @param dataType String - Data type .
    * @param _times Uint - Times to complete the cycle per day.
    */
    function setTimes( string dataType, uint _times )
        onlyOwner
        isValidData( dataType )
        public
    {
        uint id = data[dataType];
        DataType storage dt = dataTypes[id];
        dt.times = _times;
        setTimesPerDay();
    }

    /**
    * @param _available Uint - Set avaliable per day.
    */
    function setAvaliable( uint _available )
        onlyOwner
        public
    {
        available = _available;
    }
    
    /**
    * @param _rewardPerDay Uint - Set reward per day.
    */
    function setRewardPerDay( uint _rewardPerDay )
        onlyOwner
        public
    {
        rewardPerDay = _rewardPerDay;
    }
    
    // PUBLIC METHODS

    /**
    * @return available Uint - Reward per day.
    */
    function getAvailable()
        public
        constant
        returns ( uint )
    {
        return available;
    }

    /**
    * @return rewardPerDay Uint - The available Cell per day to the reward.
    */
    function getRewardPerDay()
        public
        constant
        returns ( uint )
    {
        return rewardPerDay;
    }


    /**
    * @return timesPerDay Uint - The time to complete a cycle.
    */
    function getTimesPerDay()
        public
        constant
        returns ( uint )
    {
        return timesPerDay;
    }

    /**
    * @return Uint - Id by dataType.
    */
    function getIdByName( string _dataType )
        public
        constant
        isValidData( _dataType )
        returns( uint )
    {
        return data[_dataType];
    }
    
    /**
    * @return Uint - reward by dataType.
    */
    function getReward( string _dataType )
        public
        constant
        isValidData( _dataType )
        returns( uint )
    {
        uint id = data[_dataType];
        DataType storage dt = dataTypes[id];
        return dt.reward;
    }
    
    /**
    * @return Uint - time by dataType.
    */
    function getTime( string _dataType )
        public
        constant
        isValidData( _dataType )
        returns( uint )
    {
        uint id = data[_dataType];
        DataType storage dt = dataTypes[id];
        return dt.time;
    }
    
    /**
    * @return Uint - times by dataType.
    */
    function getTimes( string _dataType )
        public
        constant
        isValidData( _dataType )
        returns( uint )
    {
        uint id = data[_dataType];
        DataType storage dt = dataTypes[id];
        return dt.times;
    }

    /**
    * @return Uint - state by dataType.
    */
    function getState( string _dataType )
        public
        constant
        isValidData( _dataType )
        returns( bool )
    {
        uint id = data[_dataType];
        DataType storage dt = dataTypes[id];
        return dt.state;
    }

    /**
    * @return Uint - toCount by dataType.
    */
    function getToCount( string _dataType )
        public
        constant
        isValidData( _dataType )
        returns( bool )
    {
        uint id = data[_dataType];
        DataType storage dt = dataTypes[id];
        return dt.toCount;
    }

    /**
    * @return Uint - Length of the dataType.
    */
    function getDataTypesLength()
        public
        constant
        returns ( uint )
    {
        return dataTypes.length;
    }
    
    function getDataTypeNameById( uint _id )
        public
        constant
        returns ( string )
    {   
        return dataTypes[_id].name;
    }

    // INTERNAL METHODS

    /**
    * @dev Restart the available reward.
    */
    function restartReward() 
        public 
        returns ( bool ) 
    {
        rewardPerDay = available;
        time = now; // Set time.
        return true;
    }

    /**
    * return Bool - Check if the day is over.
    */
    function isDayOver() public constant returns ( bool ) {
        if( time + 1 days < now )
            return true;
        else
            return false;
    }
    
    
    // PRIVATE METHODS

    /**
    * @dev Set timesPerDay.
    */
    function setTimesPerDay()
        private
    {
        uint times;
        for( uint i = 0 ; i < dataTypes.length ; i++ ){
            if( dataTypes[i].toCount )
                times += dataTypes[i].times;
        }
        timesPerDay = times;
    }

}
