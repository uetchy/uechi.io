---
title: Securing Local Dev Server
date: 2020-02-07 00:00:00 +0900
---

Sometimes you want to interact with a local webserver with https support because of some browser APIs that are only available in an https environment.

You can easily create a self-signed TLS cert for development purposes with [`mkcert`](https://github.com/FiloSottile/mkcert).

```bash
brew install mkcert
mkcert -install # Install the local CA in the OS keychain
```

After installing `mkcert` and generating system-wide local CA cert, you can create a certificate for each project.

```bash
cd awesome-website
mkcert localhost # this will generate ./localhost.pem and ./localhost-key.pem
npm install -g serve
serve --ssl-cert ./localhost.pem --ssl-key ./localhost-key.pem
```
