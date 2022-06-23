//SPDX-License-Identifier: MIT
pragma solidity =0.8.8;

/// @title Simple Solidity library for 18-decimal fixed point math
/// @author @infinitywarg for @infinitywarp Labs
/// @notice Fixed point math operations with 18-decimals for DeFi applications
/// @dev By restricting the inputs to +/- 10^18 with 18-decimals i.e. 10^36, overflow/underflow never occcurs for 256-bit signed integers
/// @dev 10^36 * 10^36 = 10*72 always less than 2^255-1
/// @dev For most applications, 10^18 i.e. 1 million trillion whole units is a large enough amount

contract ArgonMath {
    int256 private constant MAX = 1e36;
    int256 private constant MIN = -1e36;
    int256 internal constant UNITY = 1e18;
    int256 internal constant HUNDRED = 1e20;
    int256 internal constant PI = 3_141592_653589_793238;
    int256 internal constant E = 2_718281_828459_045235;
    int256 internal constant LOG2E = 1_442695_040888_963407;

    error Argon__Overflow(int256 x);
    error Argon__Underflow(int256 x);
    error Argon__DivideByZero(int256 x, int256 y);
    error Argon__NegativeInput(int256 x);

    /// @notice Modifier to check for overflow and underflow
    /// @dev Maximum Decimal Value = 999999999999999999.999999999999999999
    /// @dev Minimum Decimal Value = - 999999999999999999.999999999999999999
    /// @param x Input in mathematical operation

    modifier check(int256 x) {
        if (x >= MAX) {
            revert Argon__Overflow(x);
        }
        if (x <= MIN) {
            revert Argon__Underflow(x);
        }
        _;
    }

    modifier checkNegative(int256 x) {
        if (x < 0) {
            revert Argon__NegativeInput(x);
        }
        if (x >= MAX) {
            revert Argon__Overflow(x);
        }
        _;
    }

    function add(int256 x, int256 y) internal pure check(x) check(y) returns (int256 result) {
        unchecked {
            result = x + y;
        }
    }

    function sub(int256 x, int256 y) internal pure check(x) check(y) returns (int256 result) {
        unchecked {
            result = x - y;
        }
    }

    function mul(int256 x, int256 y) internal pure check(x) check(y) returns (int256 result) {
        unchecked {
            result = (x * y) / UNITY;
        }
    }

    function div(int256 x, int256 y) internal pure check(x) check(y) returns (int256 result) {
        if (y == 0) {
            revert Argon__DivideByZero(x, y);
        }
        unchecked {
            result = (x * UNITY) / y;
        }
    }

    function percent(int256 x, int256 y) internal pure check(x) check(y) returns (int256 result) {
        unchecked {
            result = (x * y) / HUNDRED;
        }
    }

    function sqrt(int256 x) internal pure checkNegative(x) returns (int256 result) {
        if (x == 0) {
            return 0;
        }
        result = _sqrt(x * UNITY);
    }

    function _sqrt(int256 x) private pure check(x) returns (int256 result) {
        // Set the initial guess to the least power of two that is greater than or equal to sqrt(x).
        int256 xAux = x;
        result = 1;
        if (xAux >= 0x100000000000000000000000000000000) {
            xAux >>= 128;
            result <<= 64;
        }
        if (xAux >= 0x10000000000000000) {
            xAux >>= 64;
            result <<= 32;
        }
        if (xAux >= 0x100000000) {
            xAux >>= 32;
            result <<= 16;
        }
        if (xAux >= 0x10000) {
            xAux >>= 16;
            result <<= 8;
        }
        if (xAux >= 0x100) {
            xAux >>= 8;
            result <<= 4;
        }
        if (xAux >= 0x10) {
            xAux >>= 4;
            result <<= 2;
        }
        if (xAux >= 0x8) {
            result <<= 1;
        }

        // The operations can never overflow because the result is max 2^127 when it enters this block.
        unchecked {
            result = (result + x / result) >> 1;
            result = (result + x / result) >> 1;
            result = (result + x / result) >> 1;
            result = (result + x / result) >> 1;
            result = (result + x / result) >> 1;
            result = (result + x / result) >> 1;
            result = (result + x / result) >> 1;
            // Seven iterations should be enough
            int256 roundedDownResult = x / result;
            return result >= roundedDownResult ? roundedDownResult : result;
        }
    }

    function ln(int256 x) internal pure checkNegative(x) returns (int256 result) {
        unchecked {
            require(x >= 0);
        }
    }

    function log2(int256 x) internal pure checkNegative(x) returns (int256 result) {
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

    function pow(int256 x, int256 y) internal pure check(x) check(y) returns (int256 result) {
        unchecked {}
    }
}
