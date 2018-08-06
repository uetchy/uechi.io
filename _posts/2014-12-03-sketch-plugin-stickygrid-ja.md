---
title: Sketch 3 plugin 'StickyGrid'
date: 2014-12-03 09:00:00 +09:00
---

選択したシェイプのポイントをグリッドに吸い付かせるプラグイン StickyGrid を作りました。

![](http://uechi-public.s3.amazonaws.com/github/sketch-stickygrid.png)

Vector ツールで軽くスケッチしてからこのプラグインを適用することで、簡単に幾何学的なオブジェクトを作ることが出来る。

# インストール

[リリースページ](https://github.com/uetchy/Sketch-StickyGrid/releases/latest)から zip アーカイブをダウンロードし、**StickyGrid.sketchplugin** をダブルクリックしてインストールする。

もし、より*CLI-way*がお好みであれば、以下のコマンドでもインストールすることが出来る。

```bash
cd $HOME/Library/Application Support/com.bohemiancoding.sketch3/Plugins
git clone https://github.com/uetchy/Sketch-StickyGrid.git
```

# 使い方

吸い付かせたいシェイプを 1 つ、または複数選択して **`ctrl` + `⌘` + `G`** を押すと、パスがグリッドの交差点に吸い付く。

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

そこで、[class-dump](http://stevenygard.com/projects/class-dump/) を使って Sketch.app のヘッダーファイルを抽出し、ひたすら **目 grep** をしてシェイプ操作とグリッドに関する API を探し出し、プラグインの実装に役立てた。

また、先人によって公開されている数多の Sketch プラグインのソースを見ることも、開発の助けになった。

# 結論

苦行僧じみた Sketch プラグインの開発には **class-dump** と **Console.app** が必携。
