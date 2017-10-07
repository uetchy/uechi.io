---
title: Take control of Chrome with Myo Armband
date: 2014-12-16 09:00:00 +09:00
---

Thalmic LabsのMYOアームバンドが届いたのでGoogle Chromeをマイノリティ・リポートっぽいジェスチャーで操作するMyo Scriptsを書いてみる。

### 主な情報源

- <https://developer.thalmic.com/start/>
- <https://www.thalmic.com/blog/tag/myo-scripting-basics/>
- <https://developer.thalmic.com/docs/api_reference/platform/script-tutorial.html>

# 基本

Luaで記述し、拡張子は__.myo__を使う。

作成したスクリプトはMyo Connectを経由してアームバンドとやりとりをすることになる。

> デバッグコマンドとして`myo.debug(obj)`が用意されている。

## scriptId

スクリプトを識別するための`scriptId`は必ず書かなければならない。

```lua
scriptId = 'co.randompaper.myo.chrome'
```

## onForegroundWindowChange(app, title)

```lua
function onForegroundWindowChange(app, title)
  return app == "com.google.Chrome"
end
```

onForegroundWindowChangeの返り値が__true__の場合、スクリプトをアクティブにする。つまり上のように書けばGoogle Chromeのウィンドウが最前面に出ている時だけスクリプトを有効化させることが出来る。

いかなる状況でもジェスチャーをハンドルしたい場合は以下のように書く。

```lua
function onForegroundWindowChange(app, title)
  return true
end
```

実際には、__親指と中指でダブルタップ__ するジェスチャーを検知した後に、全てのMyo ScriptsのonForegroundWindowChangeを呼び出している。そしてtrueが返ってきたスクリプトのみを実行している。

アクティブになったスクリプトは一定時間が経過してアームバンドがロックされるまでイベントハンドラーが呼ばれ続ける。

## onPoseEdge(pose, edge)

スクリプトがアクティブになっている間に行われたジェスチャーをハンドルするメソッド。

```lua
function onPoseEdge(pose, edge)
  if pose == 'fist' and edge == 'on' then
    myo.debug("グー")
  elseif pose == 'fist' and edge == 'off' then
    myo.debug("グーじゃなくなった")
  end
end
```

### poseの種類

|pose|意味|
|----|---|
|rest|安静時|
|fist|握り拳|
|fingersSpread|手を開く|
|waveIn|手首を手前に曲げる|
|waveOut|手首を手前とは逆に曲げる|
|doubleTap|中指と親指でダブルタップ|
|unknown|判別不能|

## onPeriodic()

```lua
function onPeriodic()
  roll = myo.getRoll()
  myo.debug(roll)
end
```

onPeriodicはスクリプトがアクティブな間ずっと呼ばれ続ける。常にアームバンドのジャイロ情報を取得してなんやかんやしたい時に使う。

# 実装

以上のハンドラーを駆使し作ってみる。
今回のようにGoogle Chromeのスクロール操作をアームバンドのジェスチャーでやりたい場合、__onPeriodic__ で`myo.getRoll()`メソッドを呼び出せば手首の回転する角度を取得出来るわけである。しかし、そのまま__onPeriodic__上にスクロールを行うコードを続けて書くと常にアームバンドの傾き具合でスクロールされてしまい困る。

そこで、「握り拳を握っている間だけ手首の傾きによってウェブページをスクロールさせる」ようにする。

## 握り拳を握っている間だけ手首の傾きによってウェブページをスクロールさせる

初めにグローバルで `enableScroll` 変数を宣言し、falseで初期化する。

```lua
enableScroll = false
```

そして、onPoseEdgeに握り拳が握られるとenableScrollをtrueに、戻るとfalseにするコードを書く。

```lua
function onPoseEdge(pose, edge)
  if pose == 'fist' and edge == 'on' then
    enableScroll = true
  elseif pose == 'fist' and edge == 'off' then
    enableScroll = false
  end
end
```

最後に onPeriodic で手首の角度を取得してキーボードの↑か↓を連打するコードを書く。

```lua
function onPeriodic()
  if enableScroll then
    roll = myo.getRoll()

    key = ''

    if roll < -0.05 then
      key = 'up_arrow'
    elseif roll > 0.05 then
      key = 'down_arrow'
    end

    if key ~= '' then
      myo.keyboard(key, 'press')
    end
  end
end
```

実際にこのスクリプトを動かしてみると上手くスクロールしない。myo.getRoll()で取得した角度は絶対的な角度だからだ。握り拳が作られた瞬間の角度を0として扱った方がプログラムの見通しも良くなる。

そこで新たにinitRoll変数をグローバルで宣言する。そしてonPoseEdgeを以下のように修正する。

```lua
function onPoseEdge(pose, edge)
  if pose == 'fist' and edge == 'on' then
    initRoll = myo.getRoll()
    enableScroll = true
  elseif pose == 'fist' and edge == 'off' then
    enableScroll = false
  end
end
```

続けてonPeriodicの

```lua
roll = myo.getRoll()
```

を、

```lua
roll = myo.getRoll() - initRoll
```

に修正する。

これで、絶対角度を握り拳が握られた瞬間の手首の角度を0とする相対角度を取得出来る。

実際に動くスクリプトをGithubで[公開している](https://github.com/uetchy/myo-scripts)。

### 番外編

Myo C++ SDKを使ってアイアンマンみたいなジェスチャーでレーザーガンを撃った気分になれるアプリを作った。

[uetchy/myo-gun](https://github.com/uetchy/myo-gun)
