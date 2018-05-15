pragma solidity ^0.4.20;

import './ExchangeableERC721.sol';


contract DetailedExchangeableERC721 is ExchangeableERC721 {
  using SafeMath for uint256;

   function deleteTicker(Ticker storage _t) internal returns (bool) {
    _t.addr = address(0);
    _t.price = 0;
    _t.tokenId = 0;
    return true;
  }

  function checkAskTicker(uint256 _tokenId) public view returns (address addr,uint256 price,uint256 tokenId) {
    addr = askTable[_tokenId].addr;
    price = askTable[_tokenId].price;
    tokenId = askTable[_tokenId].tokenId;
    return (addr, price, tokenId);
  }
  function ask (uint256 _price, uint256 _tokenId) public returns (uint256) {
    // send and token and sell for ETH
    require(msg.data.length == 68);
    
    require(_price > uint256(0));
    require(msg.sender==ownerOf(_tokenId));
    
    transferFrom(msg.sender, address(this), _tokenId);
    askTable[_tokenId] = Ticker(msg.sender, _price, _tokenId);
    TickerAccecpted('ask', _tokenId);
    return _tokenId;
  }

  function fillAsk(uint256 _tokenId, uint256 _price) public payable returns (uint256) {
     require(msg.data.length == 68);
     Ticker storage ticker = askTable[_tokenId];
     require(msg.value >= _price);
     assert(ticker.addr != address(0));
     require(ticker.tokenId != uint256(0));
     require(ticker.price <= _price);
     ticker.addr.transfer(msg.value);
     transferFrom(msg.sender, address(this), _tokenId);
     emit TickerFilled('ASK', _tokenId);
     deleteTicker(ticker);
  }

  function cancelAsk(uint256 _id) public returns (bool) {
     Ticker storage ticker = askTable[_id];
     assert(ticker.addr != address(0));
     require(ticker.addr == msg.sender);
     this.transferFrom(address(this), msg.sender, ticker.tokenId);
     require(deleteTicker(ticker));
     emit TickerCanceled('ASK', _id);
     return true;
  }
}
