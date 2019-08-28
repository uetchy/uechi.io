---
title: Comparing OSS on GitHub
date: 2019-08-29 03:21:00 +09:00
---

You are making a decision on which open source project you would adopt for your newly developing application.

This time it is a little bit difficult for you because the candidates are seemingly almost the same in a functional perspective.

So let's delve into this from a different perspective: contributors and users activities.

- More stars, forks, and watchers are the good vital sign of a vibrant project, which indicates many users getting involved with the project.
- More issues stand for both good and bad sign but basically it indicates their activeness.
- Organization owned projects are, in most cases, more stable and robust than user owned projects.
- Size of the repository have complexed meanings but in practice, simpler code is better than the massive one if both are trying to achieve the same goal.

I made a simple tool to get you covered with the above guidelines.

# gh-compare

![screencast.gif](/uploads/screencast.gif)

[gh-compare](https://github.com/uetchy/gh-compare) is a simple terminal app to explore your candidates and aggregate a result into a nice-looking report.

```bash
npm install -g gh-compare
gh-compare facebook/react vuejs/vue riot/riot
```

![1xfd1gcrfntpft5bbu5s.png.jpeg](/uploads/1xfd1gcrfntpft5bbu5s.png.jpeg)

You will see the GitHub activities for each candidate at once.
It could help you to decide which library you would adopt!

Warmly welcome to any comments/ideas to improve `gh-compare`!