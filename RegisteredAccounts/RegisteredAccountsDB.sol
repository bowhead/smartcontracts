pragma solidity 0.4.25;

import "../common/ACL.sol";


contract RegisteredAccountsDB is ACL {
  struct Info {
      bytes32 id;
      bool registered;
      bool active;
      uint createdTime;
      uint updatedTime;
  }

  mapping(address => Info) private accountsData;
  address[] private accountsList;

  /**
   * @dev Assigns the creator of the contract as the first admin
   */
  constructor() public {
      admins[msg.sender] = true;
      levels[msg.sender] = 0;
  }

  /**
   * @dev Ensures the account is registered
   */
  modifier isRegistered(address accountAddress) {
      require(accountsData[accountAddress].registered == true);
      _;
  }

  /**
   * @dev Add new account to the storage
   */
  function add(address accountAddress, bytes32 id, bool active)
    external onlyAdmin(0) {
      accountsData[accountAddress] = Info(id, true, active, now, now);
      accountsList.push(accountAddress);
  }

  /**
   * @dev Updates the id and active status
   */
  function update(address accountAddress, bytes32 id, bool active)
    external onlyAdmin(0) isRegistered(accountAddress) {
      Info storage info = accountsData[accountAddress];

      info.id = id;
      info.active = active;
      info.updatedTime = now;
  }

  /**
   * @dev Returns a single account information
   */
  function get(address accountAddress)
    external view returns(bytes32 id, bool registered, bool active, uint createdTime, uint updatedTime) {

    Info storage info = accountsData[accountAddress];

    return (
        info.id,
        info.registered,
        info.active,
        info.createdTime,
        info.updatedTime
    );
  }

  /**
   * @dev Gets all the registered address
   */
  function getAll()
    external view returns(address[] accounts) {
    return accountsList;
  }
}
