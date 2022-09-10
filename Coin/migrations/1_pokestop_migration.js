const PokeStop = artifacts.require("PokeStop");

module.exports = function(deployer){
    deployer.deploy(PokeStop);
}