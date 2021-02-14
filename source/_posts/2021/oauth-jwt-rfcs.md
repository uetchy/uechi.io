---
title: OAuth 2.0 と JWT 関連 RFC
date: 2021-02-11
---

個人的な調査のために OAuth 2.0 と JWT 関連 RFC を発行日順に並べています。

## [RFC6749](https://tools.ietf.org/html/rfc6749) — The OAuth 2.0 Authorization Framework

2012 年 10 月

OAuth 1.0a に代わる新たな認証基盤 OAuth 2.0 のコアを規定しており、特筆すべき点がいくつかある。

- `access_token` の内容は規定されておらず、ベンダーに委ねられている
  - JWS でもなんでもいい
- リソースサーバーに `access_token` を渡す方法は規定されていない（同月発行の RFC6750 で規定された）

### Authorization Grant

トークンエンドポイントで`access_token`を発行してもらう際に使用できる Grant (許可証)は、提案中の拡張仕様を含めて 5 つある。

1. Authorization Code Grant: [RFC6749 – Section 1.3.1](https://tools.ietf.org/html/rfc6749#section-1.3.1)
   1. `grant_type=authorization_code`
   2. Authorization Code Grant with PKCE
2. Implicit Flow: [RFC6749 – Section 1.3.2](https://tools.ietf.org/html/rfc6749#section-1.3.2)
   1. もともと CORS (Cross Origin Resource Sharing) が登場する以前の SPA で、POST リクエストを回避しつつ Access Token を得る"妥協案"として策定された
   2. CSRF 耐性が無い ([RFC6819 - Section 4.4.2.5](https://tools.ietf.org/html/rfc6819#section-4.4.2.5))ため、使うべきではない
3. Resource Owner Password Credentials Grant: [RFC6749 – Section 1.3.3](https://tools.ietf.org/html/rfc6749#section-1.3.3)
   1. 直接パスワードで認証する形式
4. Client Credentials Grant: [RFC6749 – Section 1.3.4](https://tools.ietf.org/html/rfc6749#section-1.3.4)
   1. クライアントシークレットでトークンを取得する形式。
5. Device Grant: [RFC Draft — OAuth 2.0 Device Authorization Grant](https://tools.ietf.org/html/draft-ietf-oauth-device-flow-15)
   1. 入力機器が無い場合もある組み込みデバイス向けの認証フロー

## [RFC6750](https://tools.ietf.org/html/rfc6750) — The OAuth 2.0 Authorization Framework: Bearer Token Usage

2012 年 10 月

OAuth 2.0 において、`access_token`をリソースサーバーに渡す手法を規定する。OAuth 2.0 JWT Bearer Token Flow**ではない**。

手法として 3 つが挙げられている。

1. Bearer Token (**SHOULD**)
2. Form Encoded Parameters (SHOULD NOT)
3. URI Query Parameters (SHOULD NOT)

## [OICD](https://openid.net/specs/openid-connect-core-1_0.html) — OpenID Connect Core 1.0

2014 年 11 月

OAuth 2.0 の上にいくつか仕様を足したサブセット。

## [RFC7515](https://tools.ietf.org/html/rfc7515) — JSON Web Signature (JWS)

2015 年 5 月

JSON ベースの署名プロトコル。

## [RFC7516](https://tools.ietf.org/html/rfc7516) — JSON Web Encryption (JWE)

2015 年 5 月

JSON ベースの暗号化プロトコル。

## [RFC7517](https://tools.ietf.org/html/rfc7517) — JSON Web Key (JWK)

2015 年 5 月

JWT の署名チェックに用いる公開鍵を配信するためのプロトコル。

## [RFC7518](https://tools.ietf.org/html/rfc7518) — JSON Web Algorithms (JWA)

2015 年 5 月

JWS、JWE、JWK で利用されるアルゴリズム (alg)やその他プロパティを規定する。

## [RFC7519](https://tools.ietf.org/html/rfc7519) — JSON Web Token (JWT)

2015 年 5 月

JWT は JSON を利用して Assertion を生成するための仕様。

## [RFC7521](https://tools.ietf.org/html/rfc7521) — Assertion Framework for OAuth 2.0 Client Authentication and Authorization Grants

2015 年 5 月

任意の Assertion を OAuth 2.0 Client Authentication の Client Credentials として使ったり、あるいは Authorization Grant として Access Token と交換するための仕様。

トークンエンドポイントに強化されたクライアント認証を付与する。続く RFC で、それぞれ SAML と JWT を使用したパターンを規定している。

**OAuth 2.0 JWT Bearer Token Flow**とも呼ばれている。

- [RFC7522](https://tools.ietf.org/html/rfc7522) — Security Assertion Markup Language (**SAML**) 2.0 Profile for OAuth 2.0 Client Authentication and Authorization Grants (2015 年 5 月)
- [RFC7523](https://tools.ietf.org/html/rfc7523) — JSON Web Token (**JWT**) Profile for OAuth 2.0 Client Authentication and Authorization Grants (2015 年 5 月)

2015 年 5 月 https://tools.ietf.org/html/rfc7523

## [RFC Draft](https://tools.ietf.org/html/draft-ietf-oauth-access-token-jwt-02) — JSON Web Token (JWT) Profile for OAuth 2.0 Access Tokens

2019 年 7 月

リソースサーバーへ渡す Access Token に JWT を使用することを定めている。
