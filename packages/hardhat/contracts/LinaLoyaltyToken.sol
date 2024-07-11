// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";

contract LinaLoyaltyToken is ERC20, ERC20Burnable, Ownable, Pausable {
    bool public transferable;
    uint256 private constant INITIAL_SUPPLY = 100000 * 10**18;

    event TransferableStatusChanged(bool newStatus);
    event TokensMinted(address indexed to, uint256 amount);
    event TokensBurned(address indexed from, uint256 amount);

    constructor() ERC20("Lina", "LIN") {
        _mint(msg.sender, INITIAL_SUPPLY);
        transferable = false;
    }

    function setTransferable(bool _transferable) external onlyOwner {
        transferable = _transferable;
        emit TransferableStatusChanged(_transferable);
    }

    function mint(address to, uint256 amount) external onlyOwner {
        _mint(to, amount);
        emit TokensMinted(to, amount);
    }

    function burn(uint256 amount) public override {
        super.burn(amount);
        emit TokensBurned(_msgSender(), amount);
    }

    function _beforeTokenTransfer(address from, address to, uint256 amount)
        internal
        override
        whenNotPaused
    {
        require(transferable || from == address(0) || to == address(0), "Transfers are currently disabled");
        super._beforeTokenTransfer(from, to, amount);
    }

    function pause() external onlyOwner {
        _pause();
    }

    function unpause() external onlyOwner {
        _unpause();
    }
}