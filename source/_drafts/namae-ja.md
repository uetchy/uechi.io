---
title: namae.devでアプリのスリック名を付けます
tags:
  - javascript
  - web
cover_image: https://thepracticaldev.s3.amazonaws.com/i/uafydwlnfneikuiyxe2w.png
---

新しい OSS プロジェクトまたは Web アプリの命名に苦労したことがありますか？ GitHub、npm、Homebrew、PyPI、Domains などで希望するものを誰も要求していないことを望みながら、最適な名前を ​​ 選択するのは退屈です。

だからこそ、[namae](https://namae.dev)を作成しました。

## namae

![namae](https://thepracticaldev.s3.amazonaws.com/i/np1a40lrch9m10b1s7nz.gif)

[namae](https://namae.dev) は、開発者と起業家向けのプラットフォーム間名前可用性チェッカーです。

使用する名前をフォームに入力すると、namae はさまざまなレジストリを調べて、名前がすでに使用されているかどうかを確認します。

![Alt Text](https://thepracticaldev.s3.amazonaws.com/i/pww3x6ycshadfiiotep9.png)

## サポートされているプラ ​​ ットフォーム

namae は 15 のパッケージレジストリと Web プラットフォームをサポートしており、成長しています。

- ドメイン
- GitHub Organization
- npm / npm Organization
- PyPI
- RubyGems
- crates.io (Rust)
- Homebrew / Homebrew Cask
- LaunchPad / APT (Linux)
- Twitter
- Spectrum
- Slack
- Heroku
- ZEIT Now
- AWS S3
- js.org

さらに、検索結果には、**GitHub**および**App Store**に類似した名前のプロジェクトのリストが含まれています。

## 名前の提案

namae には、**Name Suggestion**という独自の機能もあります。共通の接頭辞/接尾辞と同義語で構成される自動生成された名前を提案します。いくつかの例を見てみましょう。

![Alt Text](https://thepracticaldev.s3.amazonaws.com/i/aas52pwbrueyzrulfiae.png)

![Alt Text](https://thepracticaldev.s3.amazonaws.com/i/j6jv0rq4gin28hks1ika.png)

提案をクリックすると、ナマエはフォームを完成させて、レジストリを検索し始めます。

## オープンソース

namae は完全にオープンソースであり、ソースコード全体は[GitHub](https://github.com/uetchy/namae)で入手できます。 API 用の Node.js Lambda と Web フロントエンド用の React アプリで構成され、[ZEIT Now](https://now.sh)で実行されています。

## 結論

namae を使用すると、ホスティングプロバイダーとパッケージレジストリのセットの周りで普遍的に利用可能な名前を検索する時間を節約できます。

[namae.dev](https://namae.dev/)に移動して、将来の製品名が入手可能かどうかのレポートを取得します。何か提案があれば、コメントを残すか、Twitter（[@uetschy](https://twitter.com/uetschy)）で私に連絡してください。
