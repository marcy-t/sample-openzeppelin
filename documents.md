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









