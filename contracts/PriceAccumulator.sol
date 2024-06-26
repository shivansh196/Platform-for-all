// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;
//Use of solidity lang
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

library PriceAggregator {

    function getPrice() internal view returns(uint) {
        // ABI
        // Address ***AddressToBePlaced***
        address addr = ***AddressToBePlaced***;

        AggregatorV3Interface priceFeed = AggregatorV3Interface(addr);
        (, int price,,,) = priceFeed.latestRoundData();
        //ETH in terms of USD
        return uint(price * 1e10); // 1**10

    }

    function getVersion() internal view returns(uint) {
        address addr = ***AddressToBePlaced***;
        AggregatorV3Interface priceFeed = AggregatorV3Interface(addr);
        return priceFeed.version();
    }

    function getConversionRate(uint ethAmount) internal view returns(uint) {
        uint ethPrice = getPrice();
        //3000_000000000000000000 = ETH/USD price
        //1_000000000000000000 ETH amount
        uint ethAmountInUsd = (ethPrice * ethAmount) / 1e18;
        return ethAmountInUsd;
    }
}