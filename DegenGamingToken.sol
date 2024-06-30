// SPDX-License-Identifier: MIT
pragma solidity >=0.8.2 <0.9.0;

contract DegenGamingToken {
    string public name = "Degen Gaming Token";
    string public symbol = "DGT";
    uint8 public decimals = 18;
    uint256 public totalSupply;
    
    address public owner;
    mapping(address => uint) public balanceOf;

    struct Item {
        string name;
        uint256 price;
    }

    mapping(uint => Item) public items; // Item ID to item details mapping
    uint256 public nextItemId = 1;

    mapping(address => mapping(uint => uint)) public redeemedItemCount; // Player's redeemed item count

    event Transfer(address indexed from, address indexed to, uint value);
    event Mint(address indexed to, uint value);
    event Burn(address indexed from, uint value);
    event Redeem(address indexed from, uint itemId, uint value);
    event ItemGranted(address indexed player, uint itemId);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can execute this");
        _;
    }

    constructor() {
        owner = msg.sender;
        
        addItem("Sword", 100);
        addItem("Shield", 150);
        addItem("Potion", 50);
    }

    function addItem(string memory _name, uint _price) public onlyOwner {
        items[nextItemId] = Item(_name, _price);
        nextItemId++;
    }

    function mint(address to, uint amount) public onlyOwner {
        require(to != address(0), "Cannot mint to zero address");
        totalSupply += amount;
        balanceOf[to] += amount;
        emit Mint(to, amount);
        emit Transfer(address(0), to, amount);
    }

    function transfer(address to, uint amount) public returns (bool) {
        require(to != address(0), "Cannot transfer to zero address");
        require(balanceOf[msg.sender] >= amount, "Insufficient balance");
        balanceOf[msg.sender] -= amount;
        balanceOf[to] += amount;
        emit Transfer(msg.sender, to, amount);
        return true;
    }

    function burn(uint amount) public {
        require(balanceOf[msg.sender] >= amount, "Insufficient balance");
        totalSupply -= amount;
        balanceOf[msg.sender] -= amount;
        emit Burn(msg.sender, amount);
        emit Transfer(msg.sender, address(0), amount);
    }

    function redeem(uint itemId) public {
        Item memory item = items[itemId];
        require(bytes(item.name).length > 0, "Item does not exist");
        require(balanceOf[msg.sender] >= item.price, "Insufficient balance to redeem item");

    
        totalSupply -= item.price;
        balanceOf[msg.sender] -= item.price;

        redeemedItemCount[msg.sender][itemId]++;// Track redeemed item count per player

        emit Redeem(msg.sender, itemId, item.price);
        emit Burn(msg.sender, item.price);
        emit Transfer(msg.sender, address(0), item.price);
        emit ItemGranted(msg.sender, itemId);
    }

    function checkBalance(address account) public view returns (uint) {
        return balanceOf[account];
    }
}
