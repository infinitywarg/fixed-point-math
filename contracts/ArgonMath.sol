//SPDX-License-Identifier: MIT
pragma solidity =0.8.8;

/// @title Simple Solidity library for 18-decimal fixed point math
/// @author @infinitywarg for @infinitywarp Labs
/// @notice Fixed point math operations with 18-decimals for DeFi applications
/// @dev By restricting the operands to +/- 10^18 with 18-decimals i.e. 10^36, overflow/underflow never occcurs for 256-bit signed integers
/// @dev 10^36 * 10^36 = 10*72 always less than 2^255-1
/// @dev For most applications, 10^18 i.e. 1 million trillion whole units is a large enough amount

contract ArgonMath {
    int256 private constant MAX = 1e36;
    int256 private constant MIN = -1e36;
    int256 internal constant UNITY = 1e18;
    int256 internal constant PI = 3_141592_653589_793238;
    int256 internal constant E = 2_718281_828459_045235;
    int256 internal constant LOG2E = 1_442695_040888_963407;

    error Argon__Overflow(int256 x);
    error Argon__Underflow(int256 x);
    error Argon__DivideByZero(int256 x, int256 y);
    error Argon__NegativeSqrt(int256 x);
    error Argon__NegativeLog(int256 x);

    /// @notice Modifier to check for overflow and underflow
    /// @dev Maximum Number = 999,999,999,999.999999, Minimum Number = -999,999,999,999.999999
    /// @param x First operand in mathematical operation

    modifier check(int256 x) {
        if (x >= MAX) {
            revert Argon__Overflow(x);
        }
        if (x <= MIN) {
            revert Argon__Underflow(x);
        }
        _;
    }

    function add(int256 x, int256 y)
        internal
        pure
        check(x)
        check(y)
        returns (int256 result)
    {
        unchecked {
            result = x + y;
        }
    }

    function sub(int256 x, int256 y)
        internal
        pure
        check(x)
        check(y)
        returns (int256 result)
    {
        unchecked {
            result = x - y;
        }
    }

    function mul(int256 x, int256 y)
        internal
        pure
        check(x)
        check(y)
        returns (int256 result)
    {
        unchecked {
            result = (x * y) / UNITY;
        }
    }

    function div(int256 x, int256 y)
        internal
        pure
        check(x)
        check(y)
        returns (int256 result)
    {
        if (y == 0) {
            revert Argon__DivideByZero(x, y);
        }
        unchecked {
            result = (x * UNITY) / y;
        }
    }

    function sqrt(int256 x) internal pure check(x) returns (int256 result) {
        if (x < 0) {
            revert Argon__NegativeSqrt(x);
        }
        unchecked {}
    }

    function ln(int256 x) internal pure check(x) returns (int256 result) {
        if (x < 0) {
            revert Argon__NegativeLog(x);
        }
        unchecked {
            require(x >= 0);
        }
    }

    function log2(int256 x) internal pure check(x) returns (int256 result) {
        if (x < 0) {
            revert Argon__NegativeLog(x);
        }
        unchecked {
            require(x >= 0);
        }
    }

    function exp(int256 x) internal pure check(x) returns (int256 result) {
        unchecked {}
    }

    function exp2(int256 x) internal pure check(x) returns (int256 result) {
        unchecked {}
    }

    function pow(int256 x, int256 y)
        internal
        pure
        check(x)
        check(y)
        returns (int256 result)
    {
        unchecked {}
    }
}
