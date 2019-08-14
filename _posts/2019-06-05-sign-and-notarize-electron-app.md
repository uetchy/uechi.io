---
title: Electronアプリをコード署名してApple 公証 (Notary) を通過させる方法
date: 2019-06-05 00:00:00 +09:00
redirect_from: "/blog/2019/06/05/sign-and-notarize-electron-app"
---

electron-builder を利用して macOS 向け Electron アプリをコード署名し、公証を通過させます。

> **tl;dr**: コード署名と公証に対応した macOS アプリ Juno のリポジトリを[GitHub で公開](https://github.com/uetchy/juno)しています

# Code Sign

アプリのコード署名は`electron-builder`によって自動で行われます。内部的には[electron-osx-sign](https://github.com/electron-userland/electron-osx-sign)が使用されます。

リリース用のアプリにコード署名をするには、Keychain に有効な Developer ID Certificate が格納されている必要があります。macOS Developer Certificate は開発用のコード署名のみ可能なので、リリース用としては不十分です。

まだ証明書を発行していない場合は、[Apple Developer](https://developer.apple.com/account/resources/certificates/list)で証明書の追加ウィザードに進み、**Developer ID Application**を選択して証明書を発行してください。

# Notarize

コード署名済みのアプリを[electron-notarize](https://github.com/electron-userland/electron-notarize)を使用して Apple Notary Service に提出します。

```js
const { notarize } = require('electron-notarize')
notarize({
  appBundleId,
  appPath,
  appleId,
  appleIdPassword,
  ascProvider,
})
```

- **appBundleId**: アプリの Bundle ID です。`package.json`の`build.appId`と同じものを使います。
- **appPath**: `.app`の絶対パスを指定します。
- **appleId**: Apple Developer として登録している Apple ID を指定します。
- **appleIdPassword**: Apple ID のパスワードです。2 要素認証を必要としないパスワードが必要なので、[Apple ID](https://appleid.apple.com/#!&page=signin)にアクセスして**App-specific Password**を発行してください。
- **ascProvider**: Apple Developer の Membership に記載されている**Team ID**を指定します。

## electron-builder の afterSign フック

electron-builder の afterSign フックを使用して、コード署名が済んだアプリを自動で Notary に提出します。

フックスクリプトを`./scripts/after-sign-mac.js`に置きます。

```js
const path = require('path')
const { notarize } = require('electron-notarize')

const appleId = process.env.APPLE_ID
const appleIdPassword = process.env.APPLE_PASSWORD
const ascProvider = process.env.ASC_PROVIDER

const configPath = path.resolve(__dirname, '../package.json')
const appPath = path.resolve(__dirname, '../dist/mac/App.app')
const config = require(configPath)
const appBundleId = config.build.appId

async function notarizeApp() {
  console.log(`afterSign: Notarizing ${appBundleId} in ${appPath}`)
  await notarize({
    appBundleId,
    appPath,
    appleId,
    appleIdPassword,
    ascProvider,
  })
  console.log('afterSign: Notarized')
}

exports.default = async () => {
  await notarizeApp()
}
```

`package.json`の`build`に`afterSign`を追加してコード署名が終わった後にスクリプトが実行されるようにします。

```json
"build": {
  "afterSign": "./scripts/after-sign-mac.js"
}
```

## Hardened Runtime and Entitlements

このままでは公証に失敗します。デフォルトで書き出されるバイナリでは、セキュリティの強化された[Hardened Runtime](https://developer.apple.com/documentation/security/hardened_runtime_entitlements)が有効になっていないためです。以下のようなエラーメッセージを貰います。

```json
{
  "status": "Invalid",
  "statusSummary": "Archive contains critical validation errors",
  "statusCode": 4000,
  "issues": [
    {
      "severity": "error",
      "code": null,
      "path": "App.zip/App.app/Contents/MacOS/App",
      "message": "The executable does not have the hardened runtime enabled.",
      "docUrl": null,
      "architecture": "x86_64"
    },
  }
}
```

`package.json`の`build.mac.hardenedRuntime`を`true`にして Hardened Runtime を有効にします。

```json
"build": {
  "mac": {
    "hardenedRuntime": true
  }
}
```

Hardened Runtime 下では、必要に応じて Entitlement を指定しなくてはなりません。Electron の実行には`allow-unsigned-executable-memory`という Entitlement が必要なので、`entitlement.plist`ファイルを`build`フォルダに作成し、以下のような plist を記述します。

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
  <dict>
    <key>com.apple.security.cs.allow-unsigned-executable-memory</key>
    <true/>
  </dict>
</plist>
```

`package.json`の`entitlements`及び`entitlementsInherit`に Entitlment が記述された plist のファイルパスを指定します。

```json
"build": {
  "mac": {
    "hardenedRuntime": true,
    "entitlements": "./src/build/entitlement.plist",
    "entitlementsInherit": "./src/build/entitlement.plist"
  }
}
```

Hardened Runtime で Electron を実行することができるようになったので、Notary を通過できる状態になりました。

実際に`electron-builder`を実行してすべてのプロセスが上手く動作することを確かめてください。

# Verify Notary Status

ただしく公証を得られたかどうかは`altool`で調べることができます。

公証通過後に送られてくるメールに`Request Identifier`が記載されているのでメモします。

```
Dear Yasuaki,

Your Mac software has been notarized. You can now export this software and distribute it directly to users.

Bundle Identifier: <Bundle ID>
Request Identifier: <UUID>

For details on exporting a notarized app, visit Xcode Help or the notarization guide.
Best Regards,
Apple Developer Relations
```

`xcrun altool --notarization-info`コマンドに UUID と Apple ID、パスワードを指定して公証ステータスを確認します。

```
xcrun altool --notarization-info <UUID> -u $APPLE_ID -p $APPLE_PASSWORD
```

正しく公証が得られている場合は以下のようなメッセージが表示されます。おめでとうございます！

```
2019-06-05 13:51:18.236 altool[5944:261201] No errors getting notarization info.

   RequestUUID: <UUID>
          Date: 2019-06-05 04:45:54 +0000
        Status: success
    LogFileURL: https://osxapps-ssl.itunes.apple.com/itunes-assets/Enigma123/v4/<Log file identifier>
   Status Code: 0
Status Message: Package Approved
```

## 参考文献

- [Resolving Common Notarization Issues](https://developer.apple.com/documentation/security/notarizing_your_app_before_distribution/resolving_common_notarization_issues)
- [Notarizing your Electron application](https://kilianvalkhof.com/2019/electron/notarizing-your-electron-application/)
- [Feature request: Enable hardened runtime for macOS #3383](https://github.com/electron-userland/electron-builder/issues/3383)
