---
title: 最小送金回数で精算する割り勘アルゴリズム
date: 2021-02-14
---

大人数でキャンプを楽しんだあとに待っているのは耐え難き送金処理です。
次回から楽をするために、送金回数を最小化する制約で精算表を作る方法を考えてみます。

# tl;dr

アイディアは「最も支払わなかった人が最も支払った人に払えるだけ払う ⇢ 債権を再計算して繰り返す」です。

1. 全員の出費を算出（払い過ぎは正、払わなさすぎは負の数）
2. 降順でソート（出費過多が先頭）
3. リストの最後（最大債務者, 出費=L）がリストの最初（最大債権者, F）に $\min(F, |L|)$ を支払ってバランスを再計算
4. 全員のバランスが 0 になるまで 2-3 を繰り返す

# 実験

実際にコードを書いて本当に望んでいる結果が得られるのかを検証します。

```5js
const history = [
  {
    amount: 121,
    payer: "A",
    involves: ["A", "B", "C"],
  },
  {
    amount: 98,
    payer: "B",
    involves: ["A", "B", "C"],
  },
  {
    amount: 10,
    payer: "C",
    involves: ["A", "B", "C"],
  },
  {
    amount: 10,
    payer: "C",
    involves: ["A", "B"],
  },
  {
    amount: 50,
    payer: "C",
    involves: ["A"], // meaning C lent A 50
  },
];

// calculate balance sheet
const init = { balance: 0, consumption: 0 };
Map.prototype.fetch = function (id) {
  return (
    this.get(id) || this.set(id, Object.assign({ name: id }, init)).get(id)
  );
};

const data = new Map();

for (const { payer, amount, involves } of history) {
  const record = data.fetch(payer);
  record.balance += amount;
  const dept = Math.ceil(amount / involves.length);
  // actual payer should not owe extra dept coming from rounded up numbers
  const payerDept = amount - dept * (involves.length - 1);
  for (const deptor of involves.map((i) => data.fetch(i))) {
    const cost = Math.round(amount / involves.length);
    deptor.balance -= cost;
    deptor.consumption += cost;
  }
}

console.log(data);

// calculate transaction table
const transaction = [];
let paidTooMuch, paidLess;
while (true) {
  for (const [_, tbl] of data) {
    if (tbl.balance >= (paidTooMuch?.balance || 0)) {
      paidTooMuch = tbl;
    }
    if (tbl.balance <= (paidLess?.balance || 0)) {
      paidLess = tbl;
    }
  }

  if (paidLess.balance == 0 || paidTooMuch.balance == 0) break;

  const amount = Math.min(paidTooMuch.balance, Math.abs(paidLess.balance));

  transaction.push({
    sender: paidLess.name,
    receiver: paidTooMuch.name,
    amount,
  });

  paidTooMuch.balance -= amount;
  paidLess.balance += amount;
}

console.log("Settled");

console.log("\n# Transaction table");
for (const ev of transaction) {
  console.log(`${ev.sender} owes ${ev.receiver} ¥${ev.amount}`);
}

console.log("\n# History");
for (const { payer, amount, involves } of history) {
  if (involves.length === 1) {
    console.log(`${payer} lent ¥${amount} to ${involves[0]}`);
  } else {
    console.log(`${payer} paid ¥${amount} for ${involves.join(", ")}`);
  }
}

console.log("\n# Expenses");
for (const [_, { name, consumption }] of data) {
  console.log(`${name} virtually paid ¥${consumption} in total`);
}
```

`history`に支払い履歴を書き込んでから実行すると、「送金表」「履歴」「実質支払総額」が得られます。

```md
# Transaction table

A owes B ¥10
C owes B ¥6

# History

A paid ¥121 for A, B, C
B paid ¥98 for A, B, C
C paid ¥10 for A, B, C
C paid ¥10 for A, B
C lent ¥50 to A

# Expenses

A virtually paid ¥131 in total
B virtually paid ¥81 in total
C virtually paid ¥76 in total
```

プログラムに落とし込めたら、あとはアプリを作るなりスプレッドシートのマクロにするなり自由です。面倒なことは全部コンピューターにやらせよう！
