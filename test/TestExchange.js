var TestToken = artifacts.require("./TestToken.sol");

contract('TestTestToken', function(accounts) {

    let tst = null;
    let startBlock = null;
    let initToken = 100000000;
    it("Test bid Function", function () {
        TestToken.deployed().then(function(ins) {
            tst = ins;
            return tst.balanceOf.call(accounts[1]);
        }).then(function (res) {
            assert.equal(res.toNumber(), 0);
        }).then(function() {
            return tst.bid.call(1, 10, { from: accounts[1], value: web3.toWei(10) });
        }).then(function (res) {
            assert.equal(res.toNumber(), 0);
        })
    })
    it("should transfer right token", function() {
        var token;
        return TestToken.deployed().then(function(ins) {
            tst = ins;
            return tst.transfer(accounts[1], 50);
        }).then(function(res){
            console.log(res.logs[0].event)
            return tst.balanceOf.call(accounts[0]);
        }).then(function(res){
            assert.equal(res.toNumber(), initToken-50, 'accounts[0] balance is wrong');
            return tst.balanceOf.call(accounts[1]);
        }).then(function(res){
            assert.equal(res.toNumber(), 50, 'accounts[1] balance is wrong');
        })
    });
    it("Test ask Function", function () {
        TestToken.deployed().then(function(ins) {
            tst = ins;
            return tst.balanceOf.call(accounts[0]);
        }).then(function (res) {
            assert.equal(res.toNumber(), initToken - 50);
        }).then(function () {
            return tst.ask.sendTransaction(1, 100, {'from': accounts[0]});
        }).then(function () {
            return tst.ask.call(1, 100, {'from': accounts[0]});
        }).then(function (res) {
            assert.equal(res.toNumber(), 1);
        }).then(function() {
            return tst.balanceOf.call(accounts[0]);
        }).then(function(res) {
            assert.equal(res.toNumber(), initToken - 50 - 100)
        }).then(function() {
            return tst.checkAskTicker.call(0)
        }).then(function(res) {
            assert.equal(res[0], accounts[0]);
        })
    })
    it("Test cancel ask", function() {
        TestToken.deployed().then(function(ins) {
            tst = ins;
            return tst.cancelAsk.sendTransaction(0, accounts[0]);
        }).then(function (res) {
            console.log(res);
        }).then(function() {
            return tst.balanceOf(accounts[0]);
        }).then(function(res) {
            assert.equal(res.toNumber(), initToken - 50);
        })
    })
})

