# DegenGamingToken

A smart contract for the Degen Gaming Token (DGT) that allows minting, burning, transferring tokens, and redeeming in-game items.

## Description

The `DegenGamingToken` contract is an ERC20-like token specifically designed for the Degen Gaming ecosystem. Players can use DGT to buy in-game items, transfer tokens to each other, and burn tokens they no longer need. The contract includes functions to mint new tokens, transfer tokens, burn tokens, and redeem in-game items, ensuring only the owner can mint new tokens and manage items.

## Getting Started

### Installing

1. Clone the repository or download the `DegenGamingToken.sol` file.
2. Open the file in a Solidity-compatible development environment, such as Remix, Truffle, or Hardhat.

### Executing program

#### Using Remix

1. **Open Remix:**
   - Go to [Remix](https://remix.ethereum.org/).

2. **Create a New File:**
   - In the File Explorer on the left side, click the "+" button to create a new file.
   - Name the file `DegenGamingToken.sol`.

3. **Copy and Paste the Code:**
   - Copy the `DegenGamingToken` contract code and paste it into the new file.

```
   solidity
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
        addItem("Gun", 50);
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

```
   
4.Compile the Contract:

-Click on the "Solidity Compiler" tab (second tab from the top in the left sidebar).
-Ensure the compiler version is set a compatible version.
-Click the "Compile DegenGamingToken.sol" button.

5.Deploy the Contract:

-Click on the "Deploy & Run Transactions" tab (third tab from the top in the left sidebar).
-Ensure "DegenGamingToken" is selected in the "Contract" dropdown.
-Click the "Deploy" button.

6.Interact with the Contract:

-Once deployed, the contract will appear under "Deployed Contracts" at the bottom of the "Deploy & Run Transactions" tab.
You can now interact with the contract functions:
mint(address to, uint256 amount): Mint new tokens to a specified address.
transfer(address to, uint256 amount): Transfer tokens to another address.
burn(uint256 amount): Burn your tokens.
redeem(uint256 itemId): Redeem tokens for an in-game item.
checkBalance(address account): Check the token balance of an address.



## Help

-Ensure you are using the correct Solidity compiler version.
-If a function call reverts, check the parameters you are passing and ensure the conditions are met (e.g., sufficient balance for transfers and redemptions).


## Authors
Sakshi Sankhala


## License
This project is licensed under the MIT License - see the LICENSE.md file for details.
