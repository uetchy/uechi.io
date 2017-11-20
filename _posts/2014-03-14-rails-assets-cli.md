---
title: Rails Assetsのパッケージをコマンドラインから検索する
date: 2014-03-14 09:00:00 +09:00
---

[Rails Assets](https://rails-assets.org/) は Bower パッケージを Bundler で管理出
来る便利なサービスである。

ウェブサイトにアクセスして、Rails Assets に登録されているパッケージを検索するの
は面倒なので CLI から検索したい。そのためには`gem search --source {url}`オプショ
ンを利用したら良い。

```bash
$ gem search {package-name} --source https://rails-assets.org | grep "^rails-assets-"
```

`gem search` は source を指定しているにも関わらず RubyGems.org のパッケージも引
っかかってしまうので Rails Assets のプレフィックスで抽出している。

### シェルスクリプト

```bash:rails-assets.sh
#!/bin/sh
# Usage: rails-assets [package-name] [-a]

gem search $1 $2 --source https://rails-assets.org | grep "^rails-assets-"
```

もっと簡単に、シェル関数を定義することも出来る。

```bash:~/.zshrc rails-assets(){ gem search $1 $2 --source
https://rails-assets.org | grep "^rails-assets-" }

```

```
