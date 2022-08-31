const CoinGecko = require('coingecko-api');
const { web3 } = require('hardhat');

const hre = require("hardhat");

const POLL_INTERVAL = 5000;
const CoinGeckoClient = new CoinGecko();

const done = async () => {
    const [admin, reporter, _] = await hre.ethers.getSigners();
    const ORACLE = await hre.ethers.getContractFactory('Oracle');
    const CONSUMER = await hre.ethers.getContractFactory('Consumer');

    const oracle = await ORACLE.deploy(admin.address);

    const update = await oracle.connect(admin).updateReporter(reporter.address,true);

    await update.wait();

    const consumer = await CONSUMER.deploy(oracle.address);

    while(true){

        const response = await CoinGeckoClient.coins.fetch('bitcoin', {});
        let currentPrice = parseFloat(response.data.market_data.current_price.usd);
        currentPrice = parseInt(currentPrice * 100);

        const updateData = await oracle.connect(reporter).updateData(
            web3.utils.soliditySha3('BTC/USD'),
            currentPrice
        );

        await updateData.wait();

        console.log(`new price for BTC/USD ${currentPrice} updated on-chain`);

        await new Promise(resolve => setTimeout(resolve, POLL_INTERVAL));

    }
}

done();