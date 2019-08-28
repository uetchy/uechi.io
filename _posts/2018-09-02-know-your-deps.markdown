---
title: Know your deps on package.json in seconds
date: 2018-09-02 03:23:00 +09:00
---

![screen-1.png.jpeg](/uploads/screen-1.png.jpeg)

How do you know what packages that project/library depend on and what exactly are that packages doing for?
You'll want to quickly survey on them. So [npm-deps-list](https://github.com/uetchy/npm-deps-list) is here for.

You can install them using `npm` or `yarn`.

```bash
npm install -g npm-deps-list
```

Running `ndl`, you will get a detailed list of dependencies for the package on the current directory.

If you are using iTerm2, you can also `Command + Click` on a package name to jump to their homepage.

If you have any idea on it, please consider submitting an issue or a pull request!