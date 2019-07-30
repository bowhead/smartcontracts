pragma solidity 0.4.25;


contract ACL {
  mapping (address => bool) internal admins;
  mapping (address => uint) internal levels;

  /**
  * @dev Throws if called by any account other than the admin.
  */
  modifier onlyAdmin(uint level) {
      require(admins[msg.sender] && (levels[msg.sender] == 0 || levels[msg.sender] == level));
      _;
  }

  /**
  * @return true if `msg.sender` is the admin
  * @param _isAdmin the address  admin
  * @param level    the level of the admin
  */
  function isAdmin(address _isAdmin, uint level) public view returns (bool) {
    // the admins with lelvel 0 are consired super admin
    return (admins[_isAdmin] && (levels[_isAdmin] == 0 || levels[_isAdmin] == level));
  }

  /**
  * @return true if `msg.sender` is the admin
  * @param _newAdmin the address of the new admin
  * @param _newAdmin the level of the new admin
  */
  function addAdmin(address _newAdmin, uint level) public onlyAdmin(0) returns (bool) {
      admins[_newAdmin] = true;
      levels[_newAdmin] = level;
      return true;
  }
}
