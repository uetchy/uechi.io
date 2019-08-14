---
title: CaboCha on RubyGems
date: 2015-02-26 09:00:00 +09:00
redirect_from: "/blog/2015/02/26/cabocha-on-rubygems"
---

日本語係り受け解析器 CaboCha の Ruby バインディング [cabocha-ruby](https://github.com/uetchy/cabocha-ruby) をリリースした。とは言っても [公式](https://code.google.com/p/cabocha/) の SWIG バインディングをベースにしたものだ。

## 導入

```bash
gem install cabocha
```

でインストール出来る。

> cabocha-ruby をインストールする前に、CaboCha を`brew install cabocha`かなんかでインストールしておかないと make が失敗するので注意すること。

## 使う

require する時は`require "cabocha"`と`require "CaboCha"`、どちらを使っても正しい。

```ruby
require "cabocha"

parser = CaboCha::Parser.new
tree = parser.parse("太郎は次郎に本を貸した")

p tree
```

これまでソースコードをダウンロードし`ruby extconf.rb && make install`していたのが、これからは`gem install cabocha`で済むようになる。

バグを見つけたら [Pull request](https://github.com/uetchy/cabocha-ruby/pulls) を送ってほしい。
