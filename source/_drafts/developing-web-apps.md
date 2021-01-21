---
title: Developing Web Apps in One Minutes
---

## 0. Setup Homebrew and Node

```
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

```
brew install node
```

## 1. Scaffold from template

```
npx express-generator --view=pug awesome-app
cd awesome-app
npm install
npm start
```

## 2. Deploy with Now

```
npm install -g now
now login
now --public
```
