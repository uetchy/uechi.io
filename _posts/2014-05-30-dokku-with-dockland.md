---
title: Run dokku with Dockland
date: 2014-05-30 00:00:00 Z
---

ローカルからheroku-toolbeltライクにdokkuコマンドを叩くdockland gemをリリースした。

Github: [uetchy/dockland](https://github.com/uetchy/dockland)

## インストール方法

```bash
gem install dockland
```

## 使い方

### 普通のやり方

まずは普通にdokkuコマンドを叩く。

`ssh -t dokku@example.com <command> <app-name> <options>`でリモートのdokkuコマンドを直接叩ける。

```bash
$ ssh -t dokku@example.com config:set sushi-app KEY1=VALUE
-----> Setting config vars and restarting sushi-app
KEY1: VALUE
-----> Releasing sushi-app ...
-----> Release complete!
-----> Deploying sushi-app ...
-----> Deploy complete!
```

しかしこれではホスト名やアプリ名を毎回打ち込む羽目になって大変だ。

### docklandのやり方

docklandで同じことをやる。

```bash
$ cd sushi-app # ローカルのプロジェクトリポジトリに移動

$ git config remote.dokku.url # プッシュ先を確認しておく
dokku@example.com:sushi-app

$ dockland config:set KEY1=VALUE # 叩く時はコマンドとオプションだけ
-----> Setting config vars and restarting sushi-app
KEY1: VALUE
-----> Releasing sushi-app ...
-----> Release complete!
-----> Deploying sushi-app ...
-----> Deploy complete!

$ dockland config
=== sushi-app config vars ===
KEY1: VALUE
```

このように dockland が `git config` をパースして必要な情報を自動で収集してくれるので、コマンドがシンプルになる。

ついでに、

```bash:.zshrc
alias dokku='dockland'
```

という具合にaliasを張っておけば、まるでリモートで`dokku`を実行している感覚でローカルから`dokku`コマンドを触ることが出来る。

```bash
$ cd rails-app
$ dokku logs
[2014-05-29 15:38:56] INFO  WEBrick 1.3.1
[2014-05-29 15:38:56] INFO  ruby 2.1.2 (2014-05-08) [x86_64-linux]
[2014-05-29 15:38:56] INFO  WEBrick::HTTPServer#start: pid=10 port=5000
〜〜〜
```

## 結論
### 良い所

- リモートのdokkuコマンドを叩きたい時はプロジェクトのGitリポジトリに入ってdocklandコマンドを叩くだけで良い

### 悪いところ

- 実装が綺麗じゃないすぎる
