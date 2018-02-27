pragma solidity ^0.4.18;

import 'zeppelin-solidity/contracts/token/ERC721/ERC721Token.sol';
import 'zeppelin-solidity/contracts/ownership/Ownable.sol';

contract ColorsERC721 is ERC721Token, Ownable {
  string constant public NAME = "COLORS";
  string constant public SYMBOL = "HEX";

  uint constant public PRICE = .001 ether;

  mapping(uint => uint) tokenToPriceMap;

  modifier onlyMintedTokens(uint _colorId) {
    require(tokenToPriceMap[_colorId] != 0);
    _;
  }

  function ColorsERC721() public {

  }

  function getName() public pure returns(string) {
    return NAME;
  }

  function getSymbol() public pure returns(string) {
    return SYMBOL;
  }

  function mint(uint _colorId) public payable {
    require(msg.value >= PRICE);
    _mint(msg.sender, _colorId);
    tokenToPriceMap[_colorId] = PRICE;

    if (msg.value > PRICE) {
      uint priceExcess = msg.value - PRICE;
      msg.sender.transfer(priceExcess);
    }
  }

  function claim(uint _colorId) public payable onlyMintedTokens(_colorId) {
    uint askingPrice = getClaimingPrice(_colorId);
    require(msg.value >= askingPrice);
    clearApprovalAndTransfer(ownerOf(_colorId), msg.sender, _colorId);
    tokenToPriceMap[_colorId] = askingPrice;
  }

  function getClaimingPrice(uint _colorId) public view onlyMintedTokens(_colorId) returns(uint) {
    uint oldPrice = tokenToPriceMap[_colorId];
    uint newPrice = (oldPrice * 50) / 100;
    return newPrice;
  }
}
