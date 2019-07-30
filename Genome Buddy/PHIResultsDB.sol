pragma solidity 0.4.25;

import "./ACL.sol";


contract PHIResultsDB is ACL {
  struct KitIdx {
      uint index;
      bool exists;
  }

  mapping(address => mapping(bytes24 => bytes32[])) private storedKitsId;
  mapping(address => mapping(bytes24 => bytes32[])) private storedHashes1;
  mapping(address => mapping(bytes24 => bytes32[])) private storedHashes2;

  mapping(bytes32 => KitIdx) private kitsIndex;
  mapping(address => mapping(bytes24 => uint[])) private accessLogs;

  /**
   * @dev assigns the creator of the contract as the first admin
   */
  constructor() public {
      admins[msg.sender] = true;
      levels[msg.sender] = 0;
  }

  /**
   * Ensure the user has kits for the given kit type
   */
  modifier hasResults(bytes24 kitType, address userAddress) {
      require(storedKitsId[userAddress][kitType].length > 0);
      _;
  }

  /**
   * @dev Adds a new element to the storedKitsId, storedHashes1 and storedHashes2 mappings
  * This function ensures that a duplicated kit id is not added
   */
  function add(bytes24 kitType, bytes32 newKitId, bytes32 newHhash1, bytes32 newHash2, address userAddress)
    external onlyAdmin(0) {
    bytes32 hash = _getKitCheckSum(kitType, newKitId, userAddress);
    KitIdx storage checkSum = kitsIndex[hash];
    require(checkSum.exists == false); // prevents a duplicate to be added

    bytes32[] storage kitsId = storedKitsId[userAddress][kitType];

    kitsId.push(newKitId);
    storedHashes1[userAddress][kitType].push(newHhash1);
    storedHashes2[userAddress][kitType].push(newHash2);

    kitsIndex[hash] = KitIdx(kitsId.length - 1, true);
  }

  /**
   * @dev Updates the given existentKitId IPFS hashes for the passed kit type and address
   * This function ensures the user has results for the given kit type and the requested kit ID exists
   */
  function update(bytes24 kitType, bytes32 existentKitId, bytes32 newHhash1, bytes32 newHash2, address userAddress)
    external onlyAdmin(1) hasResults(kitType, userAddress) {
    KitIdx storage checkSum = kitsIndex[_getKitCheckSum(kitType, existentKitId, userAddress)];
    require(checkSum.exists == true);

    bytes32[] storage kitsId = storedKitsId[userAddress][kitType];
    bytes32[] storage hashes1 = storedHashes1[userAddress][kitType];
    bytes32[] storage hashes2 = storedHashes2[userAddress][kitType];

    // search for the specific kit ID
    kitsId[checkSum.index] = existentKitId;
    hashes1[checkSum.index] = newHhash1;
    hashes2[checkSum.index] = newHash2;
  }

  /**
   * @dev Removes the given kit id and the related IPFS hashes for the passed kit type and address
   * This function ensures the user has results for the given kit type and the requested kit ID exists
   */
  function remove(bytes24 kitType, bytes32 existentKitId, address userAddress)
    external onlyAdmin(1) hasResults(kitType, userAddress) {
    bytes32 checkSum = _getKitCheckSum(kitType, existentKitId, userAddress);
    KitIdx storage indexStruct = kitsIndex[checkSum];
    require(indexStruct.exists == true);

    // 1. gets all the kits
    bytes32[] storage kitsId = storedKitsId[userAddress][kitType];
    bytes32[] storage hashes1 = storedHashes1[userAddress][kitType];
    bytes32[] storage hashes2 = storedHashes2[userAddress][kitType];

    // 1.5 gets the last kit ID reference
    bytes32 movedKitId = kitsId[kitsId.length - 1];

    // 2. Overwrites the element that wants to be removed with the last from the array
    //    in this way we avoid an expensive loop
    kitsId[indexStruct.index] = movedKitId;
    hashes1[indexStruct.index] = hashes1[hashes1.length - 1];
    hashes2[indexStruct.index] = hashes2[hashes2.length - 1];

    // 3. Updates the moved element index
    kitsIndex[_getKitCheckSum(kitType, movedKitId, userAddress)].index = indexStruct.index;

    // 4. "Removes" the element. This is a logical remove, allowing to add it again
    kitsIndex[checkSum].exists = false;

    // 5. Performs the actual remove
    kitsId.length--;
    hashes1.length--;
    hashes2.length--;
  }

  /**
   * @dev Returns all the kits id, and IPFS hashes associated to the user address and the kit type
   */
  function get(bytes24 kitType, address userAddress)
    external view onlyAdmin(1) returns(bytes32[] kitsId, bytes32[] hashes1, bytes32[] hashes2) {

    return (
      storedKitsId[userAddress][kitType],
      storedHashes1[userAddress][kitType],
      storedHashes2[userAddress][kitType]
    );
  }

  /**
   * @dev Returns a hash representing a unique kit id, using the kit type, kit id and the user address
   */
  function _getKitCheckSum(bytes24 kitType, bytes32 kitId, address userAddress) private pure returns(bytes32) {
      return keccak256(abi.encodePacked(userAddress, kitType, kitId));
  }
}
