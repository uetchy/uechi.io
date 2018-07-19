---
title: Gluing Installed Atom Packages and apm Stars Together
date: 2015-12-16 09:00:00 +09:00
---

Atom にインストールしているパッケージと[Atom.io](https://atom.io/packages)上のスターを同期する CLI ツール [Atom Package Diff](https://www.npmjs.com/package/atom-package-diff) を公開した。

# 導入

npm 経由でインストールする。

```bash
$ npm install -g atom-package-diff
```

# インストール済みパッケージとスターの diff

`apd status`コマンドでインストール済みパッケージとスターしているパッケージの diff を見ることができる。

```bash
$ apd status
36 packages installed
30 packages starred

# Packages only in apm
project-manager react

# Packages only in local machine
Sublime-Style-Column-Selection atom-fuzzy-grep douglas language-babel language-ini language-swift term3 travis-ci-status
```

# 同期

`apd sync --local`を実行すると、インストール済みパッケージを全部`apm star`し、それ以外を`apm unstar`する。

`apd sync --remote`でその逆の処理を行う。つまり、スターされているパッケージを全部インストールし、それ以外をアンインストールする。

```bash
$ apd sync --local
Unstaring ... project-manager
Unstaring ... react
Staring ... Sublime-Style-Column-Selection
Staring ... atom-fuzzy-grep
Staring ... douglas
Staring ... language-babel
Staring ... language-ini
Staring ... language-swift
Staring ... term3
Staring ... travis-ci-status
```

ソースコードは [Github](uetchy/atom-package-diff) で公開している。
