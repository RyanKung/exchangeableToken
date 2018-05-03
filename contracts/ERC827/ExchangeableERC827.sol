pragma solidity ^0.4.17;

import 'zeppelin-solidity/contracts/token/ERC827/ERC827Token.sol';
import '../ERC20/ExchangeableERC20Interface.sol';


contract ExchangeableERC827 is ERC827Token, ExchangeableERC20Interface {
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

  function increaseBid() private returns (bool);
  function increaseAid() private returns (bool);
  function deleteTicker(Ticker storage _t) private returns (bool);
  function updateAmount(Ticker storage _t, uint256 _amount) private returns (bool);

}
