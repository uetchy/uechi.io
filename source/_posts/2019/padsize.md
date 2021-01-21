---
title: padStartにおけるpadSizeの求め方
date: 2019-01-14 00:00:00 +09:00
redirect_from: "/blog/2019/01/14/padsize"
---

padStart における padSize の求め方です。

$$
\textrm{padSize} = \lceil \log_{10}(\mathbf{arraySize} + 1) \rceil
$$

```js
const padSize = Math.ceil(Math.log10(arr.length + 1));

arr.forEach((item, index) => {
  console.log(`${index.padStart(padSize, "0")}: ${item}`);
});
```

結果は以下のようになる。

```
01: item1
02: item2
03: item3
04: item4
05: item5
06: item6
07: item7
08: item8
09: item9
10: item10
```
