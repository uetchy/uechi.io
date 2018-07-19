---
title: Qiitaでストックした記事をインクリメンタルサーチするAlfred 2 Workflow
date: 2013-12-05 09:00:00 +09:00
---

コードを書いている時に、ストックしておいた Qiita の記事を検索したくなるシーンが最近増えてきた気がする。

そこで、以前作った[Qiita の記事をインクリメンタルサーチする Alfred 2 Workflow](http://qiita.com/o_ame/items/f23e75bfc11e9e7b3a08)に、ストックした投稿を検索するコマンドを追加した。

![s1.png](/uploads/alfred-qiita-workflow.png)

> [Github リポジトリ](https://github.com/uetchy/alfred-qiita-workflow)から[ダウンロード](https://github.com/uetchy/alfred-qiita-workflow/archive/master.zip)

## 使い方

1.  `qiita setup <username> <password>`で Qiita のアクセストークンを取得
2.  `qiita stocks <query>`でストックした記事の検索
3.  `qiita search <query>`で普通の検索

## まとめ

今度は Ruby で書きなおして日本語も受け付けるように修正したので、需要はともかく個人的にかなり使いやすくなった気がする。

~~なお、この Workflow は Ruby 2.0.x で動作するので必然的に OS X Mavericks が必要になってくる。~~
**Ruby 1.9.x でも動作するように書きなおしたので古い OS X でも動くようになった。**
