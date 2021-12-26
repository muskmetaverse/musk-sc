// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

contract BlackList is OwnableUpgradeable {
    mapping(address => bool) public blacklist;

    function addAddressToBlacklist(address _address, bool _isBlackAddress)
        external
        onlyOwner
    {
        require(_address != address(0), "Cannot be zero address");
        blacklist[_address] = _isBlackAddress;
    }

    function _checkBlackList(address _address) internal view {
        require(_address != address(0), "Cannot be zero address");
        require(!blacklist[_address], "address is in blacklist");
    }
}
