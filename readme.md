## The Exchangeable Extension for ERC20 Token

This is a extension for ERC20 token, which added an build-in exchange to ERC20 token.

===================

[![travis](https://travis-ci.org/RyanKung/exchangeable-erc20.svg?branch=master)](https://travis-ci.org/RyanKung/exchangeable-erc20)



## Example

```
pragma solidity ^0.4.17;

import './DetailedExchangeableERC20.sol';

contract TestToken is DetailedExchangeableERC20 {
  uint8 public decimals = 8;
  string public name;
  string public symbol;

  function TestToken(string _name, string _symbol, uint8 _decimals) DetailedERC20(_name, _symbol, _decimals) public {
    name = _name;
    symbol = _symbol;
    decimals = _decimals;
    balances[msg.sender] = 100000000;
  }
}


```

## Install

```
npm install exchangeable-erc20
```

## Interfaces

```solidity

contract ExchangeableERC20 is StandardToken, DetailedERC20 {
  uint256 public bidTickerId = 0;
  uint256 public askTickerId = 0;

  struct Ticker {
    address addr;
    uint256 price;
    uint256 amount;
  }
  event TickerFilled(string tickerType, uint256 tickerId, uint256 amount, uint256 total);
  event Logging(string msg);
  event TickerAccecpted(string kind, uint256 tickerId);
  mapping(uint256 => Ticker) public bidTable;
  mapping(uint256 => Ticker) public askTable;

  function deleteTicker(Ticker _t) private pure returns (bool);
  function updateAmount(Ticker _t, uint256 _amount) private pure returns (bool);
  function increaseBid() private returns (bool);
  function increaseAid() private returns (bool);
  function checkBidTicker(uint256 _id) public view returns (address _addr,uint256 _price,uint256 _amount);
  function checkAskTicker(uint256 _id) public view returns (address _addr,uint256 _price,uint256 _amount);
  function matchBid(uint256 _price, uint256 _start) public view returns (uint256);
  function matchAsk(uint256 _price, uint256 _start) public view returns (uint256);
  function ask (uint256 _price, uint256 _amount) public returns (uint256);
  function bid (uint256 _price, uint256 _amount) public payable returns (uint256);
  function fillBidOrAsk(uint256 _id, uint256 _price, uint256 _amount) public returns (uint256);
  function fillAskOrBid(uint256 _id, uint256 _price, uint256 _amount) public payable returns (uint256);
  function fillBid(uint256 _id, uint256 _price, uint256 _amount) public returns (uint256);
  function fillAsk(uint256 _id, uint256 _price, uint256 _amount) public payable returns (uint256);
  function cancelAsk(uint256 _id) public returns (bool);
  function cancelBid(uint256 _id) public returns (bool);
}

```
