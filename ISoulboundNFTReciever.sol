// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

interface ISoulboundReceiver {
   
    function onSoulboundReceived(
        address operator,
        address from,
        uint256 tokenId,
        bytes calldata data
    ) external returns (bytes4);
}
