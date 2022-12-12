// SPDX-License-Identifier: MIT
// Collectify Launchapad Contracts v1.1.0
// Creator: Hging

pragma solidity ^0.8.4;

import "./ERC721A.sol";
import "@openzeppelin/contracts/token/common/ERC2981.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

contract CollectifyPlayground is ERC721A, ERC2981, AccessControl {
    string public baseURI;
    
    mapping(uint256 => string) internal tokenURIList;
    mapping(address => bool) internal privateClaimList;
    mapping(address => bool) internal publicClaimList;

    constructor(
        string memory _uri,
        uint96 royaltyFraction
    ) ERC721A("Collectify Playground", "NFT") {
        baseURI = _uri;
        _setDefaultRoyalty(_msgSender(), royaltyFraction);
        _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
    }

    modifier onlyOwner() {
        require(hasRole(DEFAULT_ADMIN_ROLE, _msgSender()), "error: 20000 - only owner can call this function");
        _;
    }

    modifier onlyCreator(uint256 id) {
        require(hasRole(keccak256(abi.encodePacked(id)), _msgSender()), "error: 20001 - only creator can call this function");
        _;
    }

    function  _baseURI() internal view virtual override returns (string memory) {
        return baseURI;
    }

    function changeBaseURI(string memory _uri) public onlyOwner {
        baseURI = _uri;
    }

    function changeDefaultRoyalty(uint96 _royaltyFraction) public onlyOwner {
        _setDefaultRoyalty(_msgSender(), _royaltyFraction);
    }

    function changeRoyalty(uint256 _tokenId, uint96 _royaltyFraction) public onlyCreator(_tokenId) {
        _setTokenRoyalty(_tokenId, _msgSender(), _royaltyFraction);
    }

    function moveMemberShip(address _newOwner) public {
        require(hasRole(DEFAULT_ADMIN_ROLE, _msgSender()));
        _grantRole(DEFAULT_ADMIN_ROLE, _newOwner);
        _revokeRole(DEFAULT_ADMIN_ROLE, _msgSender());
    }

    function mint(string memory _uri, uint96 _royaltyFraction) external payable {
        uint256 supply = totalSupply();
        address claimAddress = _msgSender();
        _grantRole(keccak256(abi.encodePacked(supply)), claimAddress);
        _safeMint(claimAddress, 1);
        bytes(_uri).length != 0 ? tokenURIList[supply] = _uri : "";
        _setTokenRoyalty(supply, claimAddress, _royaltyFraction);
    }
    
    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(_exists(tokenId), "ERC721URIStorage: URI query for nonexistent token");
        return bytes(tokenURIList[tokenId]).length != 0 ? tokenURIList[tokenId] : super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        virtual
        override(ERC721A, ERC2981, AccessControl)
        returns (bool)
    {
        // Supports the following `interfaceId`s:
        // - IERC165: 0x01ffc9a7
        // - IERC721: 0x80ac58cd
        // - IERC721Metadata: 0x5b5e139f
        // - IERC2981: 0x2a55205a
        return
            ERC721A.supportsInterface(interfaceId) ||
            ERC2981.supportsInterface(interfaceId) ||
            AccessControl.supportsInterface(interfaceId);
    }

    // This allows the contract owner to withdraw the funds from the contract.
    function withdraw(uint amt) external onlyOwner {
        (bool sent, ) = payable(_msgSender()).call{value: amt}("");
        require(sent, "GG: Failed to withdraw Ether");
    }
}
