## The Smart Contract and Develop Components for CryptoX

## Dependence:

* npm
* geth > 1.8
* parity
* Truffle > 4.1.0
* ganache
* solidity-repl

## Development:

* Simply test on ganache:

bootup a ganache client:

```
make migrate

```

* Testing on private developing ethereum network:

```
make mine

make rpc

make migrate
```

* With metamask:

```
npm install
npm run dev

then visit with metamask via setting your web3 provider to private chain

thus add the private key of main test address to the metamask account
```
