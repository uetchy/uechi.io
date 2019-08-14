---
title: OSXに音声解析エンジンJuliusを入れる with Homebrew
date: 2013-07-07 09:00:00 +09:00
redirect_from: /blog/2013/07/07/install-julius-with-homebrew
---

Homebrew を使って macOS に音声解析エンジン Julius をインストールします。

# 前提

OS X 用のパッケージ管理ツール Homebrew がインストールされている必要がある。

インストール方法
は[こちら](http://www.engineyard.co.jp/blog/2012/homebrew-os-xs-missing-package-manager/)を
参照。

# インストール

デフォルトの Homebrew リポジトリに Julius は含まれていないので
、[homebrew-nlp](https://github.com/uetchy/homebrew-nlp) を tap する。

```bash
$ brew tap uetchy/nlp
```

Tap し終わったら、`julius`と`julius-dictation-kit`をインストールする。

```bash
$ brew install julius julius-dictation-kit
```

これで Julius と Julius ディクテーションキットがインストールされた。

ディクテーションキットの場所は `brew --prefix julius-dictation-kit` コマンドで調
べられる。

後は、上記の `brew --prefix` コマンドでディクテーションキット内の **main.jconf**
と **am-gmm.jconf** のパスを調べて `julius` に渡すことで音声認識が出来るようにな
る。

```bash
$ julius \
  -C `brew --prefix julius-dictation-kit`/share/main.jconf \
  -C `brew --prefix julius-dictation-kit`/share/am-gmm.jconf
```

上記のコマンドで Julius は GMM モードで待機状態になり、喋った内容をリアルタイム
で音声認識してくれるようになる。

Julius をより精密な DNN モードで起動したい場合は以下のように、**am-gmm.jconf**
を **am-dnn.jconf** に変更するだけだ。

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

![install-julius-with-homebrew](/uploads/install-julius-with-homebrew.png)
