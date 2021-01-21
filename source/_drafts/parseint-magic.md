---
title: "[].map(parseInt)"
---

## Fan fact

`[0xa, 0xa, 0xa].map(parseInt)` results in `[10, NaN, 2]`.

## Why???

`parseInt(0xa, 0, [0xa, 0xa, 0xa])`

The second argument is `0` so the first argument gonna be treated as decimal number becoming `10`.

`parseInt(0xa, 1, [0xa, 0xa, 0xa])`

The second argument is `1` which is invalid as a radix so the result ends up with `NaN`.

`parseInt(0xa, 2, [0xa, 0xa, 0xa])`

The second argument is `2` meaning the first argument going to be handled as a binary number. `0xa` is `10` in binary, which results in `2` in decimal form.
