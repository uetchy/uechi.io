---
title: 新しい自宅サーバーの構成
date: 2021-02-13T00:00:00
---

10 年ぶりにサーバーを更新しました。初めての AMD、初めての DDR4、初めての NVM Express です。

# 用途

- セルフホスト (Dockerized)
  - メールサーバー
  - DNS サーバー
  - Nextcloud（ファイル、カレンダー、連絡先等）
  - GitLab
  - プライベート Docker レジストリ
  - VPN 他
- 計算実験
- Docker Swarm ノード
- VS Code Remote SSH のホストマシン

# スペック

重いタスクを並列してやらせたいので最優先は CPU とメモリです。メモリはデュアルチャンネルにしたいので [DDR4-3200 32GBx2](https://shop.tsukumo.co.jp/goods/4582353591719/) を、CPU は昨今のライブラリのマルチコア対応を勘案して [Ryzen 9 3950X](https://www.amd.com/en/products/cpu/amd-ryzen-9-3950x) を選びました。CPU クーラーは Noctua の [NH-D15 Black](https://noctua.at/en/nh-d15) です。

> 結果から言うとメモリはもっと必要でした。巨大な Pandas データフレームを並列処理なんかするとサクッと消えてしまいます。予算に余裕があるなら 128GB ほど用意したほうが良いかもしれません。

GPU は古いサーバーに突っ込んでいた NVIDIA GeForce GTX TITAN X (Maxwell)を流用しました。グラフィックメモリが 12GB ちょっとですが、最大ワークロード時でも 5GB は残るので今のところ十分です。必要になったタイミングで増やします。

記憶装置は WD HDD 3TB 2 台と Samsung 970 EVO Plus 500GB M.2 PCIe、そして古いサーバーから引っこ抜いた Samsung 870 EVO Plus 500GB SSD です。NVMe メモリは OS 用、SSD/HDD はデータとバックアップ用にします。

マザーボードは、X570 と比較して実装されているコンデンサーやパーツがサーバー向きだと感じた[ASRock B550 Taichi](https://www.asrock.com/mb/AMD/B550%20Taichi/) にしました。

電源は今後 GPU を追加することを考えて [Seasonic PRIME TX 850](https://seasonic.com/prime-tx) を選びました。実際にサーバーを稼働させながら使用電力を計測したところ、アイドル時に 180W 前後、フル稼働時でも 350W を超えない程度でした。今後 UPS を買う場合はその付近+バッファを考慮したグレードを選ぶことにします。

ケースは Fractal Design の [Meshify 2](https://www.fractal-design.com/products/cases/meshify/meshify-2/Black/) です。

OS は長年付き合ってきた Ubuntu と袂を分かち、[Arch Linux](https://archlinux.org/) を選びました。ミニマルなところが好きです。本当に何も用意してくれません。セットアップウィザードとかないです。`which`すらインストールしなければ使えません。

Arch Linux のセットアップは[個別に記事](https://uechi.io/blog/installing-arch-linux/)を書いたので読んでください。入力したコマンドを全て記録しました。

# パーツ選定時のポイント

- パーツ購入前に [Linux Hardware Database](https://linux-hardware.org/) を見て、インストールする予定の Linux ディストリと相性が良いかチェックする
- [Bottleneck Calculator](https://pc-builds.com/calculator/)で CPU と GPU の組み合わせを選び、そのうちどちらが性能のボトルネックになるか調べる
- [UserBenchmark](https://www.userbenchmark.com/)でユーザーが投稿したベンチマーク結果を眺める
- CPU クーラーは大口径の方が静か
- メモリはデュアルチャンネルによる高速化を目指し 2 枚構成にする
- PSU は Seasonic が評判良い
- 東芝 D01 が HGST の系譜
- [B550](https://www.amd.com/en/chipsets/b550) は長期運用に向いている
  - B520 は廉価版
- TSUKUMO eX. の自作 PC コーナーのスタッフはガチ勢なので信頼できる
  - 不明な部分があれば根掘り葉掘り聞きましょう

# 組立ての勘所

- 筐体は無視してまずマザボ、CPU、クーラー、（オンボードグラフィックが無い CPU なら）グラボ、そして電源を繋いで通電・動作テストをする
  - [MemTest86](https://www.memtest86.com/)でメモリの動作テスト
  - USB ブートで OS の起動確認
- Ethernet が死んでいる場合は USB-Ethernet アダプターでまずネットを確保する
  - マザボまたはアダプターメーカーからアップデートを探す
  - ほとんどの場合 Linux カーネルのバージョンを上げると直る
    - Ubuntu の場合: [kernel.ubuntu.com](https://kernel.ubuntu.com/~kernel-ppa/mainline/?C=N;O=D) から探してアップデートする（[https://itsfoss.com/upgrade-linux-kernel-ubuntu/](https://itsfoss.com/upgrade-linux-kernel-ubuntu/)）
    - Arch Linux の場合: 常に最新なので問題無い
- 安い筐体のネジは柔いことがあるため、強く押し込みながら少しずつ回す
  - 山が潰れてきたらゴムシートを挟む
- すべて動いたら、[Probe を送信](https://linux-hardware.org/index.php?view=howto)してデータベースに貢献しましょう
