---
title: 'gulp + decomposer: Best way to sassy-@import bower components'
date: 2015-02-26 00:00:00 Z
---

gulp + Browserify(+ debowerify)という構成でWebサイトを作っていると、SASSにもdebowerify相当のものが欲しくなってくる。

ちなみに、__debowerify__ というのは、

```js
var Velocity = require("velocity");
```

というJavaScriptを、

```js
var Velocity = require("./../../bower_components/velocity/velocity.js");
```

という風に、bower_components内のパスに解決してくれるBrowserify transformだ。
欲しいのはこれのSASS版。

「あったらいいのにな〜」と思うようなライブラリはGithubで検索すれば必ず出てくる。はずだったが、無かった。

そこで [decomposer](https://www.npmjs.com/package/decomposer) というgulpプラグインを作った。

# 使い方

まずは`npm install --save-dev gulp gulp-sass decomposer`で必要なものをインストールしておく。既存のプロジェクトに追加するならdecomposerだけでいい。

__gulpfile.js__ はこのように定義しておく。

```js
var gulp = require('gulp');
var sass = require('gulp-sass');
var decomposer = require('decomposer');

gulp.task('styles', function() {
  gulp.src('src/styles/**/*.sass')
    .pipe(decomposer())
    .pipe(sass({indentedSyntax: true}))
    .pipe(gulp.dest('dist/css'));
});
```

ポイントは`sass` __よりも前__ に`decomposer`を挟むこと。なぜなら、外部から@importしたmix-insや変数はSASSコンパイル時に解決されるからだ。`sass`よりも後に置くと、SASSが@importを解決出来ずにエラーが発生する。

続けてSASSを書こう。

```scss
@import normalize.sass
@import styles/font

body
  font-family: $ff-gothic
```

> `$ff-gothic`は [uetchy/styles](https://github.com/uetchy/styles) の _font.sass_ で定義されているfont-familyだ。

最後にBowerを使って必要なアセットをインストールする。

```bash
bower i --save normalize.sass
bower i --save uetchy/styles
```

これで完成。後は`gulp styles`を実行するだけだ。

# ファイルパス解決時のポイント

decomposer はBowerモジュールに入っている任意のファイルを指定して@importすることが出来る。
記法はこのようになる。

```scss
@import [Bowerモジュール名]/[ファイル名]
```

例えば、よく使うスタイルをまとめた [uetchy/styles](https://github.com/uetchy/styles) の___font.sass__ を@importするなら、

```scss
@import styles/font
```

と書ける。
ここでもし`@import styles`と、ファイル名を省略して書くとどうなるのだろうか？　コンパイルに失敗する？　そんなことはない。

モジュール名だけを書くと、decomposerは__bower.json__に書かれているmainファイルを見つけ出して、それを@importしてくれるのだ。

もしmainファイルが複数指定されていたら、`index.sass`や`[モジュール名].sass`、または__mainっぽい名前__ を持つファイルを@importする。

つまり、

```scss
@import normalize.sass
```

と書けば、

```scss
@import ../bower_components/normalize.sass/normalize.sass
```

という風に解決される。

# まとめ

これでスタイルの@importをすっきり書けるようになった。
とはいえ、component対応やPlain CSSのインライン展開や.less対応など、追加したい機能は色々ある。

もしContributionに興味があるなら、[Githubリポジトリ](https://github.com/uetchy/decomposer)をフォークしてほしい。
