pragma solidity 0.4.25;

import "../common/ACL.sol";


/**
 * @dev Absctract contract with the needed function to be called fromt the RegisteredAccountsDB contract
 */
contract DB {
  function get(address accountAddress) public view
    returns(bytes32 id, bool registered, bool active, uint createdTime, uint updatedTime);
}


contract RegisteredAccounts is ACL {
  DB private registeredAccountsDB;

  /**
   * @dev When the smart contract is created add the DB address
   */
  constructor (address _contractDBAddress) public {
    admins[msg.sender] = true;
    levels[msg.sender] = 0;

    registeredAccountsDB = DB(_contractDBAddress);
  }

  /**
   * @dev Gets the account information using the ecrecover function and a signed hash
   */
  function getInfoFromSignature(uint8 sigV, bytes32 sigR, bytes32 sigS, bytes32 hash) external view
    returns(bytes32 id, bool registered, bool active, uint createdTime, uint updatedTime) {
    address account = ecrecover(hash, sigV, sigR, sigS);
    require(account != 0x0 && account != 0x0);

    return registeredAccountsDB.get(account);
  }

}
