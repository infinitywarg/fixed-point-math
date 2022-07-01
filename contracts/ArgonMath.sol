//SPDX-License-Identifier: MIT
pragma solidity =0.8.8;

/// @title Simple Solidity library for 18-decimal fixed point math
/// @author @infinitywarg for @infinitywarp Labs
/// @notice Fixed point math operations with 18-decimals for DeFi applications
/// @dev By restricting the inputs to 10^18 with 18-decimals i.e. 10^36, overflow never occcurs for 256-bit integers
/// @dev 10^36 * 10^36 = 10*72 always less than 2^255-1
/// @dev For most applications, 10^18 i.e. 1 million trillion whole units is a large enough amount

contract ArgonMath {
    uint256 private constant MAX_INPUT = 1e36 - 1;
    uint256 private constant SCALE = 1e18;
    uint256 private constant SCALE_SQUARE = 1e36;
    uint256 private constant SCALE_ROOT = 1e9;
    uint256 private constant SCALE_HALF = 5 * 1e17;
    uint256 private constant SCALE_HUNDRED = 1e20;
    uint256 private constant PI = 3_141592_653589_793238;
    uint256 private constant E = 2_718281_828459_045235;
    uint256 private constant LOG2E = 1_442695_040888_963407;

    error Argon__Overflow(uint256 x);
    error Argon__DivideByZero(uint256 x, uint256 y);
    error Argon__Exp2InputLarge(uint256 x);
    error Argon__ExpInputLarge(uint256 x);
    error Argon__LogInputTooSmall(uint256 x);

    /// @notice Modifier to check for overflow and underflow
    /// @dev Maximum Decimal Value = 999999999999999999.999999999999999999
    /// @param x Input in mathematical operation

    modifier check(uint256 x) {
        if (x > MAX_INPUT) {
            revert Argon__Overflow(x);
        }
        _;
    }

    function add(uint256 x, uint256 y) internal pure check(x) check(y) returns (uint256 result) {
        unchecked {
            result = x + y;
        }
    }

    function sub(uint256 x, uint256 y) internal pure check(x) check(y) returns (uint256 result) {
        unchecked {
            result = x - y;
        }
    }

    function mul(uint256 x, uint256 y) internal pure check(x) check(y) returns (uint256 result) {
        unchecked {
            result = (x * y) / SCALE;
        }
    }

    function div(uint256 x, uint256 y) internal pure check(x) check(y) returns (uint256 result) {
        if (y == 0) {
            revert Argon__DivideByZero(x, y);
        }
        unchecked {
            result = (x * SCALE) / y;
        }
    }

    function inv(uint256 x) internal pure returns (uint256 result) {
        unchecked {
            result = SCALE_SQUARE / x;
        }
    }

    function percent(uint256 x, uint256 p) internal pure check(x) check(p) returns (uint256 result) {
        unchecked {
            result = (x * p) / SCALE_HUNDRED;
        }
    }

    function wavg(
        uint256 x1,
        uint256 n1,
        uint256 x2,
        uint256 n2
    ) internal pure returns (uint256 result) {
        unchecked {
            result = ((x1 * n1) + (x2 * n2)) / (n1 + n2);
        }
    }

    function pi() internal pure returns (uint256 result) {
        return PI;
    }

    function e() internal pure returns (uint256 result) {
        return E;
    }

    function sqrt(uint256 x) internal pure returns (uint256 result) {
        if (x == 0) {
            return 0;
        }
        result = sqrtInt(x) * SCALE_ROOT;
    }

    function log2(uint256 x) internal pure returns (uint256 result) {
        if (x < SCALE) {
            revert Argon__LogInputTooSmall(x);
        }
        unchecked {
            uint256 n = _msb(x / SCALE);
            result = n * SCALE;
            uint256 y = x >> n;
            if (y == SCALE) {
                return result;
            }
            for (uint256 delta = SCALE_HALF; delta > 0; delta >>= 1) {
                y = (y * y) / SCALE;
                if (y >= 2 * SCALE) {
                    result += delta;
                    y >>= 1;
                }
            }
        }
    }

    function ln(uint256 x) internal pure returns (uint256 result) {
        unchecked {
            result = (log2(x) * SCALE) / LOG2E;
        }
    }

    function exp(uint256 x) internal pure check(x) returns (uint256 result) {
        // e^82.893063347785644620 = 10^36
        if (x >= 82_893063_347785_644620) {
            revert Argon__ExpInputLarge(x);
        }
        unchecked {}
    }

    function exp2(uint256 x) internal pure check(x) returns (uint256 result) {
        // 2^119.589411415945044523 = 10^36
        if (x >= 119_589411_415945_044523) {
            revert Argon__Exp2InputLarge(x);
        }
        unchecked {}
    }

    function pow(uint256 x, uint256 y) internal pure check(x) check(y) returns (uint256 result) {}

    function sqrtInt(uint256 x) public pure returns (uint256 y) {
        unchecked {
            // find y such that y=2^m, such that 2^m <= sqrt(n) < 2^(m+1)
            uint256 xReducer = x;
            y = 1;
            for (uint8 i = 128; i >= 2; i /= 2) {
                if (xReducer >= 2**i) {
                    xReducer >>= i;
                    y <<= (i / 2);
                }
            }
            // Newton's algorithm to find interget part of sqaure root of x
            // repeat y=(y+x/y)/2 until y>=x
            for (uint8 j = 0; j < 7; j++) {
                y = (y + x / y) >> 1;
            }
            return y >= (x / y) ? (x / y) : y;
        }
    }

    function _msb(uint256 x) internal pure returns (uint256 msb) {
        if (x >= 2**128) {
            x >>= 128;
            msb += 128;
        }
        if (x >= 2**64) {
            x >>= 64;
            msb += 64;
        }
        if (x >= 2**32) {
            x >>= 32;
            msb += 32;
        }
        if (x >= 2**16) {
            x >>= 16;
            msb += 16;
        }
        if (x >= 2**8) {
            x >>= 8;
            msb += 8;
        }
        if (x >= 2**4) {
            x >>= 4;
            msb += 4;
        }
        if (x >= 2**2) {
            x >>= 2;
            msb += 2;
        }
        if (x >= 2**1) {
            msb += 1;
        }
    }
}
