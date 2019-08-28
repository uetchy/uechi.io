---
title: 'Math API: LaTeX Math as SVG image'
date: 2018-10-23 03:19:00 +09:00
---

I've always wanted to put LaTeX Math equations on a web page where MathJax is not allowed to run inside it.

Spending some time, I made [Math API](https://math.now.sh), that renders LaTeX Math markup into an SVG image.

So you can place your equation on almost everywhere on which you could put `<img>` or Markdown (`![]()`), such as GitHub, Jupyter Notebook or dev.to (here!).


```markdown
![](https://math.now.sh?from=\LaTeX)
```

![Equation](https://math.now.sh?from=%5CLaTeX)


```markdown
![](https://math.now.sh?from=\log\prod^N_{i}x_{i}=\sum^N_i\log{x_i})
```

![Equation](https://math.now.sh?from=%5Clog%5Cprod%5EN_%7Bi%7Dx_%7Bi%7D%3D%5Csum%5EN_i%5Clog%7Bx_i%7D)


# Inline image

![fqea9nq2wv9in15lqlf3.png.jpeg](/uploads/fqea9nq2wv9in15lqlf3.png.jpeg)
![43slt0h6dfhox1xwmuti.png.jpeg](/uploads/43slt0h6dfhox1xwmuti.png.jpeg)

It is possible to generate an inline equation by changing the query from `from` to `inline`.

```markdown
<img src="https://math.now.sh?inline=\\LaTeX" />
```

# Online Editor

Also, there is the online editor available at https://math.now.sh.

![gg2wil3exu9lyj7ppuoy.png](/uploads/gg2wil3exu9lyj7ppuoy.png)

# Conclusion

The source code is available on [GitHub](https://github.com/uetchy/math-api).
Give it a try and leave a comment/idea for a new feature.