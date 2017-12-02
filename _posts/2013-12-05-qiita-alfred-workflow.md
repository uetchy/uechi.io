---
title: Qiitaでストックした記事をインクリメンタルサーチするAlfred 2 Workflow
date: 2013-12-05 09:00:00 +09:00
---

コードを書いている時に、ストックしておいたQiitaの記事を検索したくなるシーンが最近増えてきた気がする。

そこで、以前作った[Qiitaの記事をインクリメンタルサーチするAlfred 2 Workflow](http://qiita.com/o_ame/items/f23e75bfc11e9e7b3a08)に、ストックした投稿を検索するコマンドを追加した。

![s1.png](https://raw.githubusercontent.com/uetchy/alfred-qiita-workflow/master/screenshots/qiita-workflow.png)

> [Githubリポジトリ](https://github.com/uetchy/alfred-qiita-workflow)から[ダウンロード](https://github.com/uetchy/alfred-qiita-workflow/archive/master.zip)

## 使い方

1. `qiita setup <username> <password>`でQiitaのアクセストークンを取得
2. `qiita stocks <query>`でストックした記事の検索
3. `qiita search <query>`で普通の検索

## まとめ

今度はRubyで書きなおして日本語も受け付けるように修正したので、需要はともかく個人的にかなり使いやすくなった気がする。

~~なお、このWorkflowはRuby 2.0.xで動作するので必然的にOS X Mavericksが必要になってくる。~~
__Ruby 1.9.xでも動作するように書きなおしたので古いOS Xでも動くようになった。__
