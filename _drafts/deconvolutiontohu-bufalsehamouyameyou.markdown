---
title: Deconvolutionと呼ぶのはもうやめよう
date: 2017-03-05 13:44:00 +09:00
---

深層学習において、Convolutional Layer (畳み込み層)とは、あるシェイプのテンソルをそれ以下のサイズに縮約する性質のレイヤーです。一方で Deconvolution Layer (逆畳み込み層)とは、[Jonathan Long, et al](https://arxiv.org/abs/1411.4038)の論文で提案されたレイヤーで、あるシェイプのテンソルをそれ以上のサイズに拡大する性質を持ちます。

ところが実際のところ、このレイヤーは Transposed Convolution Layer (転置畳み込み層)と呼ぶべきです。なぜかを以下に示します。

> Upsampling is backwards strided convolution. (アップサンプリングは

[Stack Exchange](http://datascience.stackexchange.com/questions/6107/what-are-deconvolutional-layers)での議論を踏まえると
