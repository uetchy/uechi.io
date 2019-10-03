---
title: プログラムの速度改善が誤差かどうかを統計的に調べる
date: 2019-10-03 17:21:00 +09:00
---

**Welch の t 検定**を用いて 2 つのベンチマークの分布の平均が等しい（速度差は誤差の範疇）か、あるいは異なる（=有意な速度改善が成されている）かどうかを判定します。

ベンチマーク用のTypeScriptプログラムを用意します。

#### `a.ts`

```ts
function a() {
  const noise = Math.random() - 0.5;
  const offset = 1.0;
  const t = noise * 2 + offset;
  setTimeout(() => console.log(t), t * 1000);
}
a();
```

#### `b.ts`

```ts
function b() {
  const noise = Math.random() - 0.5;
  const offset = 2.0;
  const t = noise * 2 + offset;
  setTimeout(() => console.log(t), t * 1000);
}
b();
```

まず[hyperfine](https://github.com/sharkdp/hyperfine)で 2 つの プログラムのベンチマークを取り、`result.json`に保存します。

```shell
hyperfine 'ts-node a.ts' 'ts-node b.ts' -r 50 --warmup 3 --export-json ab.json 
```

`result.json`の中身以下のようになります。t検定はサンプルが正規分布に従っているという仮定を置いているので、大数の法則から本当はもっと試行回数を増やした方が良いです。

```json
{
  "results": [
    {
      "command": "ts-node a.ts",
      "mean": 1.9369869248950002,
      "stddev": 0.6074252496423262,
      "median": 2.005230080295,
      "user": 1.549546345,
      "system": 0.08031985000000001,
      "min": 0.8807363742950001,
      "max": 2.830435366295,
      "times": [
        1.4010462692949999,
        2.830435366295,
        1.010024359295,
        1.159667609295,
        1.8311979602950001,
        ...
      ]
    },
    {
      "command": "ts-node b.ts",
      "mean": 2.833931665055,
      "stddev": 0.6505564501747996,
      "median": 2.7373719187950005,
      "user": 1.5474132649999999,
      "system": 0.07978893000000001,
      "min": 1.938184970295,
      "max": 3.946562622295,
      "times": [
        2.2806011012950003,
        2.0140897212950004,
        2.1835023382950003,
        2.304886362295,
        3.8122057912950003,
        ...
      ]
    }
  ]
}
```

この`result.json`の`times`配列を受け取り、2 つの分布間に有意差があるかどうかを判定します。

```ts
import fs from 'fs';
import {jStat} from 'jstat';

const log = console.log;

const sum = (x: number[]) => x.reduce((a: number, b: number) => a + b); // 総和
const sqsum = (x: number[], mu: number) =>
  x.reduce((a: number, b: number) => a + (b - mu) ** 2); // 自乗誤差の総和

function ttest(X: number[], Y: number[]) {
  const Xn = X.length; // サンプル数
  const Yn = Y.length;
  log(`Xn = ${Xn}`);
  log(`Yn = ${Yn}`);

  const X_mu = sum(X) / Xn; // 平均
  const Y_mu = sum(Y) / Yn;
  log(`X_mu = ${X_mu}`);
  log(`Y_mu = ${Y_mu}`);

  const X_sigma = sqsum(X, X_mu) / (Xn - 1); // 不偏分散
  const Y_sigma = sqsum(Y, Y_mu) / (Yn - 1);
  log(`X_sigma = ${X_sigma}`);
  log(`Y_sigma = ${Y_sigma}`);
  const t = (X_mu - Y_mu) / Math.sqrt(X_sigma / Xn + Y_sigma / Yn); // t値
  log(`t = ${t}`);
  const df =
    (X_sigma + Y_sigma) ** 2 /
    (X_sigma ** 2 / (Xn - 1) + Y_sigma ** 2 / (Yn - 1)); // 自由度
  log(`df = ${df}`);
  return jStat.studentt.cdf(-Math.abs(t), df) * 2.0; // p値
}

const filename = process.argv.slice(2)[0];
const result = JSON.parse(fs.readFileSync(filename).toString());
const X = result.results[0].times;
const Y = result.results[1].times;
const p = ttest(X, Y);
log(`p = ${p}`);
log(`p < 0.05 = ${p < 0.05}`);
log(p < 0.05 ? 'Possibly some difference there' : 'No difference');
```

ここで`X_mu`は分布Xの平均、`X_sigma`は分布Xの不偏分散です。
$$
\begin{eqnarray}
\mu_X &=& \frac{1}{n_X} \sum^{n_X}_i X_i\\
\sigma_X &=& \frac{1}{n_X-1}\sum^{n_X}_i (X_i - \mu_X)^2
\end{eqnarray}
$$
これをXとY両方に対して求めます。さらに以下のようにしてtを求めます。
$$
t = \frac{\mu_X - \mu_Y}{\sqrt{\frac{\sigma_X}{n_X} + \frac{\sigma_Y}{n_Y}}}
$$

t分布の累積密度関数 (Cumlative Distribution Function; CDF) を定義します。面倒すぎたので[jstat](https://github.com/jstat/jstat)の`studentt.cdf`を使ってます。コードを見ると、分子の積分は[シンプソンの公式](https://ja.wikipedia.org/wiki/シンプソンの公式)を使って近似していました。

$$
\text{CDF} =\frac{\int_0^{\frac{v}{t^2+v}}\frac{r^{\frac{v}{2}-1}}{\sqrt{1-r}}dr{}}{\text{exp}(\ln(\Gamma(\frac{v}{2}))+\ln(\Gamma(0.5))+\ln(\Gamma(\frac{v}{2}+0.5)))}
$$

CDFを用いてp値を求めます。両側検定をするので2を掛けます。t分布の自由度 (degree of freedom; df) は$n-1$なので、両分布の自由度を$n_X+n_Y-2$で与えます。本当は
$$
\text{df} = \frac{(\sigma_X + \sigma_Y)^2}{
    \frac{\sigma_X^2}{n_X - 1} + \frac{\sigma_Y^2}{n_Y - 1}}
$$
で求める必要がありますが、さぼって近似しました。
$$
p = \text{CDF}(-|t|, n_X+n_Y-2) \times2
$$

## 結果

異なる実行時間を示すプログラム`a`,`b`を比較すると、2つの分布の平均が異なることが示唆されました。

```
❯ ts-node test.ts ab.json
Xn = 10
Yn = 10
X_mu = 1.8022945422950003
Y_mu = 2.9619571628950006
X_sigma = 0.6067285795623545
Y_sigma = 0.6593856215802901
t = -3.2590814831310353
df = 17.968919419652778
-0.0001571394779906754
p = 0.004364964634417297
p < 0.05 = true
Possibly some difference there
```

p値が0.05未満となり、帰無仮説「２つの分布は等しい」が棄却されたので「２つの分布は等しくない」ことがわかりました。同じプログラム同士でベンチマークを取るとどうなるでしょうか。

```
❯ ts-node test.ts aa.json
Xn = 10
Yn = 10
X_mu = 1.7561671737900002
Y_mu = 1.9892996860899999
X_sigma = 0.5127362786380443
Y_sigma = 0.442053230382934
t = -0.754482245774979
df = 17.901889803947558
-27359.526584574112
p = 0.4603702896905685
p < 0.05 = false
No difference
```

p値が0.05未満ではないので、帰無仮説は棄却されず、つまり「２つの分布は等しい」ことがわかりました。

ウェルチのt検定はスチューデントのt検定と違って等分散性（２つの分布の分散が等しいこと）を仮定しないので、とても取り扱いやすい検定です。もちろん等分散性のある分布でも使用できるので、基本的にはウェルチの方法を使う方針で良さそうです。

## 参考文献

- [Welch's t-test - Rosetta Code](https://rosettacode.org/wiki/Welch%27s_t-test)