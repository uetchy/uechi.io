---
title: Take control of Chrome with Myo Armband
date: 2014-12-16 09:00:00 +09:00
redirect_from: "/blog/2014/12/16/myo-armband"
---

Thalmic Labs の MYO アームバンドが届いたので Google Chrome をマイノリティ・リポートっぽいジェスチャーで操作する Myo Scripts を書いてみる。

### 主な情報源

- <https://developer.thalmic.com/start/>
- <https://www.thalmic.com/blog/tag/myo-scripting-basics/>
- <https://developer.thalmic.com/docs/api_reference/platform/script-tutorial.html>

# 基本

Lua で記述し、拡張子は**.myo**を使う。

作成したスクリプトは Myo Connect を経由してアームバンドとやりとりをすることになる。

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

onForegroundWindowChange の返り値が**true**の場合、スクリプトをアクティブにする。つまり上のように書けば Google Chrome のウィンドウが最前面に出ている時だけスクリプトを有効化させることが出来る。

いかなる状況でもジェスチャーをハンドルしたい場合は以下のように書く。

```lua
function onForegroundWindowChange(app, title)
  return true
end
```

実際には、**親指と中指でダブルタップ** するジェスチャーを検知した後に、全ての Myo Scripts の onForegroundWindowChange を呼び出している。そして true が返ってきたスクリプトのみを実行している。

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

### pose の種類

| pose          | 意味                     |
| ------------- | ------------------------ |
| rest          | 安静時                   |
| fist          | 握り拳                   |
| fingersSpread | 手を開く                 |
| waveIn        | 手首を手前に曲げる       |
| waveOut       | 手首を手前とは逆に曲げる |
| doubleTap     | 中指と親指でダブルタップ |
| unknown       | 判別不能                 |

## onPeriodic()

```lua
function onPeriodic()
  roll = myo.getRoll()
  myo.debug(roll)
end
```

onPeriodic はスクリプトがアクティブな間ずっと呼ばれ続ける。常にアームバンドのジャイロ情報を取得してなんやかんやしたい時に使う。

# 実装

以上のハンドラーを駆使し作ってみる。
今回のように Google Chrome のスクロール操作をアームバンドのジェスチャーでやりたい場合、**onPeriodic** で`myo.getRoll()`メソッドを呼び出せば手首の回転する角度を取得出来るわけである。しかし、そのまま**onPeriodic**上にスクロールを行うコードを続けて書くと常にアームバンドの傾き具合でスクロールされてしまい困る。

そこで、「握り拳を握っている間だけ手首の傾きによってウェブページをスクロールさせる」ようにする。

## 握り拳を握っている間だけ手首の傾きによってウェブページをスクロールさせる

初めにグローバルで `enableScroll` 変数を宣言し、false で初期化する。

```lua
enableScroll = false
```

そして、onPoseEdge に握り拳が握られると enableScroll を true に、戻ると false にするコードを書く。

```lua
function onPoseEdge(pose, edge)
  if pose == 'fist' and edge == 'on' then
    enableScroll = true
  elseif pose == 'fist' and edge == 'off' then
    enableScroll = false
  end
end
```

最後に onPeriodic で手首の角度を取得してキーボードの ↑ か ↓ を連打するコードを書く。

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

実際にこのスクリプトを動かしてみると上手くスクロールしない。myo.getRoll()で取得した角度は絶対的な角度だからだ。握り拳が作られた瞬間の角度を 0 として扱った方がプログラムの見通しも良くなる。

そこで新たに initRoll 変数をグローバルで宣言する。そして onPoseEdge を以下のように修正する。

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

続けて onPeriodic の

```lua
roll = myo.getRoll()
```

を、

```lua
roll = myo.getRoll() - initRoll
```

に修正する。

これで、絶対角度を握り拳が握られた瞬間の手首の角度を 0 とする相対角度を取得出来る。

実際に動くスクリプトを Github で[公開している](https://github.com/uetchy/myo-scripts)。

### 番外編

Myo C++ SDK を使ってアイアンマンみたいなジェスチャーでレーザーガンを撃った気分になれるアプリを作った。

[uetchy/myo-gun](https://github.com/uetchy/myo-gun)
