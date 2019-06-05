---
title: Electronアプリをコード署名してApple 公証 (Notary) を通過する手順
date: 2019-06-05 00:00:00 +09:00
---

electron-builderを利用してmacOS向けElectronアプリをコード署名し、公証を通過させます。

## Code Sign

アプリのコード署名は`electron-builder`によって自動で行われます。内部的には[electron-osx-sign](https://github.com/electron-userland/electron-osx-sign)が使用されます。

リリース用のアプリにコード署名をするには、Keychainに有効なDeveloper ID Certificateが格納されている必要があります。macOS Developer Certificateは開発用のコード署名のみ可能なので、アプリを配布する場合には必ずDeveloper ID Certificateが必要です。

まだ証明書を発行していない場合は、[Apple Developer](https://developer.apple.com/account/resources/certificates/list)で証明書の追加ウィザードに進み、**Developer ID Application**を選択して証明書を発行しKeychainに追加してください。

## Notarize

コード署名済みのアプリを[electron-notarize](https://github.com/electron-userland/electron-notarize)を使用してApple Notary Serviceに提出します。

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

- **appBundleId**: アプリのBundle IDです。`package.json`の`build.appId`と同じものを使います。
- **appPath**: `.app`の絶対パスを指定します。
- **appleId**: Apple Developerとして登録しているApple IDを指定します。
- **appleIdPassword**: Apple IDのパスワードです。2要素認証を必要としないパスワードが必要なので、[Apple ID](https://appleid.apple.com/#!&page=signin)にアクセスして**App-specific Password**を発行してください。
- **ascProvider**: Apple DeveloperのMembershipに記載されている**Team ID**を指定します。

### electron-builderのafterSignフック

electron-builderのafterSignフックを使用して、コード署名が済んだアプリを自動でNotaryに提出します。

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

### Enable Hardened Runtime

このままでは公証に失敗します。デフォルトで書き出されるバイナリでは、セキュリティの強化された[Hardened Runtime](https://developer.apple.com/documentation/security/hardened_runtime_entitlements)が有効になっていないためです。以下のようなエラーメッセージを貰います。

```jsonc
{
  // ...
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

`package.json`の`build.mac.hardenedRuntime`を`true`にしてHardened Runtimeを有効にすることでこの問題を解決します。

```json
"build": {
  "mac": {
    "hardenedRuntime": true
  }
}
```

### 詳細

- https://developer.apple.com/documentation/security/notarizing_your_app_before_distribution/resolving_common_notarization_issues
- https://github.com/electron-userland/electron-builder/issues/3383

## Verify Notary Status

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

`xcrun altool --notarization-info`コマンドにUUIDとApple ID、パスワードを指定して公証ステータスを確認します。

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

