pragma solidity ^0.4.17;

import 'zeppelin-solidity/contracts/token/ERC721/ERC721Token.sol';
import './Exchangeable.sol';

contract ExchangeableERC721 is ERC721Token, Exchangeable {

  struct Ticker {
    address addr;
    uint256 price;
    uint256 tokenId;
  }
  mapping(uint256 => Ticker) public askTable;
  function deleteTicker(Ticker storage _t) private returns (bool);
}
