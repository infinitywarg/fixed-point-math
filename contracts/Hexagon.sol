//SPDX-License-Identifier: MIT
pragma solidity =0.8.8;

/// @title Simple Solidity library for 6-decimal fixed point math
/// @author @infinitywarg for @infinitywarp Labs
/// @notice Fixed point math operations with 6-decimals for DeFi applications
/// @dev By restricting the math inputs to +/- 1 trillion with 6-decimals i.e. 1e18, overflow/underflow never occcurs for 128-bit signd integers

contract Hexagon {
    int128 private constant MAX = 1e18;
    int128 private constant MIN = -1e18;
    int128 private constant MAX18 = 1e30;
    int128 private constant MIN18 = -1e30;
    int128 private constant ADJ18 = 1e12;
    int128 internal constant UNITY = 1e6;
    int128 internal constant PI = 3_141593;
    int128 internal constant E = 2_718282;
    int128 internal constant LOG2E = 1_442695;

    /// @notice Modifier to check for overflow and underflow
    /// @dev Maximum Number = 999,999,999,999.999999, Minimum Number = -999,999,999,999.999999
    /// @param x First operand in mathematical operation

    modifier check(int128 x) {
        require(x > MIN && x < MAX);
        _;
    }

    function from18(int256 x) internal pure returns (int128 result) {
        unchecked {
            require(x > MIN18 && x < MAX18);
            result = int128(x / ADJ18);
        }
    }

    function to18(int128 x) internal pure check(x) returns (int256 result) {
        unchecked {
            result = x * ADJ18;
        }
    }

    function add(int128 x, int128 y)
        internal
        pure
        check(x)
        check(y)
        returns (int128 result)
    {
        unchecked {
            result = x + y;
        }
    }

    function sub(int128 x, int128 y)
        internal
        pure
        check(x)
        check(y)
        returns (int128 result)
    {
        unchecked {
            result = x - y;
        }
    }

    function mul(int128 x, int128 y)
        internal
        pure
        check(x)
        check(y)
        returns (int128 result)
    {
        unchecked {
            result = (x * y) / UNITY;
        }
    }

    function div(int128 x, int128 y)
        internal
        pure
        check(x)
        check(y)
        returns (int128 result)
    {
        unchecked {
            require(y != 0);
            result = (x * UNITY) / y;
        }
    }

    function sqrt(int128 x) internal pure check(x) returns (int128 result) {
        unchecked {
            require(x >= 0);
        }
    }

    function ln(int128 x) internal pure check(x) returns (int128 result) {
        unchecked {
            require(x >= 0);
        }
    }

    function log2(int128 x) internal pure check(x) returns (int128 result) {
        unchecked {
            require(x >= 0);
        }
    }

    function exp(int128 x) internal pure check(x) returns (int128 result) {
        unchecked {}
    }

    function exp2(int128 x) internal pure check(x) returns (int128 result) {
        unchecked {}
    }

    function pow(int128 x, int128 y)
        internal
        pure
        check(x)
        check(y)
        returns (int128 result)
    {
        unchecked {}
    }
}
