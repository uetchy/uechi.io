---
title: Polyglot Extension for Safari
date: 2016-02-11 00:00:00 Z
---

![](http://randompaper.co.s3.amazonaws.com/Polyglot/header.png)

選択したテキストを翻訳できる Safari Extension を作った。[Polyglot](https://github.com/uetchy/Polyglot) を使えば、選択した文章や、フォームに入力したテキストをその場で好きな言語に翻訳してみせることが出来る。

![](http://randompaper.co.s3.amazonaws.com/Polyglot/screencast1.gif)

この Extension は __Google Translate API__ を使っている。だからこれを Safari で使うためには、まず Google Cloud Platform から APIキーを手に入れなくてはならない。その手続きは少しばかり面倒なので、[スクリーンショット付きのガイド](https://github.com/uetchy/Polyglot/wiki/How-to-obtain-Google-Cloud-Platform-API-key)を作った。

## Inside Safari Extension

技術的に特段おもしろいことをしているわけではない。ES2015 でコードを書き、webpack と babel を使って Extension向けにトランスパイルしている。意外だったのは、Safari Extension の構造が Google Chrome 拡張機能のそれとよく似ていたことだ。これならば Chrome 開発者でも容易に Safari Extension を作れるだろう。

## プラットフォーム間の差異を無くすには

プログラミング言語 Python は、大きく Python 2 と Python 3 の二つのバージョンに分かれている。双方に互換性は無く、Python 3 で書かれたコードが Python 2 では動かない。しかし、six （ネーミングは 2 × 3 ？）というライブラリを使うことで、バージョン間の差異をライブラリが吸収し、同じコードベースを両方のバージョンで動かすことが出来る。

これと同じように、Safari と Google Chrome の拡張機能の仕様の違いを吸収してくれるライブラリがあれば、Safari Extension 界隈も賑やかになるのではないか。
