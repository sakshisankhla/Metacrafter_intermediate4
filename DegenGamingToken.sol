// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DegenGamingToken {
    string public name = "Degen Gaming Token";
    string public symbol = "DGT";
    uint8 public decimals = 18;
    uint256 public totalSupply;
    
    address public owner;
    mapping(address => uint256) public balanceOf;

    struct Item {
        string name;
        uint256 price;
    }

    mapping(uint256 => Item) public items; // Item ID to item details mapping
    uint256 public nextItemId = 1;

    mapping(address => mapping(uint256 => uint256)) public redeemedItemCount; // Player's redeemed item count

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Mint(address indexed to, uint256 value);
    event Burn(address indexed from, uint256 value);
    event Redeem(address indexed from, uint256 itemId, uint256 value);
    event ItemGranted(address indexed player, uint256 itemId);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can execute this");
        _;
    }

    constructor() {
        owner = msg.sender;
        // Initialize some items in the store with their prices
        addItem("Sword", 100);
        addItem("Shield", 150);
        addItem("Potion", 50);
    }

    function addItem(string memory _name, uint256 _price) public onlyOwner {
        items[nextItemId] = Item(_name, _price);
        nextItemId++;
    }

    function mint(address to, uint256 amount) public onlyOwner {
        require(to != address(0), "Cannot mint to zero address");
        totalSupply += amount;
        balanceOf[to] += amount;
        emit Mint(to, amount);
        emit Transfer(address(0), to, amount);
    }

    function transfer(address to, uint256 amount) public returns (bool) {
        require(to != address(0), "Cannot transfer to zero address");
        require(balanceOf[msg.sender] >= amount, "Insufficient balance");
        balanceOf[msg.sender] -= amount;
        balanceOf[to] += amount;
        emit Transfer(msg.sender, to, amount);
        return true;
    }

    function burn(uint256 amount) public {
        require(balanceOf[msg.sender] >= amount, "Insufficient balance");
        totalSupply -= amount;
        balanceOf[msg.sender] -= amount;
        emit Burn(msg.sender, amount);
        emit Transfer(msg.sender, address(0), amount);
    }

    function redeem(uint256 itemId) public {
        Item memory item = items[itemId];
        require(bytes(item.name).length > 0, "Item does not exist");
        require(balanceOf[msg.sender] >= item.price, "Insufficient balance to redeem item");

        // Burn the tokens used to redeem the item
        totalSupply -= item.price;
        balanceOf[msg.sender] -= item.price;

        // Track redeemed item count per player
        redeemedItemCount[msg.sender][itemId]++;

        emit Redeem(msg.sender, itemId, item.price);
        emit Burn(msg.sender, item.price);
        emit Transfer(msg.sender, address(0), item.price);
        emit ItemGranted(msg.sender, itemId);
    }

    function checkBalance(address account) public view returns (uint256) {
        return balanceOf[account];
    }
}
