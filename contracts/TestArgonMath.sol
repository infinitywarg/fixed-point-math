//SPDX-License-Identifier: MIT
pragma solidity =0.8.8;

import "hardhat/console.sol";
import "./ArgonMath.sol";

contract TestArgonMath {
    using ArgonMath for uint256;

    function add(uint256 x, uint256 y) public view returns (uint256 n) {
        uint256 startGas = gasleft();
        n = x.add(y);
        console.log(startGas - gasleft());
    }

    function sub(uint256 x, uint256 y) public view returns (uint256 n) {
        uint256 startGas = gasleft();
        n = x.sub(y);
        console.log(startGas - gasleft());
    }

    function mul(uint256 x, uint256 y) public view returns (uint256 n) {
        uint256 startGas = gasleft();
        n = x.mul(y);
        console.log(startGas - gasleft());
    }

    function div(uint256 x, uint256 y) public view returns (uint256 n) {
        uint256 startGas = gasleft();
        n = x.div(y);
        console.log(startGas - gasleft());
    }
}
