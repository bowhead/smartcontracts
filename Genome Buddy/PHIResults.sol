pragma solidity 0.4.25;

import "./ACL.sol";


/**
 * @dev Abstract contract with the needed function to be called from the PHIResultsDB contract
 */
contract DB {
  function add(bytes24 kitType, bytes32 newKitId, bytes32 newHhash1, bytes32 newHash2, address userAddress) public;

  function get(bytes24 kitType, address userAddress) public view
    returns(bytes32[] kitsId, bytes32[] hashes1, bytes32[] hashes2);

  function update(bytes24 kitType, bytes32 existentKitId, bytes32 newHhash1, bytes32 newHash2, address userAddress)
    public;
}


/**
 * @dev Abstract contract with the needed function to be called from the PHIResultsDB contract
 */
contract TwoFA {
  function hasAccess(address userAddress, bytes32 _allowed) public view  returns(bool);
}


contract PHIResults is ACL {
  DB private pHIStorage;
  TwoFA private twoFactorAuth;

  constructor (address _contractDBAddress, address _twoFaAddress) public {
    admins[msg.sender] = true;
    levels[msg.sender] = 0;

    pHIStorage = DB(_contractDBAddress);
    twoFactorAuth = TwoFA(_twoFaAddress);
  }

  modifier isAuthenticated(bytes32 token) {
    require(twoFactorAuth.hasAccess(msg.sender, token));
    _;
  }

  /**
   * @dev Changes the instace referencing to the PHIResultsDB contract
   */
  function setDbAddress(address _contractDBAddress) external onlyAdmin(0) {
    pHIStorage = DB(_contractDBAddress);
  }

  /**
   * @dev Changes the instace referencing to the PHIResultsDB contract
   */
  function setTwoFAAddress(address _contractTFAAddress) external onlyAdmin(0) {
    twoFactorAuth = TwoFA(_contractTFAAddress);
  }

  /**
   * @dev updates the kit id for the user that signed the transaction
   */
  function updateResult(bytes24 kitType, bytes32 existentKitId, bytes32 newHhash1, bytes32 newHash2, bytes32 token)
    external  isAuthenticated(token) {
    pHIStorage.update(kitType, existentKitId, newHhash1, newHash2, msg.sender);
  }

  /**
   * @dev returns the stored results for the user that called the function
   */
  function getResults(bytes24 kitType, bytes32 token)
    external view isAuthenticated(token) returns(bytes32[] kitsId, bytes32[] hashes1, bytes32[] hashes2) {
    return pHIStorage.get(kitType, msg.sender);
  }
}
