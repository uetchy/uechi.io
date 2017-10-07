---
title: Install NVIDIA GeForce GTX TITAN X in MacPro Early 2008
date: 2017-02-13 14:20:00 +09:00
---

MacPro Early 2008 という骨董品にNVIDIA Titan X (Maxwell)を積んだところ、いくつかの問題にぶつかりました。この記事でそれらの問題と解決策について書きます。

# NVIDIAドライバーが非対応

あまりにも古いアーキテクチャのMacProに対してNVIDIAのグラフィックドライバーが対応していません。
そこで、適切なバージョンの[NVIDIA Web Driver](http://www.macvidcards.com/drivers.html)をインストールすることでこれを解決しました。
これには問題もあります。macOSのアップデートをインストールするたびに、それに対応したドライバーを都度インストールする必要がありました。

ドライバーをインストールするまでは画面に何も映りません。そこで、pkg形式のドライバーを`scp`でMacProに転送して、`installer`を使ってドライバーをインストールすることにしました。

```
scp driver.pkg MacPro.local:~
ssh MacPro.local
sudo installer -pkg ./driver.pkg -target /
```

# 電源ユニット(PSU)のパワー不足

TITAN X(Maxwell)が要求するパワーをMacProのPSUは提供することが出来ません。
そこで、秋葉原のPCパーツショップで追加のPSUを購入して、GPU専用の電源として使いました。
ここで新たな問題が生まれます。正しくパワーを提供するためにはMacProのPSUと追加のPSUを同期させる必要があり、またそれを実現するパーツもあるのですが、場合によってはGPUを破損してしまう危険性がありました。
今回は電源を同期することは見送り、個別にスイッチを入れることで解決しました。
