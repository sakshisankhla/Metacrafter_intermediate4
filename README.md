# DegenToken with Ticket Redemption

A smart contract for the Degen Token (DGN) that allows minting, burning, transferring tokens, and redeeming tickets.

## Description

The DegenToken contract is a custom ERC20-like token designed for the Degen ecosystem. This contract enables users to mint tokens, burn their tokens, transfer tokens, and redeem tickets using their token balance. Players can use DGN tokens to redeem various tickets, each associated with a specific price. Only the owner can mint new tokens, while all users can redeem tickets or burn tokens they no longer need.

## Getting Started

### Installing

Clone the repository or download the DegenToken.sol file.
Open the file in a Solidity-compatible development environment, such as Remix, Truffle, or Hardhat.


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
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract DegenToken is ERC20, Ownable {

    struct Ticket {
        uint ticketId;
        string ticketName;
        uint ticketPrice;
    }

    mapping(uint => Ticket) public tickets;
    uint public ticketCount;

    // Mapping to track redeemed tickets for each user
    mapping(address => mapping(uint => bool)) public redeemedTickets;

    // Event to log ticket redemption
    event RedeemToken(address account, uint ticketId);
    event BurnToken(address account, uint amount);
    event TicketRedeemed(address indexed user, uint indexed ticketId, string ticketName, uint ticketPrice);

    constructor() ERC20("Degen", "DGN") Ownable(msg.sender) {
        // The Ownable constructor is initialized automatically, setting msg.sender as the owner
    }

    function mint(address receiver, uint amount) public onlyOwner {
        _mint(receiver, amount);
    }

    function burn(uint amount) public {
        _burn(msg.sender, amount);
        emit BurnToken(msg.sender, amount);
    }

    // Add a new ticket with a name and price
    function addTicket(string memory ticketName, uint ticketPrice) public onlyOwner {
        ticketCount++;
        Ticket memory newTicket = Ticket(ticketCount, ticketName, ticketPrice);
        tickets[ticketCount] = newTicket;
    }

    // Get a list of all tickets
    function getTickets() external view returns (Ticket[] memory) {
        Ticket[] memory allTickets = new Ticket[](ticketCount);

        for (uint i = 1; i <= ticketCount; i++) {
            allTickets[i - 1] = tickets[i];
        }

        return allTickets;
    }

    // Redeem a ticket by its ID
    function redeem(uint ticketId) public {
        require(ticketId > 0 && ticketId <= ticketCount, "Invalid ticket ID");
        Ticket memory ticket = tickets[ticketId];
        require(balanceOf(msg.sender) >= ticket.ticketPrice, "Insufficient balance to redeem this ticket");
        require(!redeemedTickets[msg.sender][ticketId], "Ticket already redeemed");

        // Burn the required tokens
        burn(ticket.ticketPrice);

        // Mark the ticket as redeemed for the user
        redeemedTickets[msg.sender][ticketId] = true;

        emit TicketRedeemed(msg.sender, ticketId, ticket.ticketName, ticket.ticketPrice);
        emit RedeemToken(msg.sender, ticketId);
    }

    // Check if a ticket has been redeemed by a specific user
    function isTicketRedeemed(address user, uint ticketId) external view returns (bool) {
        return redeemedTickets[user][ticketId];
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

burn(uint256 amount): Burn your tokens.

addTicket(string memory ticketName, uint ticketPrice): Add a new ticket.

getTickets(): View all available tickets.

redeem(uint256 ticketId): Redeem tokens for a ticket.

isTicketRedeemed(address user, uint256 ticketId): Check if a specific user has redeemed a ticket.



## Help

Ensure you are using the correct Solidity compiler version.
if a function call reverts, check the parameters you are passing and ensure the conditions are met (e.g., sufficient balance for transfers and redemptions).


## Authors
Sakshi Sankhala


## License
This project is licensed under the MIT License - see the LICENSE.md file for details.
