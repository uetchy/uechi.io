---
title: Install NVIDIA GeForce GTX TITAN X in MacPro Early 2008
date: 2017-02-13 14:20:00 +09:00
redirect_from: "/blog/2017/02/13/nvidia-titan-x-macpro-early-2008"
---

MacPro Early 2008 という骨董品に NVIDIA Titan X (Maxwell)を積んだところ、いくつかの問題にぶつかりました。この記事でそれらの問題と解決策について書きます。

# NVIDIA ドライバーが非対応

あまりにも古いアーキテクチャの MacPro に対して NVIDIA のグラフィックドライバーが対応していません。
そこで、適切なバージョンの[NVIDIA Web Driver](http://www.macvidcards.com/drivers.html)をインストールすることでこれを解決しました。
これには問題もあります。macOS のアップデートをインストールするたびに、それに対応したドライバーを都度インストールする必要がありました。

ドライバーをインストールするまでは画面に何も映りません。そこで、pkg 形式のドライバーを`scp`で MacPro に転送して、`installer`を使ってドライバーをインストールすることにしました。

```
scp driver.pkg MacPro.local:~
ssh MacPro.local
sudo installer -pkg ./driver.pkg -target /
```

# 電源ユニット(PSU)のパワー不足

TITAN X(Maxwell)が要求するパワーを MacPro の PSU は提供することが出来ません。
そこで、秋葉原の PC パーツショップで追加の PSU を購入して、GPU 専用の電源として使いました。
ここで新たな問題が生まれます。正しくパワーを提供するためには MacPro の PSU と追加の PSU を同期させる必要があり、またそれを実現するパーツもあるのですが、場合によっては GPU を破損してしまう危険性がありました。
今回は電源を同期することは見送り、個別にスイッチを入れることで解決しました。
