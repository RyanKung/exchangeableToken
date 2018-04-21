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


