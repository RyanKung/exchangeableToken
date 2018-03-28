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
  event AskBidAccecpted(uint256 tickerId);
  mapping(uint256 => Ticker) public bidTable;
  mapping(uint256 => Ticker) public askTable;
  function deleteTicker(Ticker t) private pure returns (bool);
  function updateAmount(Ticker t, uint256 amount) private pure returns (bool);
  function increaseBid() private returns (bool);
  function increaseAid() private returns (bool);
  function checkBidTicker(uint256 id) public view returns (address addr,uint256 price,uint256 amount);
  function checkAskTicker(uint256 id) public view returns (address addr,uint256 price,uint256 amount);
  function matchBid(uint256 price) public view returns (uint256);
  function matchAsk(uint256 price) public view returns (uint256);
  function ask (uint256 _price, uint256 _amount) public returns (uint256);
  function bid (uint256 _price, uint256 _amount) public payable returns (uint256);
  function fillBidOrAsk(uint256 id, uint256 price, uint256 amount) public returns (uint256);
  function fillAskOrBid(uint256 id, uint256 price, uint256 amount) public payable returns (uint256);
  function fillBid(uint256 id, uint256 price, uint256 amount) public returns (uint256);
  function fillAsk(uint256 id, uint256 price, uint256 amount) public payable returns (uint256);
  function cancelAsk(uint256 id) public returns (bool);
  function cancelBid(uint256 id) public returns (bool);
}
