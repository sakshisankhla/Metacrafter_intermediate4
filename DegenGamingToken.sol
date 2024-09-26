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
