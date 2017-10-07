---
title: GitHubリポジトリの比較表を gh-compare で作る
date: 2017-05-13 12:00:00 +09:00
image: http://randompaper.co.s3.amazonaws.com/gh-compare.gif
---

# GitHubリポジトリの比較表を gh-compare で作る

![](http://randompaper.co.s3.amazonaws.com/gh-compare.gif)

[gh-compare](https://github.com/uetchy/gh-compare) を作りました。この小さなツールを使って、導入を検討しているライブラリ群の比較表をコマンド１つで作ることが出来ます。

ライブラリのリポジトリがGitHubにあることが前提になりますが、プロジェクトの勢いからサイズまで俯瞰することが出来ます。

最高と最悪の値はそれぞれ緑色と赤色に着色されるので、違いが一目瞭然でわかります。

## インストール

`gh-compare`モジュールは`npm`からインストール出来ます。

```bash
npm install --global gh-compare
```

## 使い方

`gh-compare`の後にスペース区切りで比較したいリポジトリを書きます。

```bash
gh-compare facebook/react vuejs/vue riot/riot angular/angular
```

もし変な挙動を見つけたら、プロジェクトの [Issues](https://github.com/uetchy/gh-compare/issues/new) に是非書いてください。