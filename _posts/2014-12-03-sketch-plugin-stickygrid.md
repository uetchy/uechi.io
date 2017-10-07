---
title: Sketch 3 plugin 'StickyGrid'
date: 2014-12-03 09:00:00 +09:00
---

For practicing Sketch plugin development, I created __StickyGrid__ to let shape points sticked with grids.

![](http://randompaper.co.s3.amazonaws.com/Sketch-StickyGrid/stickygrid.gif)

Draw something in rough and apply this plugin then you'll get geometric shapes at ease.

![](http://randompaper.co.s3.amazonaws.com/Sketch-StickyGrid/tf1.png)

# How to install

From [GitHub releases](https://github.com/uetchy/Sketch-StickyGrid/releases/latest), Download a zipped archive then unarchive it then double click __StickyGrid.sketchplugin__ so you are prepared for using StickyGrid.

Loving _CLI-way_ than anything, You also want to run those commands to get the same thing.

```bash
cd $HOME/Library/Application Support/com.bohemiancoding.sketch3/Plugins
git clone https://github.com/uetchy/Sketch-StickyGrid.git
```

# Usage

At first, selecting __`ctrl` + `⌘` + `G`__ を押すと、パスがグリッドの交差点に吸い付く。

ショートカット以外にも、メニューから__Plugins > Sketch-StickyGrid > Snap to Grid__を選んでも良い。

シェイプはもちろん、グルーピングされたシェイプも、逆にシェイプポイントだけでも吸い付く。

![](http://randompaper.co.s3.amazonaws.com/Sketch-StickyGrid/stickygrid_2.gif)

# プラグインの開発にあたって

## プラグインのデバッグ

デバッギングには[Sketch-DevTools](https://github.com/turbobabr/sketch-devtools)を使っていましたが、最新版のSketchでは使えなくなってしまった。

その代わりにMac標準アプリの __Console.app__ を使う方法が公式デベロッパーサイトの記事 [Debugging - Sketch Developer](http://developer.sketchapp.com/code-examples/debugging/) で紹介されている。

スクリプト内で`log`関数を呼び出すと、Console.appにログが出力される。

```js
log(context.document.gridSize);
```

## ドキュメントの情報源

ドキュメントは公式デベロッパーサイト [Sketch Developer](http://developer.sketchapp.com) があるものの、パス編集に関するドキュメントは全くなかった。

そこで、[class-dump](http://stevenygard.com/projects/class-dump/) を使って Sketch.app のヘッダーファイルを抽出し、ひたすら__目grep__をしてシェイプ操作とグリッドに関するAPIを探し出し、プラグインの実装に役立てた。

また、先人によって公開されている数多のSketchプラグインのソースを見ることも、開発の助けになった。

# 結論

苦行僧じみたSketchプラグインの開発には__class-dump__と__Console.app__が必携。
