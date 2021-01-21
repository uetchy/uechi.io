---
title: Build Chromium from zero
---

事前準備する。

```
brew install cache
git config --global core.precomposeUnicode true
```

ソースコードを手に入れる。

```shell
ghq get https://chromium.googlesource.com/chromium/tools/depot_tools.git
cd `ghq root`/chromium.googlesource.com/chromium
fetch chromium
```

`.envrc` に以下を追加し、`direnv allow`で環境変数を適用する。

```shell
PATH_add `qhq root`/chromium.googlesource.com/chromium/tools/depot_tools
PATH_add src/third_party/llvm-build/Release+Asserts/bin
export CCACHE_CPP2=yes
export CCACHE_SLOPPINESS=time_macros
export SPACESHIP_GIT_SHOW=false
```

ビルドする。

```shell
cd src
gn gen out/Default --args='cc_wrapper="ccache"'
autoninja -C out/Default chrome
```
