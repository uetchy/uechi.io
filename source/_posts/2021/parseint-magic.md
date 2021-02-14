---
title: "[].map(parseInt)"
date: 2021-02-14T11:30:00
---

Fun fact: `[0xa, 0xa, 0xa].map(parseInt)` yields `[10, NaN, 2]`.

# Why

```js
parseInt(0xa, 0, [0xa, 0xa, 0xa]);
```

The second argument is `0` so the first argument going to be treated as decimal number becoming `10`.

```js
parseInt(0xa, 1, [0xa, 0xa, 0xa]);
```

The second argument is `1` which is invalid as a radix, so the result ends up with `NaN`.

```js
parseInt(0xa, 2, [0xa, 0xa, 0xa]);
```

The second argument is `2` meaning the first argument going to be handled as a binary number. `0xa` is `10` in binary, which results in `2` in decimal form.
