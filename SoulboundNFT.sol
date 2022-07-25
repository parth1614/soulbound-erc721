// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.10;

import "./ISoulboundNFT.sol";
import "./ISoulboundNFTReciever.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Context.sol";

contract SoulboundNFT is ISoulboundNFT, Context {
    
    using Address for address;
    using Strings for uint256;
    
    // Token name
    string private _name;
    
    // Token symbol
    string private _symbol;
    
    // Mapping from token ID to owner address
    mapping(uint256 => address) private _owners;
    
    
    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
    }
    
   
    function ownerOf(uint256 tokenId) public view virtual override returns (address) {
        address owner = _owners[tokenId];
        require(owner != address(0), "SoulboundNFT: owner query for nonexistent token");
        return owner;
    }

   
    function name() public view virtual returns (string memory) {
        return _name;
    }

    
    function symbol() public view virtual returns (string memory) {
        return _symbol;
    }

	
    function tokenURI(uint256 tokenId) public view virtual returns (string memory) {
        require(_exists(tokenId), "SoulboundNFTMetadata: URI query for nonexistent token");

        string memory baseURI = _baseURI();
        return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
    }

    
    function _baseURI() internal view virtual returns (string memory) {
        return "";
    }

	
    function _exists(uint256 tokenId) internal view virtual returns (bool) {
        return _owners[tokenId] != address(0);
    }


    function _safeMint(address to, uint256 tokenId) internal virtual {
        _safeMint(to, tokenId, "");
    }

	
    function _safeMint(
        address to,
        uint256 tokenId,
        bytes memory _data
    ) internal virtual {
        _mint(to, tokenId);
        require(
            _checkOnSoulboundNFTReceived(address(0), to, tokenId, _data),
            "SoulboundNFT: transfer to non SoulboundNFTReceiver implementer"
        );
    }

  
    function _mint(address to, uint256 tokenId) internal virtual {
        require(to != address(0), "SoulboundNFT: mint to the zero address");
        require(!_exists(tokenId), "SoulboundNFT: token already minted");

        _beforeTokenTransfer(address(0), to, tokenId);

        _owners[tokenId] = to;

        emit Transfer(address(0), to, tokenId);

        _afterTokenTransfer(address(0), to, tokenId);
    }

   
    function _burn(uint256 tokenId) internal virtual {
        address owner = SoulboundNFT.ownerOf(tokenId);

        _beforeTokenTransfer(owner, address(0), tokenId);

        delete _owners[tokenId];

        emit Transfer(owner, address(0), tokenId);

        _afterTokenTransfer(owner, address(0), tokenId);
    }

    function _checkOnSoulboundNFTReceived(
        address from,
        address to,
        uint256 tokenId,
        bytes memory _data
    ) private returns (bool) {
        if (to.isContract()) {
            try ISoulboundReceiver(to).onSoulboundReceived(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
                return retval == ISoulboundReceiver.onSoulboundReceived.selector;
            } catch (bytes memory reason) {
                if (reason.length == 0) {
                    revert("Soulbound: transfer to non SoulboundReceiver implementer");
                } else {
                    assembly {
                        revert(add(32, reason), mload(reason))
                    }
                }
            }
        } else {
            return true;
        }
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual {}

    function _afterTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual {}

}
