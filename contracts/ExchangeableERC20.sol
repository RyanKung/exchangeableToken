pragma solidity ^0.4.17;

import 'zeppelin-solidity/contracts/token/ERC20/StandardToken.sol';
import 'zeppelin-solidity/contracts/token/ERC20/DetailedERC20.sol';

contract ExchangeableERC20 is StandardToken, DetailedERC20 {
  using SafeMath for uint256;

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

  function deleteTicker(Ticker storage _t) private returns (bool);
  function updateAmount(Ticker storage _t, uint256 _amount) private returns (bool);
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
