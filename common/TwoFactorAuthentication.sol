pragma solidity 0.4.25;

import "./ACL.sol";


/*
* Two factor authentication token handler
* Updated date 15-Feb-2019
*/
contract TwoFactorAuthentication is ACL {

  mapping(address => mapping(bytes32 => bool)) internal accessList;

  constructor () public {
    admins[msg.sender] = true;
    levels[msg.sender] = 0;
  }

  function setAccess(address userAddress, bytes32 token) external onlyAdmin(0) returns(bool) {
    accessList[userAddress][token] = true;
    return true;
  }

  function hasAccess(address userAddress, bytes32 token) external view returns(bool) {
    return accessList[userAddress][token];
  }
}
