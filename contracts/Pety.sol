// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721EnumerableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "../interfaces/IFactory.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "../interfaces/IPetyConfig.sol";

contract Pety is ERC721EnumerableUpgradeable, OwnableUpgradeable {
    struct Level {
        uint32 price; // price for each level by USD
        uint32 upgradePrice; // price to upgrade next level
        uint8 upgradeSuccessRate; // from 0 to 100
    }

    IFactory public factory;
    IPetyConfig public petyConfig;
    mapping(uint256 => uint8) public level;
    event Upgrade(uint256 tokenId, bool success);
    mapping(uint256 => bool) public locked;
    uint32 public tolerance;
    string public baseURI;

    function initialize(
        address factoryAddress,
        address petyConfigAddress
    ) public initializer {
        factory = IFactory(factoryAddress);
        petyConfig = IPetyConfig(petyConfigAddress);
        tolerance = 1000;
        baseURI = "https://petmapping.com/metadata/";
        __ERC721_init("Pety", "PETY");
        __Ownable_init();
    }

    function mint(uint8 _level, uint8 _numberOfPeties) public onlyOwner {
        uint256 _tokenId = totalSupply();
        for (uint8 i = 0; i < _numberOfPeties; i++) {
            level[_tokenId + i] = _level;
            _mint(msg.sender, _tokenId + i);
        }
    }

    function upgrade(uint256 _tokenId) public payable {
        uint8 _level = level[_tokenId];
        Level memory petyLevel = petyConfig.getPetyLevel(_level);
        require(petyLevel.upgradePrice != 0, "Reached highest level");
        require(
            comparePrice(
                msg.value,
                factory.usdToNativeToken(petyLevel.upgradePrice)
            ),
            "Paid incorrect amount of coin"
        );
        (bool transferred, ) = owner().call{value: msg.value}("");
        require(transferred, "Transfer failed");
        _upgrade(_tokenId, _level);
    }

    function upgradeByHuraToken(uint256 _tokenId) public {
        uint8 _level = level[_tokenId];
        Level memory petyLevel = petyConfig.getPetyLevel(_level);
        require(petyLevel.upgradePrice != 0, "Reached highest level");
        uint256 value = factory.usdToHuraToken(petyLevel.upgradePrice);
        value = (value * petyConfig.getTokenomic()) / 100000;
        require(
            factory.getToken().transferFrom(msg.sender, address(this), value),
            "Failed in transfer to contract"
        );
        require(
            factory.getToken().transfer(owner(), value),
            "Failed in transfer to Pet Mapping"
        );
        _upgrade(_tokenId, _level);
    }

    function _upgrade(uint256 _tokenId, uint8 _level) private {
        Level memory nextPetyLevel = petyConfig.getPetyLevel(_level + 1);
        uint32 successRate = nextPetyLevel.upgradeSuccessRate;
        bool success = successRate > (factory.random() % 100);
        if (success) {
            level[_tokenId] += 1;
        }
        emit Upgrade(_tokenId, success);
    }

    modifier mutex(uint256 param) {
        require(!locked[param], "It is currently locked, please try again");
        locked[param] = true;
        _;
        locked[param] = false;
    }

    function buy(uint256 _tokenId) public payable mutex(_tokenId) {
        require(ownerOf(_tokenId) == owner(), "This NFT is unavailable");
        uint8 _level = level[_tokenId];
        Level memory petyLevel = petyConfig.getPetyLevel(_level);
        require(
            comparePrice(msg.value, factory.usdToNativeToken(petyLevel.price)),
            "You need to pay ether"
        );
        (bool transferred, ) = owner().call{value: msg.value}("");
        require(transferred, "Transfer failed");
        _transfer(owner(), msg.sender, _tokenId);
    }

    function changeBaseURI(string memory newBaseURI) external onlyOwner {
        baseURI = newBaseURI;
    }

    function tokenURI(
        uint256 tokenId
    ) public view virtual override returns (string memory) {
        string memory _level = Strings.toString(level[tokenId]);
        return string(abi.encodePacked(baseURI, _level, ".json"));
    }

    function contractURI() public view returns (string memory) {
        return string(abi.encodePacked(baseURI, "pety.json"));
    }

    // return true if equal, otherwise return false
    function comparePrice(uint256 a, uint256 b) public view returns (bool) {
        if (a == b) {
            return true;
        }
        uint256 subtract;
        uint256 max;
        if (a < b) {
            subtract = b - a;
            max = b;
        } else {
            subtract = a - b;
            max = a;
        }
        return subtract <= ((max * tolerance) / 100000);
    }

    function changeTolerance(uint32 _newValue) public onlyOwner {
        tolerance = _newValue;
    }
}
