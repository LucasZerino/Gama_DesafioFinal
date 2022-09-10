// SPDX-License-Identifier: MIT

pragma solidity ^0.8.16;

import './ERC20.sol';

contract PokeStop is ERC20 {
    address payable public owner;
    uint256 public coinPrice;
    uint256 public sellPrice;
    uint256 public ManaPrice = 1;
    uint256 public HealthPrice = 1;
    mapping(address => uint) public MachineBalance;
    mapping(address => uint) public HealthPotion;
    mapping(address => uint) public ManaPotion;

    constructor() ERC20("PokeCoin", "PKC") {
        uint256 _amount = 1000;
        _mint(msg.sender, _amount);
        owner = payable(msg.sender);
        ManaPotion[address(this)] = 100;
        HealthPotion[address(this)] = 100;
    }

    modifier isOwner() {
    require(msg.sender == owner , "Apenas o admin pode realizar essa operacao!");
    _;
    }

     modifier validPrice(uint256 _price) {
    require(_price > 0 , "O valor nao pode ser 0!");
    _;
    }

    function refill(uint amount, uint256 _coinPrice, uint256 _sellPrice) public isOwner {
        require(balanceOf(msg.sender) >= amount, "Voce nao tem tokens suficientes para realizar essa operacao!");
        require(amount>0, "Voce nao pode recarregar  maquina com 0 tokens!");
        require(_coinPrice > 0, "O valor de compra do token nao pode ser 0!");
        require(_sellPrice > 0, "O valor de venda do token nao pode ser 0!");
        _transfer(msg.sender, address(this), amount);
        MachineBalance[address(this)] = amount;
        coinPrice = _coinPrice * 1 ether;
        sellPrice = _sellPrice * 1 ether;
    }

    function refillEthers(uint _amount) payable public isOwner{
        require(_amount>0, "Voce nao pode recarregar a maquina com 0 Ethers");
    }

    function refillHealthPotion(uint _amount) public isOwner{
        require(_amount > 0, "Nao e possivel adicionar 0 pocoes!");
        HealthPotion[address(this)] += _amount;
    }

    function refillManaPotion(uint _amount) public isOwner{
        require(_amount > 0, "Nao e possivel adicionar 0 pocoes!");
        ManaPotion[address(this)] += _amount;
    }

    function buyCoin (uint amount) payable public {
        require(msg.value >= amount * coinPrice, "O valor e insuficiente!");
        require(MachineBalance[address(this)]>=amount, "A maquina nao tem tokens o suficiente");
        _transfer(address(this), msg.sender, amount);
        MachineBalance[address(this)] -= amount;
        MachineBalance[msg.sender] += amount;
    }

    function buyMana (uint amount) payable public {
        require(ManaPotion[address(this)] >= amount, "Nosso estoque nao tem pocoes suficientes!");
        require(MachineBalance[address(this)]>= (amount*ManaPrice), "Voce nao tem tokens suficientes para realizar essa compra");
        MachineBalance[address(this)] += amount;
        MachineBalance[msg.sender] -= amount;
        ManaPotion[address(this)] -= amount;
        ManaPotion[msg.sender] -= amount;
    }

    function buyHealth (uint amount) payable public {
        require(HealthPotion[address(this)] >= amount, "Nosso estoque nao tem pocoes suficientes!");
        require(MachineBalance[address(this)]>= (amount*HealthPrice), "Voce nao tem tokens suficientes para realizar essa compra");
        MachineBalance[address(this)] += amount;
        MachineBalance[msg.sender] -= amount;
        HealthPotion[address(this)] -= amount;
        HealthPotion[msg.sender] -= amount;
    }

    function sellCoin (uint _amount, address payable _recipient) payable public {
        require(MachineBalance[msg.sender]>=_amount, "Voce nao tem tokens suficientes!");
        require(address(this).balance >= _amount, "A maquina nao tem ether o suficiente!");
        _transfer(msg.sender, address(this), _amount);
        MachineBalance[msg.sender] -= _amount;
        MachineBalance[address(this)] += _amount; 
        _recipient.transfer(_amount * sellPrice);
    }

    function withdraw(uint _amount) external isOwner{
        require(address(this).balance >= _amount, "A maquina nao tem ether o suficiente!");
        owner.transfer(_amount * 1 ether);
    }

    function viewMachineEthers() public view returns(uint256){
        return address(this).balance;
    }

    function changeBuyPrice(uint256 _price) public isOwner validPrice(_price){
        coinPrice = _price * 1 ether;
    }

    function changeSellPrice(uint256 _price) public isOwner validPrice(_price){
        sellPrice = _price * 1 ether;
    }

    function changeHealthPrice(uint256 _price) public isOwner validPrice(_price){
        HealthPrice = _price * 1 ether;
    }

     function changeManaPrice(uint256 _price) public isOwner validPrice(_price){
        ManaPrice = _price * 1 ether;
    }

    function UseHealth(uint value) private{
        HealthPotion[msg.sender] -= value;
    }

    function UseMana(uint value) private{
        HealthPotion[msg.sender] -= value;
    }
}