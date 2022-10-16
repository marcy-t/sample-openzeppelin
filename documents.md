# [Developing smart contracts](https://docs.openzeppelin.com/learn/developing-smart-contracts)

## Solidity
- [Setting up a Solidity Project](https://docs.openzeppelin.com/learn/developing-smart-contracts#setting-up-a-solidity-project)
- [Compiling Solidity Source Code](https://docs.openzeppelin.com/learn/developing-smart-contracts#compiling-solidity-source-code)
- [Adding More Contracts](https://docs.openzeppelin.com/learn/developing-smart-contracts#adding-more-contracts)
- [Using OpenZeppelin Contracts](https://docs.openzeppelin.com/learn/developing-smart-contracts#using-openzeppelin-contracts)

# Setting up a Project
- TruffleとHardhatを使ってスマートコントラクトを開発、テスト、デプロイする方法を説明します
``` javascript
npm install --save-dev hardhat
```
- インストールが完了したら`npx hardhatを実行します`
- Hardhatの設定ファイル(hardhat.config.js)がプロジェクトディレクトリに作成されます

``` javascript
makito@makito-tashironoMacBook-Pro sample-openzeppelin % npx hardhat
888    888                      888 888               888
888    888                      888 888               888
888    888                      888 888               888
8888888888  8888b.  888d888 .d88888 88888b.   8888b.  888888
888    888     "88b 888P"  d88" 888 888 "88b     "88b 888
888    888 .d888888 888    888  888 888  888 .d888888 888
888    888 888  888 888    Y88b 888 888  888 888  888 Y88b.
888    888 "Y888888 888     "Y88888 888  888 "Y888888  "Y888

👷 Welcome to Hardhat v2.12.0 👷‍

✔ What do you want to do? · Create a JavaScript project
✔ Hardhat project root: · /Users/makito/B-LAND/sample-openzeppelin
✔ Do you want to add a .gitignore? (Y/n) · y
✔ Do you want to install this sample project's dependencies with npm (hardhat @nomicfoundation/hardhat-toolbox)? (Y/n) · y

npm install --save-dev hardhat@^2.12.0 @nomicfoundation/hardhat-toolbox@^2.0.0
npm WARN deprecated har-validator@5.1.5: this library is no longer supported
npm WARN deprecated request-promise-native@1.0.9: request-promise-native has been deprecated because it extends the now deprecated request package, see https://github.com/request/request/issues/3142
npm WARN deprecated request@2.88.2: request has been deprecated, see https://github.com/request/request/issues/3142
npm WARN deprecated uuid@3.4.0: Please upgrade  to version 7 or higher.  Older versions may use Math.random() in certain circumstances, which is known to be problematic.  See https://v8.dev/blog/math-random for details.
npm WARN deprecated fsevents@2.1.3: "Please update to latest v2.3 or v2.2"
npm WARN deprecated debug@3.2.6: Debug versions >=3.2.0 <3.2.7 || >=4 <4.3.1 have a low-severity ReDos regression when used in a Node.js environment. It is recommended you upgrade to 3.2.7 or 4.3.1. (https://github.com/visionmedia/debug/issues/797)
npm WARN deprecated uuid@2.0.1: Please upgrade  to version 7 or higher.  Older versions may use Math.random() in certain circumstances, which is known to be problematic.  See https://v8.dev/blog/math-random for details.
npm WARN deprecated fsevents@2.1.3: "Please update to latest v2.3 or v2.2"
npm WARN deprecated debug@3.2.6: Debug versions >=3.2.0 <3.2.7 || >=4 <4.3.1 have a low-severity ReDos regression when used in a Node.js environment. It is recommended you upgrade to 3.2.7 or 4.3.1. (https://github.com/visionmedia/debug/issues/797)

added 696 packages, and audited 697 packages in 30s

113 packages are looking for funding
  run `npm fund` for details

found 0 vulnerabilities

✨ Project created ✨

See the README.md file for some example tasks you can run

Give Hardhat a star on Github if you're enjoying it! 💞✨

     https://github.com/NomicFoundation/hardhat
``` 

- Solidity のソースファイル (.sol) を contracts ディレクトリに保存します。
- 最初の簡単なスマート コントラクトを作成します。
  - contracts/Box.solという名前で保存します。
  - 各.solファイルには、1つのコントラクトのコードを記述し、それにちなんだ名前を付ける必要があります。

# Compiling Solidity
- Ethereum Virtual Machine(EVM)はSolidityコードを直接実行することができないため
  EVMバイトコードにコンパイルする必要がある
- Box.solコントラクトはSolidity0.8を使用しているので、最初に適切なsolcバージョンを使用するに  
  Hardhatを設定する必要があります
- Hardhat.config.jsでSolidity 0.8のsolcバージョンを指定します。
``` javascript
// hardhat.config.js

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
 module.exports = {
  solidity: "0.8.4",
};
```

> npxコマンドに慣れていない場合は、Nodeプロジェクトのセットアップガイドを参照してください
``` javascript
$ npx hardhat compile
Solidity 0.8.4 is not fully supported yet. You can still use Hardhat, but some features, like stack traces, might not work correctly.

Learn more at https://hardhat.org/reference/solidity-support"

Compiling 1 file with 0.8.4
Compilation finished successfully

```

# Adding more contracts ~ 契約数の追加
- プロジェクトが大きくなるにつれて、互いに影響し合うコントラクトをさらに作成するようになります
- それぞれのコントラクトは独自の.solファイルに格納されるべき
- Authというコントラクトに管理者アドレスを保存し、Authが許可したアカウントのみがBoxを使用できるようにします
- コンパイラは、contractsディレクトリとそのサブディレクトリにある全てのファイルをピックアップするので、コードを自由に整理することができる
- Authのコントラクトをアクセスコントロールのサブディレクトリに格納することにします
``` javascript
// contracts/access-control/Auth.sol
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Auth {
    address private _administrator;

    constructor(address deployer) {
        // Make the deployer of the contract the administrator
        // 契約のデプロイメントを管理者にする
        _administrator = deployer;  
    }

    function isAdministrator(address user) public view returns (bool) {
        return user == _administrator;
    }
}
```

- Boxからこのコントラクトを使用するために、Authを相対パスで参照するImportステートメントを使用します
``` javascript
// contracts/Box.sol
// SPDX-License-Identifier: MIT

// 8を使用しているので、最初に適切なsolcバージョンを使用するにHardhatを設定する必要があります
pragma solidity ^0.8.0;

// Import Auth from the access-control subdirectory
import "./access-control/Auth.sol";

contract Box {
    uint256 private _value;
    Auth private _auth;

    // Emitted when the stored value changes
    event ValueChanged(uint256 value); // 保存されたされた値が変更されたときに発行される

    constructor() {
        _auth = new Auth(msg.sender);
    }

    // Stores a new value in the contract
    function store(uint256 value) public { // コントラクトに新しい値を追加する
        // Require that the caller is registered as an administrator in Auth
        // 発信者がAuthの管理者として登録されていることを要求する
        require(_auth.isAdministrator(msg.sender), "Unauthorized"); // Unauthorized:未承認

        _value = value;
        emit ValueChanged(value);
    }

    // Reads the last stored value
    function retrieve() public view returns (uint256) {
        return _value;
    }
}
```

- コードをモジュールに分割する方法はカプセル化などあります

# Using OpenZeppelin Contracts
- OpenZeppelinはセキュリティソリューションを提供するスマートコントラクトライブラリ
- 分散型(Dapp)、プロトコル、分散自立組織（DAO）などの実現にはブロックチェーン上でスマートコントラクトの実行が不可欠です
- イーサリアムでのアプリケーション開発が高い人気を誇っています。
- イーサリアムでのスマートコントラクトの実装はSolidityというチューリング完全言語で簡単に開発できるようになっています
- しかし、スマートコントラクト開発には非常に注意しなくてはいけない点があります
  - 書き換えが難しい（難しいというかできない）
  - 一度でデプロイしてしまうと、バグが起きても対処が非常に難しい
- OpenZeppelinはスマートコントラクトの開発においてセキュアなコードパターンの適用、コミュニティによるコード監査を行っています


## About inheritance ~ 継承について
- ライブラリの多くはスタンドアローンではない
- コントラクトに機能を追加して自分自身のコントラクトを構築するための出発点としてそれらを使用することになります
- Solidityはこれを実現するメカニズムとして多重継承を提供します

# Importing OpenZeppelin Contracts
``` bash
$ npm install @openzeppelin/contracts


added 1 package, and audited 698 packages in 2s

113 packages are looking for funding
  run `npm fund` for details

found 0 vulnerabilities
```

- OpenZeppelinのコントラクトを利用するには @openzeppelin/contractsをプレフィックスとしてそのパスをインポートする
  - 例えば、自作のAuthコントラクトを置き換えるために、`@openzeppelin/contracts/access/Ownable.sol` をインポートしてBoxにアクセス制御を追加することにします

# Deploying and interacting with smart contracts ~ スマートコントラクトの導入と対話
- ほとんどのソフトウェアとは異なり、スマートコントラクトはあなたのコンピューターや誰かのサーバー上で動作するわけではないです
- 伝統的なアプリケーションとは少し違う
- 以降はコントラクトを使い始めるために知っておくべきことを網羅します
  - [Setting up a Local Blockchain](https://docs.openzeppelin.com/learn/deploying-and-interacting#local-blockchain)
  - [Deploying a Smart Contract](https://docs.openzeppelin.com/learn/deploying-and-interacting#deploying-a-smart-contract)
  - [Interacting from the Console](https://docs.openzeppelin.com/learn/deploying-and-interacting#interacting-from-the-console)
  - [Interacting Programmatically](https://docs.openzeppelin.com/learn/deploying-and-interacting#interacting-programmatically)

> TruffleとHardhatの両方のインタラクションがある

参考資料
- [Dapps を Truffle + Ganache から Hardhat に移行してみた](https://mixi-developers.mixi.co.jp/todo-dapps-with-hardhat-d23c42c001b1)
  - チュートリアルに向いてる

## Hardhatとは？
- HardhatはEthereumソフトウェアをコンパイル、デプロイ、テスト、デバッグをするための開発環境
- Truffleと異なり、Hardhat自体がEthereum互換のネットワーク（ローカルイーサリアムネットワーク）を構築できるため、HardhatのみでSolidityで作ったスマートコントラクトのコンパイル・テスト・デプロイが可能です
- [Overview](https://hardhat.org/hardhat-runner/docs/getting-started#overview)

# Setting up a Local Blockchain ~ ローカルのブロックチェーンのセットアップ
- 最初に、コントラクトをデプロイできる環境が必要です
- Ethereumブロックチェーン（メインネットワークの意味）を使用するには、Ether（ネイティブ通貨）という形で実際にお金を使う必要があります。
- その際テストネットワークを使って開発を行う
- 以下テストネットワーク
  - Ropsten（非推奨）
  - Rinkeby
  - Kovan
  - Goerli（最近はこれを使っている）
- 開発中はローカルブロックチェーンを使用するのが良い

> Ethereumのテストネットワークのようなパブリックブロックチェーン上のコントラクトをデプロイして使用する方法を学びたい場合は、パブリックテストネットワークへの接続ガイドに進んでください
> [Connecting to public test networks](https://docs.openzeppelin.com/learn/connecting-to-public-test-networks)

- Hardhatには、ローカルブロックチェーンであるHardhot Networkが内蔵されています
- 起動時にHardhat Networkは、アンロックされたアカウントのセットを作成し、Etherを渡します
``` bash
# プロジェクトファイルディレクトリにて以下
$ npx hardhat node
```
- Hardhat Networkは、そのアドレス
- http://127.0.0.1:8545、利用可能なアカウントとその秘密鍵のリストを出力します
- Hardhat Networkを実行するたびに全く新しいローカルブロックチェーンが作成されることに留意してください
- 以前の実行状態は保存されません
- これは、短期間中はHardhat NetWorkを実行しているウィンドウを開いておく必要があります

# Deploying a Smart Contract
- 以前までは開発環境をセットアップしました
- まだセットアップされていない場合はプロジェクトを作成してセットアップし、Boxスマートコントラクトを作成してコンパイルしてください
- Hardhotには現在、ネイティブのデプロイメントシステムがなく、代わりにスクリプトを使用してコントラクトをデプロイしています
- Boxコントラクトをデプロイするためのスクリプトを作成
- script/deploy.js
- 今回のスクリプトではethersを使用するので、ethersと@nomiclabs/hardhat-ethersプラグインをインストール
``` bash
npm install --save-dev @nomiclabs/hardhat-ethers ethers
```

``` javascript
// hardhat.config.js
require('@nomiclabs/hardhat-ethers');

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.17",
};
```


``` javascript
// scripts/deploy.js
const { ethers } = require("hardhat");

// script/deploy.js
async function main () {
  // We get the contract to deploy
  const Box = await ethers.getContractFactory('Box');
  console.log('Deploying Box...');
  const box = await Box.deploy();
  console.log('Box deployed to:', box.address);
}

main()
.then(()=>process.exit(0))
.catch(error => {
  console.error(error);
  process.exit(1);
});
```

- runコマンドを使って、Boxのコントラクトをローカルネットワーク(Hardhat Network)にデプロイすることができます
- プロジェクトディレクトリでnpx hardhat node
- #### 以下起動するとhttp://127.0.0.1:8545/あてに立ち上がる
- #### 起動時に20個のアドレスが払い出されています。このPrivateKeyを使用すればHardhatのローカルチェーンで活動できます
``` bash
$ npx hardhat node
Started HTTP and WebSocket JSON-RPC server at http://127.0.0.1:8545/

Accounts
========

WARNING: These accounts, and their private keys, are publicly known.
Any funds sent to them on Mainnet or any other live network WILL BE LOST.

Account #0: 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266 (10000 ETH)
Private Key: 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80

Account #1: 0x70997970C51812dc3A010C7d01b50e0d17dc79C8 (10000 ETH)
Private Key: 0x59c6995e998f97a5a0044966f0945389dc9e86dae88c7a8412f4603b6b78690d

Account #2: 0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC (10000 ETH)
Private Key: 0x5de4111afa1a4b94908f83103eb1f1706367c2e68ca870fc3fb9a804cdab365a

Account #3: 0x90F79bf6EB2c4f870365E785982E1f101E93b906 (10000 ETH)
Private Key: 0x7c852118294e51e653712a81e05800f419141751be58f605c371e15141b007a6

Account #4: 0x15d34AAf54267DB7D7c367839AAf71A00a2C6A65 (10000 ETH)
Private Key: 0x47e179ec197488593b187f80a00eb0da91f1b9d0b13f8733639f19c30a34926a

Account #5: 0x9965507D1a55bcC2695C58ba16FB37d819B0A4dc (10000 ETH)
Private Key: 0x8b3a350cf5c34c9194ca85829a2df0ec3153be0318b5e2d3348e872092edffba

Account #6: 0x976EA74026E726554dB657fA54763abd0C3a0aa9 (10000 ETH)
Private Key: 0x92db14e403b83dfe3df233f83dfa3a0d7096f21ca9b0d6d6b8d88b2b4ec1564e

Account #7: 0x14dC79964da2C08b23698B3D3cc7Ca32193d9955 (10000 ETH)
Private Key: 0x4bbbf85ce3377467afe5d46f804f221813b2bb87f24d81f60f1fcdbf7cbf4356

Account #8: 0x23618e81E3f5cdF7f54C3d65f7FBc0aBf5B21E8f (10000 ETH)
Private Key: 0xdbda1821b80551c9d65939329250298aa3472ba22feea921c0cf5d620ea67b97

Account #9: 0xa0Ee7A142d267C1f36714E4a8F75612F20a79720 (10000 ETH)
Private Key: 0x2a871d0798f97d79848a013d4936a73bf4cc922c825d33c1cf7073dff6d409c6

Account #10: 0xBcd4042DE499D14e55001CcbB24a551F3b954096 (10000 ETH)
Private Key: 0xf214f2b2cd398c806f84e317254e0f0b801d0643303237d97a22a48e01628897

Account #11: 0x71bE63f3384f5fb98995898A86B02Fb2426c5788 (10000 ETH)
Private Key: 0x701b615bbdfb9de65240bc28bd21bbc0d996645a3dd57e7b12bc2bdf6f192c82

Account #12: 0xFABB0ac9d68B0B445fB7357272Ff202C5651694a (10000 ETH)
Private Key: 0xa267530f49f8280200edf313ee7af6b827f2a8bce2897751d06a843f644967b1

Account #13: 0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec (10000 ETH)
Private Key: 0x47c99abed3324a2707c28affff1267e45918ec8c3f20b8aa892e8b065d2942dd

Account #14: 0xdF3e18d64BC6A983f673Ab319CCaE4f1a57C7097 (10000 ETH)
Private Key: 0xc526ee95bf44d8fc405a158bb884d9d1238d99f0612e9f33d006bb0789009aaa

Account #15: 0xcd3B766CCDd6AE721141F452C550Ca635964ce71 (10000 ETH)
Private Key: 0x8166f546bab6da521a8369cab06c5d2b9e46670292d85c875ee9ec20e84ffb61

Account #16: 0x2546BcD3c84621e976D8185a91A922aE77ECEc30 (10000 ETH)
Private Key: 0xea6c44ac03bff858b476bba40716402b03e41b8e97e276d1baec7c37d42484a0

Account #17: 0xbDA5747bFD65F08deb54cb465eB87D40e51B197E (10000 ETH)
Private Key: 0x689af8efa8c651a91ad287602527f3af2fe9f6501a7ac4b061667b5a93e037fd

Account #18: 0xdD2FD4581271e230360230F9337D5c0430Bf44C0 (10000 ETH)
Private Key: 0xde9be858da4a475276426320d5e9262ecfc3ba460bfac56360bfa6c4c28b4ee0

Account #19: 0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199 (10000 ETH)
Private Key: 0xdf57089febbacf7ba0bc227dafbffa9fc08a93fdc68e1e42411a14efcf23656e

WARNING: These accounts, and their private keys, are publicly known.
Any funds sent to them on Mainnet or any other live network WILL BE LOST.

eth_chainId
eth_accounts
eth_blockNumber
eth_chainId (2)
eth_estimateGas
eth_getBlockByNumber
eth_gasPrice
eth_sendTransaction
  Contract deployment: Box
  Contract address:    0x5fbdb2315678afecb367f032d93f642f64180aa3
  Transaction:         0x5cfbf7d473249c6375dfd4bd3368d557bd7c6679476f5d7888c1391c21536009
  From:                0xf39fd6e51aad88f6f4ce6ab8827279cfffb92266
  Value:               0 ETH
  Gas used:            398269 of 398269
  Block #1:            0xfbd932f46eaca4ca00de93367b1384f53d2a2d3576fb4a36dcf43e5e35a9c8c3

eth_chainId
eth_getTransactionByHash
```

- 違う画面を開きデプロイ
- `--network` オプションを指定することで、設定ファイルに書かれた任意のネットワークに切り替えて実行が可能
``` bash
$ npx hardhat run --network localhost scripts/deploy.js
Deploying Box...
Box deployed to: 0x5FbDB2315678afecb367f032d93F642f64180aa3
```

- Hardhatはデプロイされたコントラクトを追跡しません
- 例）Deploying Box...
Box deployed to: 0x5FbDB2315678afecb367f032d93F642f64180aa3

- 上記のデプロイで完了
- 接続エラーが発生した場合は、他の端末でブロックチェーンを実行していることを確認してください

> ローカルブロックチェーンは、複数の実行を通じて状態を持続させないことを忘れないように
> ローカルブロックチェーンのプロセスを閉じるとコントラクトを再展開する必要があります

# Interacting from the Console ~ コンソールから操作する
- Boxコントラクトがデプロイされたらすぐ使い始めることができます
- Hardhatコンソールを使って、ローカルホストネットワーク上にデプロイされたBoxコントラクトと対話します

> デプロイスプリクトで表示したBox契約のアドレスを指定する必要がある
> Hardhatがコンソールセッションに接続するためのネットワークを明示的に設定することが重要
> そうしないとHardhatはデフォルトで新しいエフェメラルワークを使用するようになり、Boxコントラクトがデプロイされないからです

``` javascript
$ npx hardhat console --network localhost
Welcome to Node.js v16.14.2.
Type ".help" for more information.

> const Box = await ethers.getContractFactory('Box'); 
undefined
> const box = await Box.attach('0x5FbDB2315678afecb367f032d93F642f64180aa3')
undefined
```

# Sending transactions
- Boxの最初の関数storeは、整数値を受け取り、コントラクトストレージに格納する
- この関数はブロックチェーンの状態を変更するため、それを実行するためにコントラクトにトランザクションを送信する必要があります
- 数値を指定して、store関数を呼び出すトランザクションを送信します

``` javascript
$  npx hardhat console --network localhost
Welcome to Node.js v16.14.2.

> await box.store(42) // 整数値を受け取り、コントラクトストレージに格納する
{
  hash: '0xef896a9c6b846b8ffc0cc57d2b39fe8a9ee153d7e5f3dfc3955f8c0d4412bbdc',
  type: 0,
  accessList: null,
  blockHash: '0xa016ee836c3d1a0554a08bf9c8ca20ec70a039fc2372bf300608af1db80ac188',
  blockNumber: 2,
  transactionIndex: 0,
  confirmations: 1,
  from: '0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266',
  gasPrice: BigNumber { value: "1768529045" },
  gasLimit: BigNumber { value: "47179" },
  to: '0x5FbDB2315678afecb367f032d93F642f64180aa3',
  value: BigNumber { value: "0" },
  nonce: 1,
  data: '0x6057361d000000000000000000000000000000000000000000000000000000000000002a',
  r: '0xc7a2ea7b90f4f569cc6e233c47714cca5c4238c33bbacb6092e485cc48d252f0',
  s: '0x1ce56f1e3a31042e823867120355e5771d734939e3d0aa9a964e7a4ee5015c8d',
  v: 62709,
  creates: null,
  chainId: 31337,
  wait: [Function (anonymous)]
}
>

```

# Querying state ~ 状態問い合わせ
- Boxのも一つの関数は「retrieve」と呼ばれコントラクトに格納された整数値を返す
- これはブロックチェーンの状態の問い合わせなのでトランザクションを送信する必要はない
``` javascript
> await box.retrieve()
BigNumber { value: "42" }
```
- クエリは状態を読み取るだけでトランザクションを送信しないため、報告すべきトランザクションハッシュは存在しない
- これはクエリを使うのに、「Ether」がかからないことを意味し、どのネットワーク上でも無料で使うことができる

> Boxのコントラクトはuint256を返すが、Javascriptでは大きすぎるため
> 代わりに大きな数字オブジェクトを返してもらう
> この大きな数字を文字列として表示するには以下

``` jacascript
> (await box.retrieve()).toString()
'42'
```

- #### [コンソールの使い方を知りたい方はHardhatのドキュメントをご覧ください](https://hardhat.org/hardhat-runner/docs/guides/hardhat-console)

