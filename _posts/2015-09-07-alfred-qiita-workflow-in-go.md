---
title: Alfred Qiita Workflow in Go
date: 2015-09-07 09:00:00 +09:00
---

![Cover](http://randompaper.co.s3.amazonaws.com/alfred-qiita-workflow/alfred-qiita-workflow.png)

Rubyで書かれている [Alfred Qiita Workflow](https://github.com/uetchy/alfred-qiita-workflow) を[バグ修正](https://github.com/uetchy/alfred-qiita-workflow/issues/3)のついでにGoで書き直した。

Qiita API v2に対応し、ユーザー名とパスワードの代わりとして、[Personal Access Token](https://qiita.com/settings/tokens/new)を使い始めた。

これで、ストックした記事や自分で書いた記事を検索することがより気軽に出来る。

Alfredに返却するXMLの生成には[go-alfred](https://github.com/pascalw/go-alfred)というライブラリを利用した。

## go-qiita

Alfred Qiita Workflow の APIクライアント部分を切り出して [go-qiita](https://github.com/uetchy/go-qiita) としてリリースした。Workflowで必要だった部分しか実装してないが、記事の検索など基本的なことは出来る。

設計はGoogleの [go-github](https://github.com/google/go-github) を参考にしている。クライアントの初期化時に、以下のようにhttp.Client互換のInterfaceを渡してやれば、それを経由して通信するようになっている。

```go
// Personal Access Tokenを使ったOAuth2クライアントを作る
ts := oauth2.StaticTokenSource(&oauth2.Token{AccessToken: "personal access token"})
tc := oauth2.NewClient(oauth2.NoContext, ts)

// OAuth2クライアントをgo-qiitaに引き渡す
client := qiita.NewClient(tc)

// 今までに書いた記事を取得
items, _, _ := client.AuthenticatedUser.Items()
```

このようにすることで、APIクライアントは認証系を気にせずAPIサーバーとのやりとりを考えることが出来る。このやり方はかなりスマートだと思うのでもっと流行って欲しい。

ちなみに認証をしない場合は`NewClient()`に`nil`を渡せばよい。

```go
client := qiita.NewClient(nil)
```
