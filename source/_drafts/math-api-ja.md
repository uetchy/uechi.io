---
title: 数学API：SVG画像としてのLaTeX Math
description: <img>のような場所にLaTeX数学方程式を配置します。
tags:
  - LaTeX
  - Math
  - API
  - showdev
---

私はいつも、LaTeX Math 方程式を、MathJax が内部で実行できない Web ページに配置したいと思っていました。

少し時間をかけて、LaTeX Math マークアップを SVG 画像にレンダリングする[Math API](https://math.now.sh) を作成しました。

したがって、GitHub、Jupyter Notebook、dev.to、そして Qiita（こちら！）など、 `<img>`または Markdown（ `![]()`）を配置できるほぼすべての場所に方程式を配置できます。

```markdown
![](https://math.now.sh?from=\LaTeX)
```

![](https://math.now.sh?from=\LaTeX)

```markdown
![](https://math.now.sh?from=\log\prod^N_i x_i = \sum^N_i \log{x_i})
```

$$
\log\prod^N_i x_i = \sum^N_i \log{x_i}
$$

## インライン画像

![](https://thepracticaldev.s3.amazonaws.com/i/fqea9nq2wv9in15lqlf3.png)

![](https://thepracticaldev.s3.amazonaws.com/i/43slt0h6dfhox1xwmuti.png)

クエリを「from」から「inline」に変更することにより、インライン方程式を生成することができます。

```markdown
<img src="https://math.now.sh?inline=\\LaTeX" />
```

## オンラインエディター

また、[Math API](https://math.now.sh) で利用可能なオンラインエディターがあります。

![](https://thepracticaldev.s3.amazonaws.com/i/gg2wil3exu9lyj7ppuoy.png)

## 結論

ソースコードは[GitHub](https://github.com/uetchy/math-api)で入手できます。
それを試してみて、新機能のコメント/アイデアを残してください。
