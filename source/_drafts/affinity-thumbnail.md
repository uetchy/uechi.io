---
title: Extract Thumbnail Image from Affinity Photo and Affinity Design
---

Nextcloud doesn't have a support for thumbnail generation from Affinity Photo and Affinity Design. So I had to do it myself.

# Digging Binary

Glancing at `.afphoto` and `.afdesign` in Finder, I noticed that it has a QuickLook support and an ability to show the thumbnail image. So these files should have thumbnail image somewhere inside its binary.

I wrote a simple script to seek for thumbnail image from a binary and save it as `.png` file.

```js af.js
const fs = require("fs");

// png spec: https://www.w3.org/TR/PNG/
const PNG_SIG = Buffer.from([137, 80, 78, 71, 13, 10, 26, 10]);
const IEND_SIG = Buffer.from([73, 69, 78, 68]);

function extractThumbnail(buf) {
  const start = buf.indexOf(PNG_SIG);
  const end = buf.indexOf(IEND_SIG, start) + IEND_SIG.length * 2; // IEND + CRC
  return buf.subarray(start, end);
}

function generateThumbnail(input, output) {
  const buf = fs.readFileSync(input);
  const thumbBuf = extractThumbnail(buf);
  fs.writeFileSync(output, thumbBuf);
}

generateThumbnail(process.argv[2], process.argv[3] || "output.png");
```

That's right. This script just scrapes a binary file and extracts the portion of which starts with `PNG` signature and ends with `IEND`.

Now I can generate a thumbnail image from arbitrary `.afphoto` and `.afdesign` file. Let's move on delving into Nextcloud source code.

# Tweaking Nextcloud

I have a little experience in tweaking Nextcloud source code before, where I implemented thumbnail generator for PDFs, so it should be easier this time, hopefully.

![](afphoto.png)

Anyway, long story short, I got Nextcloud generates thumbnail images for Affinity files by implementing PreviewGenerator class.
