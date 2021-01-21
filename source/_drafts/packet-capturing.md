---
title: パケットキャプチャリング
---

- macOS Mojave では、Wi-Fi をオフにしていないと Monitor モードでスキャンしてもパケットが受信できない。
- Preferences > Protocols > IEEE 802.11 で Decrypt Keys を保存する。wpa-psk でハッシュ化された値を保存したほうが安全である。保存先は`.config/wireshark`
- 暗号化された 802.11 通信を覗くには 4-ways handshake (EAPOL)を観測する必要がある。そのためには対象デバイスの Wi-Fi をトグルすれば良い。

## コマンド

```
tcpdump -i en0 -I
```

で tcp ダンプ

```
/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -I
```

で現在接続しているネットワークの情報を取得

# Charles

1. Charles で`Proxy > Proxy Settings`を開き、HTTP Proxy の Port を選ぶ。
2. Enable transparet HTTP proxying にチェックする
3. Charles 上で`Help > SSL Proxying > Install Charles Root Certificate on a Mobile Device or Remote Browsers`をクリックし、表示されているアドレスとポートを iOS の`Settings > Wi-Fi > 任意のAP > Proxy`に入力する。
4. iOS で`chls.pro/ssl`にアクセスし、プロファイルをインストール
5. `Settings > General > About > Certificate Trust Settings`で Charles の証明書を信用する。
