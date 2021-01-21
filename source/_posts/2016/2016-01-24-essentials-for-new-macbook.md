---
title: Essentials for New MacBook
date: 2016-01-24 09:00:00 +09:00
redirect_from: "/blog/2016/01/24/essentials-for-new-macbook"
---

![](/uploads/essentials-for-new-macbook-spec.png)

新しい MacBook を買ったので、普段使っているアプリの整理も兼ねて、幾つかポリシーを決めてセットアップすることにしました。

## 1. シンプル

インストールするアプリは最低限必要なものにしました。コンパクトにまとめると気持ちがいいですし、常駐するアプリを増やしてもバッテリーに悪いです。

## 2. デフォルト重視

なるべくデフォルトで用意されているものを使います。カスタマイズも OS X 標準機能の範囲内で行います。

# 使っているアプリ

## [Homebrew](http://brew.sh)

OS X 向けのパッケージマネージャーです。

## Atom

Sublime Text も良いのですが、やはりターミナルや Git が一画面で使えるのは MacBook のフルスクリーンアプリに合っています。

## LaunchControl

`launchctl`の GUI 版です。変な Agent が差し込まれていることがあるので、たまにチェックしています。

## [Papers](http://papersapp.com/mac/)

論文を管理するためのアプリです。これがベストと言えるわけではないですが、数ある中では一番使えます。

## [Typora](http://www.typora.io)

![](/uploads/essentials-for-new-macbook-typora.png)

これまで様々な Markdown エディタを試してきましたが、どれもエディタとプレビューが分離している UI を採用しており、それが私には不合理に思えて仕方がありませんでした。

Typora は入力した記法がリアルタイムに反映されるので直感的に文章を書くことが出来ます。 加えて Github Flavored Markdown、MathJax、Mermaid などのシーケンス図に対応しており、何気にニッチな需要を攻めている、小粋なアプリです。

## [⌘ 英かな](https://ei-kana.appspot.com)

US 配列キーボードの左右 ⌘ を英かなに割り振ることが出来るアプリです。実装がシンプルで軽量です。アイコンをデザインして Pull-request を送ったらマージしてくれました。

## [Paw](https://paw.cloud/)

Web API を作りたい時に使えます。無くても困りませんが、あると便利です。

## [Dash](https://kapeli.com/dash)

API ドキュメントを素早く検索出来るアプリです。

無いと困るようなアプリではありませんが、遅い Wi-Fi に繋いでいる場合でも素早くドキュメントを閲覧できるので外で作業するならあると便利でしょう。

## [Tower](http://www.git-tower.com)

Git の GUI クライアントです。

> より軽量なクライアントの[GitUp](http://gitup.co)も気になっています。

## [Google Chrome](https://www.google.com/chrome/browser/desktop/index.html)

普段は Safari を使っていますが、Chrome でしか動かない前時代的な Web サービスを使う時や、Web アプリケーションをデバッグする時のために入れました。

## Xcode

iOS アプリを作るときに必要なので入れました。

gcc や Git など、基本的なビルドツールチェインが必要な場合、Xcode をインストールする代わりに `sudo xcode-select —install` でそれらを導入できます。

## [ForkLift 3](http://www.binarynights.com/forklift/)

SFTP サーバーや S3 に接続するためのアプリです。接続したサーバーのディレクトリを Finder にマウントする機能があるので、ローカルで普通にファイルを扱う感覚でリモートのファイルをやりとり出来ます。Transmit から乗り換えました。

## [Kaleidoscope](http://www.kaleidoscopeapp.com)

さすがに標準の FileMerge だと機能不足が否めないので。

## [Sketch](https://www.sketchapp.com)

Bohemian Coding が開発しているベクターデザインツールです。アイコンや UI をデザインする時に使っています。

## RightFont

フォント管理アプリです。FontCase、FontExplorer X Pro などを使ってきましたが、今はこれに落ち着いています。Google Fonts や TypeKit に対応しており、またアイコンフォントを一覧できる機能が便利です。

## Adobe Creative Cloud

Affinity シリーズに乗り換えたので、今は Illustrator と TypeKit を使うために入れています。

## [Dropbox](https://www.dropbox.com)

ファイルの同期が出来ます。iCloud Drive も検討しましたが、削除したデータの復活に手間取るので見送りました。

## 1Password

パスワードマネージャーです。2 要素認証のトークンもまとめて管理できます。

## f.lux

iOS の Night Shift を macOS に持ってきたようなアプリです。長時間の作業でも目が痛くなりません。

## Reeder

RSS リーダーです。Feedly Web 版でも良いですが、Readability 機能が便利なので使っています。

## [AppCleaner](https://freemacsoft.net/appcleaner/)

アプリを設定ファイルごとまとめて消せます。潔癖性なので、これが無いと不安にな李ます。

## [Pocket](https://getpocket.com)

「あとで読む」を管理するためのアプリです。Reading List でもいいと思うので好みですね。

## [TripMode](https://www.tripmode.ch)

通信出来るアプリを個別に許可できます。外出先でテザリングをする際に TripMode があれば、データ制限を気にせずインターネット接続ができるので便利です。

# 導入を見送ったもの

## [Clear](http://realmacsoftware.com/clear/)

タスク管理アプリ。標準の Reminders.app に移行しました。

## [Evernote](https://evernote.com/intl/jp/)

Notes.app に移行しました。

## Flash

ニコニコ動画が見れなくなるので泣く泣く導入していましたが、公式で HTML5 に対応したので不要になりました。

## [VirtualBox](https://www.virtualbox.org)

仮想環境を構築するためのアプリです。[Docker Machine](https://docs.docker.com/machine/)と組み合わせていましたが、Docker for Mac の登場によって不要になりました。

## Karabiner

US 配列キーボードの Command キーを英かなに振り分けるため、Karabiner を使っていましたが、よりシンプルで軽量な[⌘ 英かな](https://ei-kana.appspot.com)に移行しました。

## Seil

US 配列の caps lock キーを Ctrl キーへ変更するために使っていましたが、いつからか macOS 標準で出来るようになっていたので不要になりました。

## Google 日本語入力

最近の OS 標準の IM に搭載されているライブ変換機能が優秀なので、あえてサードパーティの IM を入れる必要性がなくなりました。

## Alfred

便利そうなワークフローを色々入れても、実際に使う頻度はあまり高くないことに気がつき、この際なので Spotlight に切り替えました。
