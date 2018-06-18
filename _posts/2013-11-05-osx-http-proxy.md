---
title: OS Xのネットワーク環境に合わせてHTTP_PROXYを切り替えるシェルスクリプト
date: 2013-11-05 09:00:00 +09:00
---

![](/uploads/osx-http-proxy.png)

大学のネットワークに接続している時だけプロキシを設定したい時がある。

Macのネットワーク環境は`networksetup -getcurrentlocation`コマンドで取得することが出来るので、

__.zshrc__ 辺りに以下のシェルスクリプトを書いておけばTerminalで新しいタブを開いた時に自動でプロキシを設定してくれるはずである。

```bash
proxy=proxy.hogehoge.ac.jp
switch_trigger=大学

if [ "`networksetup -getcurrentlocation`" = "$switch_trigger" ]; then
  export HTTP_PROXY=$proxy
  export FTP_PROXY=$proxy
  ...以下省略
fi
```

## Gitのプロキシ設定も書き換えたい

Gitはhttp_proxyを見てくれないのでリモートリポジトリにpush出来なくて困ることがあった。そこでhttp_proxyと一緒にGitのプロキシ設定も書き換えるようにしたい。

Gitのプロキシは以下のコマンドで設定出来る。`--global`の代わりに`--system`を使っても良い。

```bash
git config --global http.proxy $proxy
git config --global https.proxy $proxy
git config --global url."https://".insteadOf git://
```

逆に `git config` から設定を削除したい場合は`git config --gobal --unset {item}`を使えば良い。

先ほどのコマンドと組み合わせることで最終的なコードは以下のようになる。

```bash:switch_proxy.sh
proxy=proxy.hogehoge.ac.jp:80
switch_trigger=大学

function set_proxy() {
  export http_proxy=$proxy
  export HTTP_PROXY=$proxy
  export ftp_proxy=$proxy
  export FTP_PROXY=$proxy
  export all_proxy=$proxy
  export ALL_PROXY=$proxy
  export https_proxy=$proxy
  export HTTPS_PROXY=$proxy

  git config --global http.proxy $proxy
  git config --global https.proxy $proxy
  git config --global url."https://".insteadOf git://
}

function unset_proxy() {
  unset http_proxy
  unset HTTP_PROXY
  unset ftp_proxy
  unset FTP_PROXY
  unset all_proxy
  unset ALL_PROXY
  unset https_proxy
  unset HTTPS_PROXY

  git config --global --unset http.proxy
  git config --global --unset https.proxy
  git config --global --unset url."https://".insteadOf
}

if [ "`networksetup -getcurrentlocation`" = "$switch_trigger" ]; then
  echo "Switch to proxy for university network"
  set_proxy
else
  unset_proxy
fi
```

このコードを __.zshrc__ に保存して適当なターミナルで新しいセッションを開くと、`switch_trigger`で指定されたネットワーク環境下にいる時だけプロキシを通すことが出来る。

既に開いているセッションに対してプロキシを適用する方法がわからなかった。

Workaroundとして、コードを __~/.switch_proxy__ 辺りに置いて、

```bash:~/.zshrc
alias nswitch=~/.switch_proxy
```

と`.zshrc`に書いておくことで、`nswitch`とタイプしてプロキシを切り替えられるようになる。
