// script/index.js

const { ethers } = require("hardhat");

async function main() {
    // Our code will go here
    // Retrieve accounts from the local node
    // ローカルノードからアカウントを取得する
    const accounts = await ethers.provider.listAccounts();
    console.log(accounts);
}

main().then(() => process.exit(0)).catch(error => {
    console.error(error);
    process.exit(1);
});

