---
title: RSA
---

http://inaz2.hatenablog.com/entry/2013/11/27/225953

```
openssl genrsa 32 > key.pem
openssl rsa -text < key.pem
```

```
modulus: 2608173289 (0x9b7590e9)
publicExponent: 65537 (0x10001)
privateExponent: 1888610089 (0x7091e729)
prime1: 52223 (0xcbff)
prime2: 49943 (0xc317)
exponent1: 1459 (0x5b3)
exponent2: 3417 (0xd59)
coefficient: 17568 (0x44a0)
```

$$\text{modulus} = \text{prime1} \cdot \text{prime2}$$

publicExponent は $(\text{prime1} - 1)(\text{prime2} - 1)$ とお互いに素な数から選ぶ。65537 で固定、なぜなら二進数で 10000000000000001 となり、ビットがあまり立っておらず計算が早いため。

privateExponent は $\text{publicExponent}^{-1} \text{mod} (\text{prime1} - 1)(\text{prime2} - 1)$

## 中国の余剰定理

[定理の詳細](https://ja.wikipedia.org/wiki/中国の剰余定理)

$$\text{exponent1} = \text{privateExponent} \pmod{\text{prime1} - 1}$$

$\text{exponent2} = \text{privateExponent} \pmod{\text{prime2} - 1} $

$ \text{coefficient} = \text{prime2}^{-1} \pmod{\text{prime1}} $

これらは復号の簡単化のために用意された係数である。

## 公開鍵の中身

```
openssl rsa -pubout < key.pem > pub.pem
openssl rsa -text -pubin < pub.pem
```

```
Modulus: 2608173289 (0x9b7590e9)
Exponent: 65537 (0x10001)
```

## 暗号

$ \text{source}^\text{publicExponent} \pmod{\text{modulus}} = \text{encryptedText} $

## 復号

$ \text{encryptedText}^\text{privateExponent} \mod \text{modulus} $

# Diffie-Helmann 鍵共有

## 一方向性関数

$ \mathrm{G}^x \mod \mathrm{P} = y $

右辺を求めるのは簡単だが、余り$y$から$x$を求めるのは難しい。

この性質を利用して、$x$に秘密情報を与えて交換することで第三者による復号を防げる。

A は$G^A \mod P$を B に送信
→$(G^A \mod P)^B \mod P = (G^{A \cdot B}) \mod P$

B は$G^B \mod P$を A に送信
→$ (G^B \mod P)^A \mod P = (G^{B \cdot A}) \mod P$

以下の法則を使用しているため、お互いに同一の結果を得られる。

$ (G^A)^B = G^{A \cdot B}$
