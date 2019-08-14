---
title: Sketch 3 plugin 'StickyGrid'
date: 2014-12-03 09:00:00 +09:00
redirect_from: /blog/2014/12/03/sketch-plugin-stickygrid
---

For practicing Sketch plugin development, I created **StickyGrid** to let shape points sticked with grids.

![](http://uechi-public.s3.amazonaws.com/github/sketch-stickygrid.png)

Draw something in rough and apply this plugin then you'll get geometric shapes at ease.

# How to install

From [GitHub releases](https://github.com/uetchy/Sketch-StickyGrid/releases/latest), Download a zipped archive then unarchive it then double click **StickyGrid.sketchplugin** so you are prepared for using StickyGrid.

Loving _CLI-way_ than anything, You also want to run those commands to get the same thing.

```bash
cd $HOME/Library/Application Support/com.bohemiancoding.sketch3/Plugins
git clone https://github.com/uetchy/Sketch-StickyGrid.git
```

# Usage

At first, selecting **`ctrl` + `⌘` + `G`** を押すと、パスがグリッドの交差点に吸い付く。

ショートカット以外にも、メニューから**Plugins > Sketch-StickyGrid > Snap to Grid**を選んでも良い。

シェイプはもちろん、グルーピングされたシェイプも、逆にシェイプポイントだけでも吸い付く。

# プラグインの開発にあたって

## プラグインのデバッグ

デバッギングには[Sketch-DevTools](https://github.com/turbobabr/sketch-devtools)を使っていましたが、最新版の Sketch では使えなくなってしまった。

その代わりに Mac 標準アプリの **Console.app** を使う方法が公式デベロッパーサイトの記事 [Debugging - Sketch Developer](http://developer.sketchapp.com/code-examples/debugging/) で紹介されている。

スクリプト内で`log`関数を呼び出すと、Console.app にログが出力される。

```js
log(context.document.gridSize)
```

## ドキュメントの情報源

ドキュメントは公式デベロッパーサイト [Sketch Developer](http://developer.sketchapp.com) があるものの、パス編集に関するドキュメントは全くなかった。

そこで、[class-dump](http://stevenygard.com/projects/class-dump/) を使って Sketch.app のヘッダーファイルを抽出し、ひたすら**目 grep**をしてシェイプ操作とグリッドに関する API を探し出し、プラグインの実装に役立てた。

また、先人によって公開されている数多の Sketch プラグインのソースを見ることも、開発の助けになった。

# 結論

苦行僧じみた Sketch プラグインの開発には**class-dump**と**Console.app**が必携。