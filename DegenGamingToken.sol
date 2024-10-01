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
