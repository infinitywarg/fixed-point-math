//SPDX-License-Identifier: MIT
pragma solidity =0.8.17;

library FixedPoint6 {
    uint128 private constant MAX_NUMBER = 2 ** 64;
    uint128 private constant SCALE = 1e6;
    uint128 private constant SCALE_SQUARE = 1e12;
    uint128 private constant SCALE_ROOT = 1e3;
    uint128 private constant SCALED_HUNDRED = 1e8;
    uint128 private constant SCALED_HALF = 5 * 1e5;
    uint128 private constant SCALED_PI = 3_141_593;
    uint128 private constant SCALED_E = 2_718_282;
    uint128 private constant SCALED_LB_E = 1_442_695;
    uint128 private constant TWO = 2;

    error FixedPoint6__Overflow(uint128 x);
    error FixedPoint6__SubtractionIsNegative(uint128 x, uint128 y);
    error FixedPoint6__DivideByZero(uint128 x, uint128 y);
    error FixedPoint6__LargeExponentInput(uint128 x);
    error FixedPoint6__LargeBinExponentInput(uint128 x);
    error FixedPoint6__LogIsNegative(uint128 x);

    /// @notice Modifier to check for overflow
    /// @dev Maximum Value = (2^64-1)/(10^6) =
    /// @dev 18_446_744_073_709.551_615
    /// @param x Input in mathematical operation
    modifier check(uint128 x) {
        if (x >= MAX_NUMBER) {
            revert FixedPoint6__Overflow(x);
        }
        _;
    }

    /// @notice Adds two 6-decimal fixed point numbers
    /// @dev Addition never overflows as 2*(2^64-1) < 2^128-1
    /// @param x First operand
    /// @param y Second operand
    /// @return n Addition result
    function add(uint128 x, uint128 y) internal pure check(x) check(y) returns (uint128 n) {
        assembly {
            n := add(x, y)
        }
    }

    /// @notice Subtracts two 6-decimal fixed point numbers
    /// @dev Subtraction never underflows as x < y check is made
    /// @param x First operand
    /// @param y Second operand
    /// @return n Subtraction result
    function sub(uint128 x, uint128 y) internal pure check(x) check(y) returns (uint128 n) {
        if (x < y) {
            revert FixedPoint6__SubtractionIsNegative(x, y);
        }
        assembly {
            n := sub(x, y)
        }
    }

    /// @notice Multiplies two 6-decimal fixed point numbers
    /// @dev Multiplication never overflows as (2^128-1)^2 < 2^256-1
    /// @param x First operand
    /// @param y Second operand
    /// @return n Multiplication result
    function mul(uint128 x, uint128 y) internal pure check(x) check(y) returns (uint128 n) {
        assembly {
            n := div(mul(x, y), SCALE)
        }
    }

    /// @notice Divides two 6-decimal fixed point numbers
    /// @dev Division never overflows as (2^128-1)*(10^18) < 2^256-1
    /// @param x First operand
    /// @param y Second operand
    /// @return n Division result
    function div(uint128 x, uint128 y) internal pure check(x) check(y) returns (uint128 n) {
        if (y == 0) {
            revert FixedPoint6__DivideByZero(x, y);
        }
        assembly {
            n := div(mul(x, SCALE), y)
        }
    }

    /// @notice Calculates multiplicative inverse of x
    /// @dev Explain to a developer any extra details
    /// @param x a parameter just like in doxygen (must be followed by parameter name)
    /// @return n the return variables of a contract’s function state variable
    function inv(uint128 x) internal pure check(x) returns (uint128 n) {
        assembly {
            n := div(SCALE_SQUARE, x)
        }
    }

    /// @notice Explain to an end user what this does
    /// @dev Explain to a developer any extra details
    /// @param x a parameter just like in doxygen (must be followed by parameter name)
    /// @param y a parameter just like in doxygen (must be followed by parameter name)
    /// @return n the return variables of a contract’s function state variable
    function avg(uint128 x, uint128 y) internal pure check(x) check(y) returns (uint128 n) {
        assembly {
            n := shr(1, add(x, y))
        }
    }

    /// @notice Explain to an end user what this does
    /// @dev Explain to a developer any extra details
    /// @param x a parameter just like in doxygen (must be followed by parameter name)
    /// @param y a parameter just like in doxygen (must be followed by parameter name)
    /// @return n the return variables of a contract’s function state variable
    function pc(uint128 x, uint128 y) internal pure check(x) check(n) returns (uint128 n) {
        assembly {
            n := div(mul(x, y), SCALED_HUNDRED)
        }
    }

    /// @notice Explain to an end user what this does
    /// @dev Explain to a developer any extra details
    /// @return n the return variables of a contract’s function state variable
    function pi() internal pure returns (uint128 n) {
        n = SCALED_PI;
    }

    /// @notice Explain to an end user what this does
    /// @dev Explain to a developer any extra details
    /// @return n the return variables of a contract’s function state variable
    function e() internal pure returns (uint128 n) {
        n = SCALED_E;
    }

    /// @notice Explain to an end user what this does
    /// @dev Explain to a developer any extra details
    /// @param x a parameter just like in doxygen (must be followed by parameter name)
    /// @return n the return variables of a contract’s function state variable
    function sqrt(uint128 x) public pure check(x) returns (uint128 n) {
        unchecked {
            n = TWO ** (_lbfloor(x) / TWO);
            n = (n + x / n) >> 1;
            n = (n + x / n) >> 1;
            n = (n + x / n) >> 1;
            n = (n + x / n) >> 1;
            n = (n + x / n) >> 1;
            n = (n + x / n) >> 1;
            n = (n >= (x / n)) ? (x / n) : n;
            n *= SCALE_ROOT;
        }
    }

    /// @notice Explain to an end user what this does
    /// @dev Explain to a developer any extra details
    /// @param x a parameter just like in doxygen (must be followed by parameter name)
    /// @return n the return variables of a contract’s function state variable
    function lb(uint128 x) internal pure check(x) returns (uint128 n) {
        if (x < SCALE) {
            revert FixedPoint6__LogIsNegative(x);
        }
        unchecked {
            uint128 m = _lbfloor(x / SCALE);
            n = m * SCALE;
            uint128 y = x >> m;
            if (y == SCALE) {
                return n;
            }
            for (uint128 z = SCALED_HALF; z > 0; z >>= 1) {
                y = (y * y) / SCALE;
                if (y >= 2 * SCALE) {
                    n += z;
                    y >>= 1;
                }
            }
        }
    }

    /// @notice Explain to an end user what this does
    /// @dev Explain to a developer any extra details
    /// @param x a parameter just like in doxygen (must be followed by parameter name)
    /// @return n the return variables of a contract’s function state variable
    function ln(uint128 x) internal pure check(x) returns (uint128 n) {
        if (x < SCALE) {
            revert FixedPoint6__LogIsNegative(x);
        }
        unchecked {
            n = (lb(x) * SCALE) / SCALED_LB_E;
        }
    }

    /// @notice Explain to an end user what this does
    /// @dev Explain to a developer any extra details
    /// @param x a parameter just like in doxygen (must be followed by parameter name)
    /// @return n the return variables of a contract’s function state variable
    function exp(uint128 x) internal pure returns (uint128 n) {}

    /// @notice Explain to an end user what this does
    /// @dev Explain to a developer any extra details
    /// @param x a parameter just like in doxygen (must be followed by parameter name)
    /// @return n the return variables of a contract’s function state variable
    function bxp(uint128 x) internal pure returns (uint128 n) {}

    /// @notice Calculates integer part of binary logarithm of x
    /// @dev useful in binary log and initial guess for Newton's square root algorithm
    /// @param x a parameter just like in doxygen (must be followed by parameter name)
    /// @return n returns result such that 2^result <= x < 2^(result+1)
    function _lbfloor(uint128 x) private pure returns (uint128 n) {
        unchecked {
            if (x >= 0x10000000000000000) {
                x >>= 64;
                n += 64;
            }
            if (x >= 0x100000000) {
                x >>= 32;
                n += 32;
            }
            if (x >= 0x10000) {
                x >>= 16;
                n += 16;
            }
            if (x >= 0x100) {
                x >>= 8;
                n += 8;
            }
            if (x >= 0x10) {
                x >>= 4;
                n += 4;
            }
            if (x >= 0x4) {
                x >>= 2;
                n += 2;
            }
            if (x >= 0x2) {
                n += 1;
            }
        }
    }
}
