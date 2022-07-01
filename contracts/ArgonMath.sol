//SPDX-License-Identifier: MIT
pragma solidity =0.8.8;

library ArgonMath {
    uint256 private constant OVERFLOW = 2**128;
    uint256 private constant SCALE = 1e18;
    uint256 private constant SCALE_SQUARE = 1e36;
    uint256 private constant SCALE_ROOT = 1e36;
    uint256 private constant SCALED_HUNDRED = 1e20;
    uint256 private constant SCALED_HALF = 5 * 1e17;
    uint256 private constant SCALED_PI = 3_141592_653589_793238;
    uint256 private constant SCALED_E = 2_718281_828459_045235;
    uint256 private constant SCALED_LB_E = 1_442695_040888_963407;

    error Argon__Overflow(uint256 x);
    error Argon__SubtractionIsNegative(uint256 x, uint256 y);
    error Argon__DivideByZero(uint256 x, uint256 y);
    error Argon__LargeExponentInput(uint256 x);
    error Argon__LargeBinExponentInput(uint256 x);
    error Argon__LogIsNegative(uint256 x);

    /// @notice Modifier to check for overflow
    /// @dev Maximum Value = (2^128-1)/(10^18) =
    /// @dev 340,282,366,920,938,463,463.374607431768211455
    /// @param x Input in mathematical operation
    modifier check(uint256 x) {
        if (x >= OVERFLOW) {
            revert Argon__Overflow(x);
        }
        _;
    }

    /// @notice Explain to an end user what this does
    /// @dev Explain to a developer any extra details
    /// @param x a parameter just like in doxygen (must be followed by parameter name)
    /// @param y a parameter just like in doxygen (must be followed by parameter name)
    /// @return n the return variables of a contract’s function state variable
    function add(uint256 x, uint256 y) internal pure check(x) check(y) returns (uint256 n) {
        unchecked {
            n = x + y;
        }
    }

    /// @notice Explain to an end user what this does
    /// @dev Explain to a developer any extra details
    /// @param x a parameter just like in doxygen (must be followed by parameter name)
    /// @param y a parameter just like in doxygen (must be followed by parameter name)
    /// @return n the return variables of a contract’s function state variable
    function sub(uint256 x, uint256 y) internal pure check(x) check(y) returns (uint256 n) {
        if (x < y) {
            revert Argon__SubtractionIsNegative(x, y);
        }
        unchecked {
            n = x - y;
        }
    }

    /// @notice Explain to an end user what this does
    /// @dev Explain to a developer any extra details
    /// @param x a parameter just like in doxygen (must be followed by parameter name)
    /// @param y a parameter just like in doxygen (must be followed by parameter name)
    /// @return n the return variables of a contract’s function state variable
    function mul(uint256 x, uint256 y) internal pure check(x) check(y) returns (uint256 n) {
        unchecked {
            n = (x * y) / SCALE;
        }
    }

    /// @notice Explain to an end user what this does
    /// @dev Explain to a developer any extra details
    /// @param x a parameter just like in doxygen (must be followed by parameter name)
    /// @param y a parameter just like in doxygen (must be followed by parameter name)
    /// @return n the return variables of a contract’s function state variable
    function div(uint256 x, uint256 y) internal pure check(x) check(y) returns (uint256 n) {
        if (y == 0) {
            revert Argon__DivideByZero(x, y);
        }
        unchecked {
            n = (x * SCALE) / y;
        }
    }

    /// @notice Explain to an end user what this does
    /// @dev Explain to a developer any extra details
    /// @param x a parameter just like in doxygen (must be followed by parameter name)
    /// @return n the return variables of a contract’s function state variable
    function inv(uint256 x) internal pure check(x) returns (uint256 n) {
        unchecked {
            n = SCALE_SQUARE / x;
        }
    }

    /// @notice Explain to an end user what this does
    /// @dev Explain to a developer any extra details
    /// @param x a parameter just like in doxygen (must be followed by parameter name)
    /// @param y a parameter just like in doxygen (must be followed by parameter name)
    /// @return n the return variables of a contract’s function state variable
    function avg(uint256 x, uint256 y) internal pure check(x) check(y) returns (uint256 n) {
        unchecked {
            n = (x + y) >> 1;
        }
    }

    /// @notice Explain to an end user what this does
    /// @dev Explain to a developer any extra details
    /// @param x1 a parameter just like in doxygen (must be followed by parameter name)
    /// @param y1 a parameter just like in doxygen (must be followed by parameter name)
    /// @param x2 a parameter just like in doxygen (must be followed by parameter name)
    /// @param y2 a parameter just like in doxygen (must be followed by parameter name)
    /// @return n the return variables of a contract’s function state variable
    function wavg(
        uint256 x1,
        uint256 y1,
        uint256 x2,
        uint256 y2
    ) internal pure check(x1) check(y1) check(x2) check(y2) returns (uint256 n) {
        unchecked {
            n = (x1 * y1) / (y1 + y2) + (x2 * y2) / (y1 + y2);
            n /= SCALE;
        }
    }

    /// @notice Explain to an end user what this does
    /// @dev Explain to a developer any extra details
    /// @param x a parameter just like in doxygen (must be followed by parameter name)
    /// @param y a parameter just like in doxygen (must be followed by parameter name)
    /// @return n the return variables of a contract’s function state variable
    function percent(uint256 x, uint256 y) internal pure check(x) check(n) returns (uint256 n) {
        unchecked {
            n = (x * y) / SCALED_HUNDRED;
        }
    }

    /// @notice Explain to an end user what this does
    /// @dev Explain to a developer any extra details
    /// @return n the return variables of a contract’s function state variable
    function pi() internal pure returns (uint256 n) {
        n = SCALED_PI;
    }

    /// @notice Explain to an end user what this does
    /// @dev Explain to a developer any extra details
    /// @return n the return variables of a contract’s function state variable
    function e() internal pure returns (uint256 n) {
        n = SCALED_E;
    }

    /// @notice Explain to an end user what this does
    /// @dev Explain to a developer any extra details
    /// @param x a parameter just like in doxygen (must be followed by parameter name)
    /// @return n the return variables of a contract’s function state variable
    function sqrt(uint256 x) public pure check(x) returns (uint256 n) {
        unchecked {
            n = _sqrtinit(x);
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
    function lb(uint256 x) internal pure check(x) returns (uint256 n) {
        if (x < SCALE) {
            revert Argon__LogIsNegative(x);
        }
        unchecked {
            uint256 m = _lbfloor(x / SCALE);
            n = m * SCALE;
            uint256 y = x >> m;
            if (y == SCALE) {
                return n;
            }
            for (uint256 delta = SCALED_HALF; delta > 0; delta >>= 1) {
                y = (y * y) / SCALE;
                if (y >= 2 * SCALE) {
                    n += delta;
                    y >>= 1;
                }
            }
        }
    }

    /// @notice Explain to an end user what this does
    /// @dev Explain to a developer any extra details
    /// @param x a parameter just like in doxygen (must be followed by parameter name)
    /// @return n the return variables of a contract’s function state variable
    function ln(uint256 x) internal pure check(x) returns (uint256 n) {
        if (x < SCALE) {
            revert Argon__LogIsNegative(x);
        }
        unchecked {
            n = (lb(x) * SCALE) / SCALED_LB_E;
        }
    }

    /// @notice Explain to an end user what this does
    /// @dev Explain to a developer any extra details
    /// @param x a parameter just like in doxygen (must be followed by parameter name)
    /// @return n the return variables of a contract’s function state variable
    function ex(uint256 x) internal pure returns (uint256 n) {}

    /// @notice Explain to an end user what this does
    /// @dev Explain to a developer any extra details
    /// @param x a parameter just like in doxygen (must be followed by parameter name)
    /// @return n the return variables of a contract’s function state variable
    function bx(uint256 x) internal pure returns (uint256 n) {}

    /// @notice Explain to an end user what this does
    /// @dev Explain to a developer any extra details
    /// @param x a parameter just like in doxygen (must be followed by parameter name)
    /// @return n the return variables of a contract’s function state variable
    function _lbfloor(uint256 x) private pure returns (uint256 n) {
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

    /// @notice Explain to an end user what this does
    /// @dev Explain to a developer any extra details
    /// @param x a parameter just like in doxygen (must be followed by parameter name)
    /// @return n the return variables of a contract’s function state variable
    function _sqrtinit(uint256 x) private pure returns (uint256 n) {
        unchecked {
            n = 2**(_lbfloor(x) / 2);
        }
    }
}
