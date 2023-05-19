// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract HuraToken is ERC20, Ownable {
    uint256 public maxSupply;
    address public moderator;
    uint256 public moderatorMaxSupply;
    uint256 public moderatorSupply;

    constructor() ERC20("Hura Token", "HRA") {
        moderator = msg.sender;
        maxSupply = 9 * (10 ** 29); // 900B
        moderatorMaxSupply = 50 * (10 ** 24); // 50M
        moderatorSupply = 0;
        _mint(msg.sender, 9 * (10 ** 27)); // 9B
    }

    function mint(address to, uint256 amount) external onlyModerator {
        require(maxSupply >= totalSupply() + amount, "Exceed maxSupply");
        require(
            moderatorMaxSupply >= moderatorSupply + amount,
            "Exceed moderatorMaxSupply"
        );
        _mint(to, amount);
        moderatorSupply += amount;
    }

    function burn(address from, uint256 amount) external onlyModerator {
        _burn(from, amount);
        if (moderatorSupply < amount) {
            moderatorSupply = 0;
        } else {
            moderatorSupply -= amount;
        }
    }

    modifier onlyModerator() {
        require(
            msg.sender == moderator,
            "Only the moderator can call this function"
        );
        _;
    }

    function changeModerator(address newModerator) external onlyOwner {
        require(newModerator != address(0), "moderator cannot be zero address");
        moderator = newModerator;
    }

    function changeModeratorMaxSupply(
        uint256 newModeratorMaxSupply
    ) external onlyOwner {
        moderatorMaxSupply = newModeratorMaxSupply;
    }

    function resetModeratorSupply() external onlyOwner {
        moderatorSupply = 0;
    }
}
