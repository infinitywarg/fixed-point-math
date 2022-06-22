//SPDX-License-Identifier: MIT
pragma solidity =0.8.8;

/// @title Simple Solidity library for 6-decimal fixed point math
/// @author @infinitywarg for @infinitywarp Labs
/// @notice Fixed point math operations with 6-decimals for DeFi applications
/// @dev By restricting the math inputs to +/- 1 trillion with 6-decimals i.e. 1e18, overflow/underflow never occcurs for 128-bit signd integers

contract Hexagon {
    int128 private constant MAX_INT = 1e18;
    int128 private constant MIN_INT = -1e18;
    int128 private constant SCALE = 1e6;

    /// @notice Modifier to check for overflow and underflow
    /// @dev Maximum Number = 999,999,999,999.999999, Minimum Number = -999,999,999,999.999999
    /// @param x First operand in mathematical operation
    /// @param y Second operand in mathematical operation

    modifier check(int128 x, int128 y) {
        require(x > MIN_INT && x < MAX_INT && y > MIN_INT && y < MAX_INT);
        _;
    }

    function mul(int128 x, int128 y) public pure returns (int128 result) {
        unchecked {
            result = (x * y) / SCALE;
        }
    }

    function div(int128 x, int128 y) public pure returns (int128 result) {
        unchecked {
            require(y != 0);
            result = (x * SCALE) / y;
        }
    }
}
