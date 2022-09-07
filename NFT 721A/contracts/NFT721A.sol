//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

import "erc721a/contracts/ERC721A.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract NFT721A is ERC721A, Ownable {

    mapping(address => uint) private publicMintedCount;
    mapping(address => uint) private wlMintedCount;

    uint constant mintPrice = 0.01 ether;
    uint constant maxSupply = 111;

    bytes32 root;

    bool private isPublic;
    bool private isWhitelist;

    string private URIPrefix ="bafybeibu53vjzpzjtpyk3q375cjnqcmdqgnqpjkd4l2eaz7kulvphvu6au/";
    string private URISuffix = ".json";

    constructor() ERC721A ("METU721A", "AAA") {

    }

    function _startTokenId() internal override pure returns (uint256){
        return  1;
    }

    function setRoot(bytes32 _root) onlyOwner external {
        root = _root;
    }

    function togglePublicMint() onlyOwner external {
        isPublic = !isPublic;
    }

    function toggleWhitelistMint() onlyOwner external {
        isWhitelist = !isWhitelist;
    }

    modifier onlyOrigin {
        require(msg.sender == tx.origin);
        _;
    }

    function whitelistMint(bytes32[] calldata proof) onlyOrigin external payable{
        require(MerkleProof.verify(proof, root, keccak256(abi.encodePacked(msg.sender))),"not Wl");
        require(isWhitelist, "wl mint isnt active");
        require(totalSupply() + 1 <= maxSupply, "exceeds max supply");
        require(wlMintedCount[msg.sender] == 0, "you cant mint that much");
        require(msg.value >= mintPrice, "pay the price to mint");

        wlMintedCount[msg.sender] += 1;
        _safeMint(msg.sender, 1);
    }

    function publicMint(uint amount) onlyOrigin external payable {
        require(isPublic, "public mint isnt active");
        require(publicMintedCount[msg.sender] + amount <= 5, "you cant mint that much");
        require(totalSupply() + amount <= maxSupply, "exceeds max supply");
        require(msg.value >= amount * mintPrice, "pay the price to mint");

        publicMintedCount[msg.sender] += amount;
        _safeMint(msg.sender, amount);
    }

    function setBaseURI(string memory _URIPrefix) external onlyOwner {
        URIPrefix = _URIPrefix;
    }

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        if (!_exists(tokenId)) revert URIQueryForNonexistentToken();

        string memory baseURI = _baseURI();
        return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId), URISuffix)) : '';
    }

    function _baseURI() internal view override returns (string memory) {
        return URIPrefix;
    }
    
}