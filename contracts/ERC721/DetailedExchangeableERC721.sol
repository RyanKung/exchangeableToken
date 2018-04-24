import './ExchangeableERC721.sol';

contract DetailedExchangeableERC721 {
  using SafeMath for uint256;

   function deleteTicker(Ticker storage _t) private returns (bool) {
    _t.addr = address(0);
    _t.price = 0;
    _t.tokenId = 0;
    return true;
  }

  function checkAskTicker(uint256 _tokenId) public view returns (address addr,uint256 price,uint256 amount) {
    addr = askTable[_tokenId].addr;
    price = askTable[_tokenId].price;
    amount = askTable[_tokenId].amount;
    return (addr, price, amount);
  }
  function ask (uint256 _price, uint256 _tokenId) public returns (uint256) {
    // send and token and sell for ETH
    require(msg.data.length == 68);
    require(approve(address(this), _tokenId));
    require(takeOwnership(_tokenId));
    askTable[_tokenId] = Ticker(msg.sender, _price, _tokenId);
    TickerAccecpted('ask', askTickerId);
    return _tokenId
  }
  function fillAsk(uint256 _tokenId, uint256 _price) public payable returns (uint256) {
     require(msg.data.length == 68);
     Ticker storage ticker = askTable[_tokenId];
     require(msg.value >= _price);
     assert(ticker.addr != address(0));
     require(ticker.tokenId != uint256(0));
     require(ticker.price <= _price);
     ticker.addr.transfer(msg.value);
     transfer(msg.sender, _tokenId);
     TickerFilled('ASK', _tokenId);
     deleteTicker(_tokenId);
  }
}
