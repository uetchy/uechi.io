---
title: homebrew-caskを単純なダウンローダーとして使う
date: 2014-10-27 09:00:00 +09:00
redirect_from: "/blog/2014/10/27/brew-cask-downloader"
---

![image](/uploads/brew-cask-downloader.png)

homebrew-cask を単純なダウンローダーとして使う。

# 理由

1.  **pkg 形式** で配布されているアプリケーションはインストール時にオプションをカ
    スタマイズ出来ることが多い。
2.  にも関わらず`brew cask install`を使うと、それらのオプションを選べずにインスト
    ールされてしまい悲しい。
3.  そこで、`brew cask`で fetch までは自動化して、インストール自体は手動でやろう
    ( スマートではないが。)

# 方法

## 準備

以下のようなシェルスクリプトを書いて、**/usr/local/bin/brew-smash** など任意の実
行パスに配置し、`chmod +x /path/to/brew-smash`等で実行権限を与える。

```bash:/usr/local/bin/brew-smash
#!/bin/sh
# Usage: brew smash app-name

if [ -z "$1" ] ; then
  echo "Usage: brew smash app-name"
  exit 1
fi

if [ ! -d "Casks" ] ; then
  KEEP_CLEAN=true
else
  KEEP_CLEAN=false
fi

HOMEBREW_CACHE=. brew cask fetch "$1"

if [ "$KEEP_CLEAN" = true ] ; then
  rm -r "Casks"
fi
```

もしくは直接ダウンロードしても良い。

```bash
$ curl https://gist.githubusercontent.com/uetchy/eb625f922eff16eb404b/raw/brew-smash.sh -o /usr/local/bin/brew-smash
$ chmod +x /usr/local/bin/brew-smash
```

## 実際に使う

以下のように`brew smash`コマンドを叩く

```bash
$ brew smash send-to-kindle
==> Fetching resources for Cask send-to-kindle
==> Downloading https://s3.amazonaws.com/sendtokindle/SendToKindleForMac-installer-v1.0.0.220.pkg
######################################################################## 100.0%
==> Success! Downloaded to -> ./send-to-kindle-1.0.0.220.pkg
```

# シェルスクリプトの解説

難しいことはやってないが、`brew cask fetch`コマンドはキャッシュ先に**Casks**ディ
レクトリを生成するので、それを除去している。また、元々カレントディレクトリに
Casks という名前のディレクトリがある場合、それを削除してしまわないようにしている
。

# 本当にやりたかったこと

こういう機能いれてくれ

```bash
$ brew cask install virtualbox

==> Fetching resources for Cask virtualbox

==> Downloading http://download.virtualbox.org/virtualbox/4.3.18/VirtualBox-4.3.18-96516-OSX.dmg

###### ################################################################## 100.0%

==> Cask virtualbox has installation options

==> Do you need to install 'Oracle VM VirtualBox Command Line Utilities'? [y/n]

==> y

==> Success!
```
