---
title: Rails Assetsのパッケージをコマンドラインから検索する
date: 2014-03-14 09:00:00 +09:00
---

[Rails Assets](https://rails-assets.org/) はBowerパッケージをBundlerで管理出来る便利なサービスである。

ウェブサイトにアクセスして、Rails Assetsに登録されているパッケージを検索するのは面倒なのでCLIから検索したい。そのためには`gem search --source {url}`オプションを利用したら良い。

```bash
$ gem search {package-name} --source https://rails-assets.org | grep "^rails-assets-"
```

`gem search` はsourceを指定しているにも関わらず RubyGems.org のパッケージも引っかかってしまうのでRails Assetsのプレフィックスで抽出している。

### シェルスクリプト

```bash:rails-assets.sh
#!/bin/sh
# Usage: rails-assets [package-name] [-a]

gem search $1 $2 --source https://rails-assets.org | grep "^rails-assets-"
```

もっと簡単に、シェル関数を定義することも出来る。

```bash:~/.zshrc
rails-assets(){
  gem search $1 $2 --source https://rails-assets.org | grep "^rails-assets-"
}
```
