
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

/*
 * WARNING: This contract is intentionally vulnerable.
 * DO NOT deploy it to a production environment.
 */

contract CryptoSploitable {
    address public owner;
    mapping(address => uint256) public balances;
    mapping(address => bool) public whitelist;
    address[] public users;

    constructor() {
        owner = msg.sender;
    }

    // Reentrancy + unguarded external call
    function withdraw(uint256 _amount) public {
        require(balances[msg.sender] >= _amount, "Insufficient funds");

        (bool sent, ) = msg.sender.call{value: _amount}(""); // Reentrancy point
        require(sent, "Failed to send Ether");

        balances[msg.sender] -= _amount; // Vulnerable: state updated after external call
    }

    // No input validation, allows overflow in arrays
    function addUser(address user) public {
        users.push(user); // No size checks
    }

    // Integer overflow (demonstration only, safe in 0.8+, but keep for legacy comparison)
    function reward(address user, uint256 amount) public {
        balances[user] += amount; // Overflow possible in older versions
    }

    // Integer underflow (pre-0.8.0 Solidity)
    function punish(address user, uint256 amount) public {
        balances[user] -= amount; // Underflow vulnerable in old Solidity
    }

    // Unsafe use of tx.origin for authorization
    function transferOwnership(address newOwner) public {
        require(tx.origin == owner, "Not owner"); // Insecure: tx.origin
        owner = newOwner;
    }

    // Unrestricted selfdestruct
    function nuke() public {
        selfdestruct(payable(msg.sender)); // Anyone can kill the contract
    }

    // Insecure randomness
    function insecureRandom() public view returns (uint256) {
        return uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty, msg.sender)));
    }

    // Unchecked call return value
    function donate(address payable target) public payable {
        target.call{value: msg.value}(""); // No check on result
    }

    // Logic bug - allows multiple claims
    mapping(address => bool) public hasClaimed;

    function claim() public {
        if (!hasClaimed[msg.sender]) {
            balances[msg.sender] += 1 ether;
        }
        // forgot: hasClaimed[msg.sender] = true;
    }

    // Storage collision (intentional) — bad layout
    uint256 public a;
    uint8 public b;
    uint256[] public c;

    // Fallback trap — unguarded fallback can be abused
    fallback() external payable {
        // accepts ETH, does nothing
    }

    receive() external payable {}
}
