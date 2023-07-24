//SPDX-License-Identifier: MIT
pragma solidity =0.8.17;

import "hardhat/console.sol";
import {FixedPoint18} from "./FixedPoint18.sol";

contract UseFixedPoint18 {
    using FixedPoint18 for uint256;

    function add(uint256 x, uint256 y) public view returns (uint256 n) {
        uint256 startGas = gasleft();
        n = x.add(y);
        console.log(startGas - gasleft());
        // 143
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
        // 196
    }

    function inv(uint256 x) public view returns (uint256 n) {
        uint256 startGas = gasleft();
        n = x.inv();
        console.log(startGas - gasleft());
        // 114
    }

    function avg(uint256 x, uint256 y) public view returns (uint256 n) {
        uint256 startGas = gasleft();
        n = x.avg(y);
        console.log(startGas - gasleft());
        // 152
    }

    function wavg(uint256 x1, uint256 y1, uint256 x2, uint256 y2) public view returns (uint256 n) {
        uint256 startGas = gasleft();
        n = x1.wavg(y1, x2, y2);
        console.log(startGas - gasleft());
    }

    function pc(uint256 x, uint256 y) public view returns (uint256 n) {
        uint256 startGas = gasleft();
        n = x.pc(y);
        console.log(startGas - gasleft());
    }

    function sqrt(uint256 x) public view returns (uint256 n) {
        uint256 startGas = gasleft();
        n = x.sqrt();
        console.log(startGas - gasleft());
    }

    function lb(uint256 x) public view returns (uint256 n) {
        uint256 startGas = gasleft();
        n = x.lb();
        console.log(startGas - gasleft());
        // 461
    }

    function ln(uint256 x) public view returns (uint256 n) {
        uint256 startGas = gasleft();
        n = x.ln();
        console.log(startGas - gasleft());
    }
}
