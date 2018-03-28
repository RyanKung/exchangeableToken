var TestToken = artifacts.require("./TestToken.sol");

contract('TestTestToken', function(accounts) {
    let tst = null;
    let startBlock = null;
    beforeEach('Init Contract', function (){
        console.log(web3.eth.blockNumber)
        if (!tst) {
            console.log('deployed')
            tst = TestToken.new('premierToken', 'TST', 8);
            startBlock = web3.eth.blockNumber;
        }
    })
    it("Test bid Function", function () {
        TestToken.deployed().then(function(ins) {
            tst = ins;
            return tst.balanceOf.call(accounts[1]);
        }).then(function (res) {
            assert.equal(res.toNumber(), 0);
        }).then(function() {
            return tst.bid.call(1, 10, { from: accounts[1], value: web3.toWei(10) });
        }).then(function (res) {
            assert.equal(res.toNumber(), 1);
        })
    })
    it("Test ask Function", function () {
        console.log(accounts[0]);
        TestToken.deployed().then(function(ins) {
            tst = ins;
            return tst.balanceOf.call(accounts[0]);
        }).then(function (res) {
            assert.equal(res.toNumber(), 100000000);
        }).then(function () {
            return tst.ask.call(1, 100, { from: accounts[0] });
        }).then(function (res) {
            assert.equal(res.toNumber(), 1);
        }).then(function () {
            it("balance should be sub", function() {
                TestToken.deployed().then(function(ins) {
                    return ins.balanceOf.call(accounts[0]);
                }).then(function(res) {
                    assert.equal(res.toNumber(), 100000000 - 100)
                })
            })
        })
    })
})

