// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

abstract contract BlackList is OwnableUpgradeable {
    mapping(address => bool) public blacklist;

    function __BlackList_init() internal initializer {
        __BlackList_init_unchained();
    }

    function __BlackList_init_unchained() internal initializer {
    }

    function addAddressToBlacklist(address _address, bool _isBlackAddress)
        external
        onlyOwner
    {
        require(_address != address(0), "Cannot be zero address");
        blacklist[_address] = _isBlackAddress;
    }

    function _checkBlackList(address _address) internal view {
        require(!blacklist[_address], "address is in blacklist");
    }

    uint256[50] private __gap;
}
