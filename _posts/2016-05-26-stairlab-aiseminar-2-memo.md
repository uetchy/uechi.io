---
title: ステアラボ人工知能セミナー#2 メモ
date: 2016-05-26 09:00:00 +09:00
redirect_from: /blog/2016/05/26/stairlab-aiseminar-2-memo
---

走り書きです。

<https://stairlab.doorkeeper.jp/events/44958>

> 第 2 回目の今回は、機械学習の研究者で、トピックモデル (機械学習プロフェッショナルシリーズ)の著者でもある、NTT コミュニケーション科学基礎研究所の[岩田具治](http://www.kecl.ntt.co.jp/as/members/iwata/index-j.html)先生をお招きし、「教師なしオブジェクトマッチング」というタイトルで、先生の最近の研究について講演していただきます。

- 教師なし学習

  - PCA が主流
  - t-SNE で次元削減してプロット

- 教師ありオブジェクトマッチング

  - 異なるドメインに含まれる事例間の対応を見つけるタスク
  - [正準相関分析](http://ibisforest.org/index.php?正準相関分析)
    - 正解対応データが低次元潜在空間で同じ位置に埋め込まれるよう、線形写像を学習する
    - テスト時には、低次元潜在空間上で近くに配置されたデータが類似していると判定する
  - 問題点
    - 対応データが必要（対訳等）
    - 対応データが入手困難・不可能な状況もある
      - プライバシーの保護
      - データの入手目的や方法が異なる
      - 人手による対応付けコストが高い

- 教師なしオブジェクトマッチング

  - ドメイン間のオブジェクトの距離は測れない
    - ドメイン内のオブジェクト間の距離の相対的な関係を見てマッチングする

- 教師なしクラスタマッチング

  - 異なるドメイン間のクラスタの対応を教師なしで見つける

- 提案 : 教師なしクラスタマッチングのための潜在変数モデル

  1.  各ドメインのデータを共通の低次元潜在空間へ埋め込む
  2.  潜在空間でクラスタリング
  3.  同じクラスタになったオブジェクトが対応

- 確率的生成モデルによるクラスタリング

  - データが生成される過程を確率を用いて定義
    - 実際にはデータが与えられる
  - データを生成したもっともらしいクラスタを推論
  - 利点
    - 不確実性を考慮できる
    - 確率論の枠組みで異種データを統合できる

- 混合定期分布によるクラスタリング

  - k-means の確率版
  - 生成過程
    - クラスタ毎の平均は $\{\mu_1, \mu_2, … \mu_k\}$
    - For オブジェクト $n = 1, …, N$
      - クラスタ割り当てを決める$S_n \sim Categorical(\theta)$

- 教師なしクラスタマッチング生成モデル

  - [無限混合正規分布](http://www.nejicolab.com/akip/?p=160)
    `$$ p(X_{dn}|Z,W,\theta) = \sum^\infty_{j=1}{\theta_j N(x_{dn}|W_d z_j, \alpha^{-1} I)} $$`

- 特徴
  - ディリクレ過程を用いて無限個のクラスタを想定
  - 異なるドメインのオブジェクトを共通のクラスタに割り当てできる
  - ドメイン毎に異なる特徴次元や統計的性質を考慮できる
  - ドメイン毎に異なるオブジェクト数でも良い
- 確率的 EM アルゴリズム
  - E ステップ : クラスタ割り当て s を gibbs サンプリング
  - M ステップ : 写像行列 W を最尤推定
  - 潜在ベクトル z、クラスタ割り当て$\theta$、精度$\alpha$は解析的に積分消去
- [Adjusted Rand index](http://y-uti.hatenablog.jp/entry/2014/01/19/133936) (高いほど良い)
- 反教師あり
  - 少数の対応データが得られる場合もある
  - E ステップで対応データは必ず同じクラスタに割り当てられるとする
- 結論
  - 教師なしクラスタマッチング手法を提案
    - 対応データ不要
    - 多ドメイン、多対多、任意のオブジェクト数に対応

## ネットワークデータのための教師なしクラスタマッチング

- Find correspondence between clusters in multiple networks without node correspondence
- ReMatch
  - based on [Infinite Relational Models](http://qiita.com/takuti/items/8faf0e686cfbe68c2dfa) (IRM)
  - is IRM with a combined matrix
  - Rivals
    - IRM+KS
    - KS
    - MMLVM
  - AUC: abbr. Area Under the Curve

## 他言語文書データからの普遍文法の抽出

- Languages share certain common properties
  - word order in most European language is SVO
- Extract a common grammar from multilingual corpora
- Hierarchical Bayesian modeling
  - Probabilistic(Stochastic) context-free grammar (PCFG, SCFG) = 確率文脈自由文法

## 質疑応答

- トピックモデルよりも、一度ネットワークに落とし込んだ方が精度は良い
