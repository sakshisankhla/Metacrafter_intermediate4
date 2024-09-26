# DegenToken with Food Redemption

A smart contract for the Degen Token (DGN) that allows minting, burning, transferring tokens, and redeeming in-game food items.

## Description

The DegenToken contract is a custom ERC20-like token designed for the Degen ecosystem. The contract enables users to mint tokens, burn their tokens, transfer tokens, and redeem in-game food items using their token balance. Players can use DGN tokens to redeem food items such as pizza, burgers, and sushi. Only the owner can mint new tokens, while all users can redeem food or burn tokens they no longer need.

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
   // SPDX-License-Identifier: MIT
pragma solidity 0.8.20;


interface IERC20 {
    function totalSupply() external view returns (uint);
    function balanceOf(address account) external view returns (uint);
    function transfer(address recipient, uint amount) external returns (bool);
    
    event Transfer(address indexed from, address indexed to, uint amount);
}

contract ERC20 is IERC20 {
    address public immutable owner;
    uint public totalSupply;
    mapping (address => uint) public balanceOf;

    struct Food {
        uint foodId;
        string foodName;
        uint foodPrice;
    }
    
    mapping(uint => Food) public foods;
    uint public foodCount;

    // Mapping to track redeemed foods for each user
    mapping(address => mapping(uint => bool)) public redeemedFoods;

    // Event to log food redemption
    event FoodRedeemed(address indexed user, uint indexed foodId, string foodName, uint foodPrice);

    constructor() {
        owner = msg.sender;
        totalSupply = 0;

        // Initialize 3 food items in the constructor
        addFood("Pizza", 10);
        addFood("Burger", 8);
        addFood("Sushi", 15);
    }

    modifier onlyOwner {
        require(msg.sender == owner, "Only the contract owner can execute this function");
        _;
    }

    string public constant name = "Degen";
    string public constant symbol = "DGN";
    uint8 public constant decimals = 0;

    function transfer(address recipient, uint amount) external returns (bool) {
        require(balanceOf[msg.sender] >= amount, "The balance is insufficient");

        balanceOf[msg.sender] -= amount;
        balanceOf[recipient] += amount;

        emit Transfer(msg.sender, recipient, amount);
        return true;
    }

    function mint(address receiver,uint amount) external onlyOwner {
        balanceOf[receiver] += amount;
        totalSupply += amount;
        emit Transfer(address(0), receiver, amount);
    }

    function burn(uint amount) external {
        require(amount > 0, "Amount should not be zero");
        require(balanceOf[msg.sender] >= amount, "The balance is insufficient");
        balanceOf[msg.sender] -= amount;
        totalSupply -= amount;

        emit Transfer(msg.sender, address(0), amount);
    }
    
    function addFood(string memory foodName, uint256 foodPrice) public onlyOwner {
        foodCount++;
        Food memory newFood = Food(foodCount, foodName, foodPrice);
        foods[foodCount] = newFood;
    }

    function getFoods() external view returns (Food[] memory) {
        Food[] memory allFoods = new Food[](foodCount);
        
        for (uint i = 1; i <= foodCount; i++) {
            allFoods[i - 1] = foods[i];
        }
        
        return allFoods;
    }
    
    function redeem(uint foodId) external {
        require(foodId > 0 && foodId <= foodCount, "Invalid food ID");
        Food memory redeemedFood = foods[foodId];
        
        require(balanceOf[msg.sender] >= redeemedFood.foodPrice, "Insufficient balance to redeem");
        require(!redeemedFoods[msg.sender][foodId], "Food already redeemed");

        balanceOf[msg.sender] -= redeemedFood.foodPrice;
        balanceOf[owner] += redeemedFood.foodPrice;

        // Mark the food as redeemed for the user
        redeemedFoods[msg.sender][foodId] = true;

        emit Transfer(msg.sender, owner, redeemedFood.foodPrice);
        emit FoodRedeemed(msg.sender, foodId, redeemedFood.foodName, redeemedFood.foodPrice);
    }
}

```
   
4.Compile the Contract:

-Click on the "Solidity Compiler" tab (second tab from the top in the left sidebar).
-Ensure the compiler version is set to 0.8.20.
-Click the "Compile DegenToken.sol" button.

5.Deploy the Contract:

Click on the "Deploy & Run Transactions" tab (third tab from the top in the left sidebar).
Ensure "DegenGamingToken" is selected in the "Contract" dropdown.
Click the "Deploy" button.

6.Interact with the Contract:

Once deployed, the contract will appear under "Deployed Contracts" at the bottom of the "Deploy & Run Transactions" tab.

You can now interact with the contract functions:

mint(address to, uint256 amount): Mint new tokens to a specified address.

transfer(address to, uint256 amount): Transfer tokens to another address.

burn(uint256 amount): Burn your tokens.

getFoods(): View all available food items.

redeem(uint256 foodId): Redeem tokens for an in-game food item.



## Help

Ensure you are using the correct Solidity compiler version.
if a function call reverts, check the parameters you are passing and ensure the conditions are met (e.g., sufficient balance for transfers and redemptions).


## Authors
Sakshi Sankhala


## License
This project is licensed under the MIT License - see the LICENSE.md file for details.
