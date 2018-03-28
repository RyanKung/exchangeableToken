pragma solidity ^0.4.17;

import './ExchangeableERC20.sol';

contract DetailedExchangeableERC20 is ExchangeableERC20 {
  using SafeMath for uint256;

  uint256 public bidTickerId = 0;
  uint256 public askTickerId = 0;

  event TickerFilled(string tickerType, uint256 tickerId, uint256 amount, uint256 total);
  event Logging(string msg);
  event AskBidAccecpted(uint256 tickerId);
  mapping(uint256 => Ticker) public bidTable;
  mapping(uint256 => Ticker) public askTable;

  function deleteTicker(Ticker _t) private pure returns (bool) {
    // needs test
    _t.addr = address(0);
    _t.price = 0;
    _t.amount = 0;
    return true;
  }

  function updateAmount(Ticker _t, uint256 _amount) private pure returns (bool) {
    require(_t.amount > _amount);
    _t.amount = _amount;
    return true;
  }

  function increaseBid() private returns (bool) {
    bidTickerId = bidTickerId.add(1);
    return true;
  }

  function increaseAid() private returns (bool) {
    askTickerId = askTickerId.add(1);
    return true;
  }

  function checkBidTicker(uint256 _id) public view returns (address addr,uint256 price,uint256 amount) {
    addr = bidTable[_id].addr;
    price = bidTable[_id].price;
    amount = bidTable[_id].amount;
  }

  function checkAskTicker(uint256 _id) public view returns (address addr,uint256 price,uint256 amount) {
    addr = askTable[_id].addr;
    price = askTable[_id].price;
    amount = askTable[_id].amount;
  }
  
  function matchBid(uint256 _price) public view returns (uint256) {
    uint256 i = 0;
    while(i<= bidTickerId && bidTable[i].price != _price) {
      i = i.add(1);
    }
    return i;
  }

  function matchAsk(uint256 _price) public view returns (uint256) {
    uint256 i = 0;
    while( i<= askTickerId && askTable[i].price != _price) {
      i = i.add(1);
    }
    return i;
  }

  function ask (uint256 _price, uint256 _amount) public returns (uint256) {
    // send and token and sell for ETH
    require(msg.data.length == 68);
    require(balanceOf(msg.sender) >= _amount);
    require(approve(address(this), _amount));
    require(allowance(msg.sender, address(this)) == _amount);
    require(this.transferFrom(msg.sender, address(this), _amount));

    askTable[askTickerId] = Ticker(msg.sender, _price, _amount);
    AskBidAccecpted(askTickerId);
    require(increaseAid());
    return askTickerId;
  }

  function bid (uint256 _price, uint256 _amount) public payable returns (uint256) {
    require(msg.data.length == 68);
    // send Ether and sell for token
    require(msg.value >= _amount);
    bidTable[bidTickerId] = Ticker(msg.sender, _price, _amount);
    AskBidAccecpted(bidTickerId);
    require(increaseBid());
    return bidTickerId;
  }

  function fillBidOrAsk(uint256 _id, uint256 _price, uint256 _amount) public returns (uint256) {
     Ticker storage ticker = bidTable[_id];
     if (ticker.addr == address(0)) {
       return ask(_price, _amount);
     } else {
       return fillBid(_id, _amount, _price);
     }
  }

  function fillAskOrBid(uint256 _id, uint256 _price, uint256 _amount) public payable returns (uint256) {
     Ticker storage ticker = bidTable[_id];
     if (ticker.addr == address(0)) {
       return bid(_price, _amount);
     } else {
       return fillAsk(_id, _amount, _price);
     }
  }

  function fillBid(uint256 _id, uint256 _price, uint256 _amount) public returns (uint256) {
    require(msg.data.length == 68);
    // send Token and get Eth
    Ticker storage ticker = bidTable[_id];

    require(balanceOf(msg.sender) >= _amount);
    assert(ticker.addr != address(0));
    require(ticker.amount != uint256(0));
    require(ticker.price == _price);

    uint256 valueEth = _amount.mul(ticker.price);

    require(valueEth <= ticker.amount);
    // calculate how much token should be left in ticket 
    uint256 leftEth = ticker.amount.sub(valueEth);

    // send token to ticker creater
    require(approve(address(this), _amount));
    this.transferFrom(msg.sender, ticker.addr, _amount); // trans token from msg sender to ticker creater

    // send eth to msg sender
    msg.sender.transfer(valueEth);

    if (leftEth > 0) {
      require(updateAmount(ticker, leftEth));
    } else {
      require(deleteTicker(ticker));
    }
    TickerFilled('bid', _id, _amount, ticker.amount);
    return uint256(1);
  }

  function fillAsk(uint256 _id, uint256 _price, uint256 _amount) public payable returns (uint256) {
    require(msg.data.length == 68);
    // send ETH and get Token
    Ticker storage ticker = askTable[_id];

    require(msg.value >= _amount);
    assert(ticker.addr != address(0));
    require(ticker.amount != uint256(0));
    require(ticker.price == _price);

    uint256 valueToken = _amount.div(ticker.price);

    require(valueToken <= ticker.amount);
    uint256 leftToken  = ticker.amount.sub(valueToken);

    // send eth to ticker creater
    ticker.addr.transfer(_amount);
    // send token to msg sender
    transfer(msg.sender, valueToken);


    if (leftToken > 0) {
      require(updateAmount(ticker, leftToken));
    } else {
      require(deleteTicker(ticker));
    }
    TickerFilled('ask', _id, _amount, ticker.amount);
    return uint256(1);
  }
    

  function cancelAsk(uint256 _id) public returns (bool) {
    Ticker storage ticker = askTable[_id];
    assert(ticker.addr != address(0));
    require(ticker.addr == msg.sender);
    transfer(msg.sender, ticker.amount);
    require(deleteTicker(ticker));
    return true;
  }


  function cancelBid(uint256 _id) public returns (bool) {
    Ticker storage ticker = askTable[_id];
    assert(ticker.addr != address(0));
    require(ticker.addr == msg.sender);
    msg.sender.transfer(ticker.amount);
    require(deleteTicker(ticker));
    return true;
  }

}
