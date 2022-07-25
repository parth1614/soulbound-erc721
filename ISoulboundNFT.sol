// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)

pragma solidity ^0.8.0;


interface ISoulboundNFT {
    
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);

    function ownerOf(uint256 tokenId) external view returns (address owner);
}
