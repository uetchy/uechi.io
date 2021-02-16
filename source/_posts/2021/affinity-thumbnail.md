---
title: Distill Thumbnail from .afphoto and .afdesign
date: 2021-02-14T13:30:00
---

Nextcloud does not have support for generating thumbnails from Affinity Photo and Affinity Design. Fine, I'll do it myself.

# Digging Binary

Glancing at `.afphoto` and `.afdesign` in Finder, I noticed that it has a QuickLook support and an ability to show the thumbnail image. So these files should have thumbnail image somewhere inside its binary.

I wrote a simple script to seek for [PNG signature](https://www.w3.org/TR/PNG/) inside a binary and save it as a PNG file.

```js
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

That's right. This script just scrapes a binary file and distill a portion of which starts with `PNG` signature and ends with `IEND`.

Now I can generate a thumbnail image from arbitrary `.afphoto` and `.afdesign` file. Let's move on delving into Nextcloud source code.

# Tweaking Nextcloud

I have a bit of experience in tweaking Nextcloud source code before, where I implemented thumbnail generator for PDFs, so it should be easier this time, hopefully.

Long story short, I got Nextcloud generates thumbnail images for Affinity files by implementing `ProviderV2` class.

```php lib/private/Preview/Affinity.php
<?php

namespace OC\Preview;

use OCP\Files\File;
use OCP\IImage;
use OCP\ILogger;

class Affinity extends ProviderV2 {
	public function getMimeType(): string {
		return '/application\/x-affinity-(?:photo|design)/';
	}

	public function getThumbnail(File $file, int $maxX, int $maxY): ?IImage {
		$tmpPath = $this->getLocalFile($file);

		$handle = fopen($tmpPath, 'rb');
		$fsize = filesize($tmpPath);
		$contents = fread($handle, $fsize);
		$start = strrpos($contents, "\x89PNG");
		$end = strrpos($contents, "IEND", $start);
		$subarr = substr($contents, $start, $end - $start + 8 );

		fclose($handle);
		$this->cleanTmpFiles();

		$image = new \OC_Image();
		$image->loadFromData($subarr);
		$image->scaleDownToFit($maxX, $maxY);

		return $image->valid() ? $image : null;
	}
}
```

```patch lib/private/PreviewManager.php
@@ -363,6 +365,8 @@
 		$this->registerCoreProvider(Preview\Krita::class, '/application\/x-krita/');
 		$this->registerCoreProvider(Preview\MP3::class, '/audio\/mpeg/');
 		$this->registerCoreProvider(Preview\OpenDocument::class, '/application\/vnd.oasis.opendocument.*/');
+		$this->registerCoreProvider(Preview\Affinity::class, '/application\/x-affinity-(?:photo|design)/');

 		// SVG, Office and Bitmap require imagick
 		if (extension_loaded('imagick')) {
```

```patch lib/composer/composer/autoload_static.php
@@ -1226,6 +1226,7 @@
         'OC\\OCS\\Result' => __DIR__ . '/../../..' . '/lib/private/OCS/Result.php',
         'OC\\PreviewManager' => __DIR__ . '/../../..' . '/lib/private/PreviewManager.php',
         'OC\\PreviewNotAvailableException' => __DIR__ . '/../../..' . '/lib/private/PreviewNotAvailableException.php',
+        'OC\\Preview\\Affinity' => __DIR__ . '/../../..' . '/lib/private/Preview/Affinity.php',
         'OC\\Preview\\BMP' => __DIR__ . '/../../..' . '/lib/private/Preview/BMP.php',
         'OC\\Preview\\BackgroundCleanupJob' => __DIR__ . '/../../..' . '/lib/private/Preview/BackgroundCleanupJob.php',
         'OC\\Preview\\Bitmap' => __DIR__ . '/../../..' . '/lib/private/Preview/Bitmap.php',
```

```patch lib/composer/composer/autoload_classmap.php
@@ -1197,6 +1197,7 @@
     'OC\\OCS\\Result' => $baseDir . '/lib/private/OCS/Result.php',
     'OC\\PreviewManager' => $baseDir . '/lib/private/PreviewManager.php',
     'OC\\PreviewNotAvailableException' => $baseDir . '/lib/private/PreviewNotAvailableException.php',
+    'OC\\Preview\\Affinity' => $baseDir . '/lib/private/Preview/Affinity.php',
     'OC\\Preview\\BMP' => $baseDir . '/lib/private/Preview/BMP.php',
     'OC\\Preview\\BackgroundCleanupJob' => $baseDir . '/lib/private/Preview/BackgroundCleanupJob.php',
     'OC\\Preview\\Bitmap' => $baseDir . '/lib/private/Preview/Bitmap.php',
```

![](afphoto.png)

Easy-peasy!

# Bonus: PDF thumbnail generator

```php lib/private/Preview/PDF.php
<?php

namespace OC\Preview;

use OCP\Files\File;
use OCP\IImage;

class PDF extends ProviderV2 {
	public function getMimeType(): string {
		return '/application\/pdf/';
	}

	public function getThumbnail(File $file, int $maxX, int $maxY): ?IImage {
		$tmpPath = $this->getLocalFile($file);
		$outputPath = \OC::$server->getTempManager()->getTemporaryFile();

		$gsBin = \OC_Helper::findBinaryPath('gs');
		$cmd = $gsBin . " -o " . escapeshellarg($outputPath) . " -sDEVICE=jpeg -sPAPERSIZE=a4 -dLastPage=1 -dPDFFitPage -dJPEGQ=90 -r144 " . escapeshellarg($tmpPath);
		shell_exec($cmd);

		$this->cleanTmpFiles();

		$image = new \OC_Image();
		$image->loadFromFile($outputPath);
		$image->scaleDownToFit($maxX, $maxY);

		unlink($outputPath);

		return $image->valid() ? $image : null;
	}
}
```
