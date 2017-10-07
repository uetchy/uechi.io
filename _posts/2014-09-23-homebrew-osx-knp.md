---
title: HomebrewでmacOSに構文解析システムKNPを入れる
date: 2014-09-23 09:00:00 +09:00
---

HomebrewでmacOSに構文解析システムKNPをインストールします。

# 前提

OS X用のパッケージ管理ツール Homebrew がインストールされている必要がある。

インストール方法は[こちら](http://www.engineyard.co.jp/blog/2012/homebrew-os-xs-missing-package-manager/)

# インストール

デフォルトのHomebrewリポジトリにKNPは含まれていないので [homebrew-nlp](https://github.com/uetchy/homebrew-nlp) をtapする。


```bash
brew tap uetchy/nlp
```

Tapし終わったら、`knp`をインストールする。knpが依存している形態素解析システム`juman`とデータベース`tinycdb`はHomebrewによって自動でインストールされる。その内の`juman`は上記の __oame/nlp__ Tapによって提供されている。

```bash
brew install knp
```

固有表現解析を行いたい場合は __--with-crf++__ オプションを付けてインストールする。このオプションを付けると、依存解決のために`crf++`も同時にインストールされる。

```bash
brew install knp --with-crf++
```

KNPのインストールにはありえないくらい時間が掛かる。

# チェック

インストールが終わったら動作チェックをする。

```bash
$ juman < test.txt | knp
# S-ID:1 KNP:4.11-CF1.1 DATE:2014/09/23 SCORE:-19.04210
今日は──┐
  良い──┤
    天気です。
EOS
```
