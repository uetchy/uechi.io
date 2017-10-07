---
title: OSXに音声解析エンジンJuliusを入れる with Homebrew
date: 2013-07-07 09:00:00 +09:00
---

Homebrewを使ってmacOSに音声解析エンジンJuliusをインストールします。

# 前提

OS X用のパッケージ管理ツール Homebrew がインストールされている必要がある。

インストール方法は[こちら](http://www.engineyard.co.jp/blog/2012/homebrew-os-xs-missing-package-manager/)を参照。

# インストール

デフォルトのHomebrewリポジトリにJuliusは含まれていないので、[homebrew-nlp](https://github.com/uetchy/homebrew-nlp) をtapする。



```bash
$ brew tap uetchy/nlp
```

Tapし終わったら、`julius`と`julius-dictation-kit`をインストールする。

```bash
$ brew install julius julius-dictation-kit
```

これで Julius と Juliusディクテーションキットがインストールされた。

ディクテーションキットの場所は `brew --prefix julius-dictation-kit` コマンドで調べられる。

後は、上記の `brew --prefix` コマンドでディクテーションキット内の **main.jconf** と **am-gmm.jconf** のパスを調べて `julius` に渡すことで音声認識が出来るようになる。

```bash
$ julius \
  -C `brew --prefix julius-dictation-kit`/share/main.jconf \
  -C `brew --prefix julius-dictation-kit`/share/am-gmm.jconf
```

上記のコマンドでJuliusはGMMモードで待機状態になり、喋った内容をリアルタイムで音声認識してくれるようになる。

Juliusをより精密なDNNモードで起動したい場合は以下のように、**am-gmm.jconf** を **am-dnn.jconf** に変更するだけだ。

```bash
$ julius \
  -C `brew --prefix julius-dictation-kit`/share/main.jconf \
  -C `brew --prefix julius-dictation-kit`/share/am-dnn.jconf
```

ディクテーションキットに関するドキュメントは下記のコマンドから参照可能だ。

```bash
$ open `brew --prefix julius-dictation-kit`/share/doc
```

### 実行中の様子

![s1.png](https://qiita-image-store.s3.amazonaws.com/0/19622/b3a55a4b-f3cb-5772-541b-00606c286a4d.png "s1.png")
