---
title: Create .icns from .sketch
date: 2015-03-10 09:00:00 +09:00
redirect_from: "/blog/2015/03/10/create-icns-from-sketch"
---

![](/uploads/create-icns-from-sketch/intro.png)

Gulp をつかって .sketch から .icns を生成するために、[gulp-sketch](https://github.com/cognitom/gulp-sketch) の出力結果を.icns へ変換する [gulp-iconutil](https://github.com/uetchy/gulp-iconutil) というプラグインを作りました。

# はじめに

.icns を作るには様々なサイズのアイコン画像を格納した **iconset** をつくり、それを `iconutil` に渡します。ここで面倒なのは iconset です。

iconset の作成には 16×16 ... 512×512 の 6 種類のサイズのアイコンと、さらにそれぞれの Retina 用のアイコンも加えて、計 12 種類ものサイズの画像が必要です。

唯一の救いは、最大サイズの画像だけ用意しておけば、不足している小さいサイズの画像は`iconutil`が自動で生成するということでしょう。

今回作った [gulp-iconutil](https://www.npmjs.com/package/gulp-iconutil) は、Gulp からこの`iconutil`コマンドへの橋渡しをしてくれます。

# アイコンをデザインする

Sketch 上に 512×512 サイズのアートボードを作成し、アプリのアイコンをデザインします。

![](/uploads/create-icns-from-sketch/dock.png)

> Dock 上でアイコンの見栄えをチェックするために、[sketch-dockpreview](https://github.com/fnky/sketch-dockpreview)を使っています。これは本当に便利なプラグインです。

# .sketch から .icns へ

.sketch から iconset を作成するために、[gulp-sketch](https://github.com/cognitom/gulp-sketch) を、そして iconset から .icns へ変換するために今回作った [gulp-iconutil](https://www.npmjs.com/package/gulp-iconutil) を使います。npm からインストール出来ます。

Gulp タスクは以下のように書きます。

```coffee
gulp     = require 'gulp'
sketch   = require 'gulp-sketch'
iconutil = require 'gulp-iconutil'

gulp.task 'icons', ->
  gulp.src 'icons/sketch/*.sketch'
    .pipe sketch
      export: 'artboards'
      formats: 'png'
      scales: '1.0,2.0'
    .pipe iconutil('app.icns')
    .pipe gulp.dest 'icons/'
```

icons タスクを実行すると、icons フォルダの中に**app.icns**が生成されます。

![](/uploads/create-icns-from-sketch/result.png)

Electron アプリ開発者はこのアイコンファイルを OS X 向けビルドにそのまま使えます。

# まとめ

デザインデータのポストプロセスの自動化が Gulp と sketchtool のおかげでやりやすくなりました。

[gulp-iconutil](https://github.com/uetchy/gulp-iconutil) は今週リリースしたばかりで若干不安定なので、もしバグを見つけたら[Issue](https://github.com/uetchy/gulp-iconutil/issues)を作るか、[PR](https://github.com/uetchy/gulp-iconutil/pulls)を投げてください!
