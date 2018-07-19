---
title: 'gulp + decomposer: Best way to sassy-@import bower components'
date: 2015-02-26 09:00:00 +09:00
---

gulp + Browserify(+ debowerify)という構成で Web サイトを作っていると、SASS にも debowerify 相当のものが欲しくなってくる。

ちなみに、**debowerify** というのは、

```js
var Velocity = require('velocity')
```

という JavaScript を、

```js
var Velocity = require('./../../bower_components/velocity/velocity.js')
```

という風に、bower_components 内のパスに解決してくれる Browserify transform だ。
欲しいのはこれの SASS 版。

「あったらいいのにな〜」と思うようなライブラリは Github で検索すれば必ず出てくる。はずだったが、無かった。

そこで [decomposer](https://www.npmjs.com/package/decomposer) という gulp プラグインを作った。

# 使い方

まずは`npm install --save-dev gulp gulp-sass decomposer`で必要なものをインストールしておく。既存のプロジェクトに追加するなら decomposer だけでいい。

**gulpfile.js** はこのように定義しておく。

```js
var gulp = require('gulp')
var sass = require('gulp-sass')
var decomposer = require('decomposer')

gulp.task('styles', function() {
  gulp
    .src('src/styles/**/*.sass')
    .pipe(decomposer())
    .pipe(sass({ indentedSyntax: true }))
    .pipe(gulp.dest('dist/css'))
})
```

ポイントは`sass` **よりも前** に`decomposer`を挟むこと。なぜなら、外部から@import した mix-ins や変数は SASS コンパイル時に解決されるからだ。`sass`よりも後に置くと、SASS が@import を解決出来ずにエラーが発生する。

続けて SASS を書こう。

```scss
@import normalize.sass @import styles/font body font-family: $ff-gothic;
```

> `$ff-gothic`は [uetchy/styles](https://github.com/uetchy/styles) の _font.sass_ で定義されている font-family だ。

最後に Bower を使って必要なアセットをインストールする。

```bash
bower i --save normalize.sass
bower i --save uetchy/styles
```

これで完成。後は`gulp styles`を実行するだけだ。

# ファイルパス解決時のポイント

decomposer は Bower モジュールに入っている任意のファイルを指定して@import することが出来る。
記法はこのようになる。

```scss
@import [Bowerモジュール名]/[ファイル名];
```

例えば、よく使うスタイルをまとめた [uetchy/styles](https://github.com/uetchy/styles) の**\_font.sass** を@import するなら、

```scss
@import styles/font;
```

と書ける。
ここでもし`@import styles`と、ファイル名を省略して書くとどうなるのだろうか？　コンパイルに失敗する？　そんなことはない。

モジュール名だけを書くと、decomposer は**bower.json**に書かれている main ファイルを見つけ出して、それを@import してくれるのだ。

もし main ファイルが複数指定されていたら、`index.sass`や`[モジュール名].sass`、または**main っぽい名前** を持つファイルを@import する。

つまり、

```scss
@import normalize.sass;
```

と書けば、

```scss
@import ../bower_components/normalize.sass/normalize.sass;
```

という風に解決される。

# まとめ

これでスタイルの@import をすっきり書けるようになった。
とはいえ、component 対応や Plain CSS のインライン展開や.less 対応など、追加したい機能は色々ある。

もし Contribution に興味があるなら、[Github リポジトリ](https://github.com/uetchy/decomposer)をフォークしてほしい。
