//SPDX-License-Identifier:MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./IWhitelist.sol";

contract CryptoDevs is ERC721, Ownable {

    string _baseTokenURI;

    IWhitelist whitelist;

    uint256 public tokenIds;

    uint256 public maxTokenIds = 20;

    bool public presaleStarted;

    uint256 public presaleEnded;

    uint256 public _price = 0.01 ether;

    bool public _paused;

    modifier onlyWhenNotPaused {
        require(!_paused, "Contract currently paused!");
        _;
    }

    constructor(string memory baseURI, address whitelistContract) ERC721("Crypto Devs", "CD"){
        _baseTokenURI = baseURI;
        whitelist = IWhitelist(whitelistContract);
    }

    function startPresale() public onlyOwner {
        presaleStarted = true;
        presaleEnded = block.timestamp + 5 minutes;
    }

    // allows a user to mint 1 NFT during the presale
    function presaleMint() public payable onlyWhenNotPaused {
        require(presaleStarted && block.timestamp < presaleEnded, "Presale is not running");
        require(whitelist.whitelistedAddress(msg.sender), "You are not whitelisted");
        require(tokenIds < maxTokenIds, "Exceeded maximum Crypto Devs supply");
        require(msg.value >= _price, "Ether sent is not correct");
        tokenIds+=1;

        _safeMint(msg.sender, tokenIds);
    }

    // allows a user to mint 1 NFT after the presale has ended
    function mint() public payable onlyWhenNotPaused {
        require(presaleStarted && block.timestamp >= presaleEnded, "Presale has not ended yet");
        require(tokenIds < maxTokenIds, "Exceeded maximum Crypto Devs supply");
        require(msg.value >= _price, "Ether sent is not correct");
        tokenIds+=1;

        _safeMint(msg.sender, tokenIds);
    }

    // setPaused makes the contract paused or unpaused
    function setPaused(bool val) public onlyOwner {
        _paused = val;
    }

    function _baseURI() internal view override returns (string memory) {
        return _baseTokenURI;
    }

    // withdraw sends all the ether in the contract to the owner of the contract
    function withdraw() public onlyOwner {
        address _owner = owner();
        uint256 amount = address(this).balance;
        (bool sent, ) = _owner.call{value: amount}("");
        require(sent, "Failed to sent Ether");
    }

    // receive function is called if the msg.data is empty
    receive() external payable {}

    // fallback function is called if the msg.data is not empty
    fallback() external payable {}
}