---
title: Definitive Guide to Install OpenCV 3 and its Python 3 bindings
date: 2017-03-23 15:10:00 +09:00
redirect_from: /blog/2017/03/23/install-opencv3-and-python3-bindings
---

This article describes how to install OpenCV 3 and its Python 3 bindings on macOS and Ubuntu.

## `pyenv` users beware

Make sure to use system python because there is some tricky problem with OpenCV 3 install script.
To switch to system python, run `pyenv global system`.

# macOS

Install OpenCV 3 package from `homebrew/science`, make sure to add `--with-python3` so we'll also get its Python 3 bindings simultaneously.

```bash
brew tap homebrew/science
brew install opencv3 --with-python3
```

After installing OpenCV 3, put OpenCV 3 path file as `opencv3.pth` into brewed-`python3` site-packages directory, which indicates where the OpenCV 3 bindings installed.

```bash
echo /usr/local/opt/opencv3/lib/python3.6/site-packages >> /usr/local/lib/python3.6/site-packages/opencv3.pth
```

# Ubuntu

```bash
git clone https://github.com/opencv/opencv
cd opencv
git checkout 3.2.0
mkdir build
cd build
cmake \
  -D CMAKE_BUILD_TYPE=RELEASE \
  -D CMAKE_INSTALL_PREFIX=/usr/local \
  -D WITH_TBB=ON \
  -D WITH_EIGEN=ON \
  -D BUILD_NEW_PYTHON_SUPPORT=ON \
  -D INSTALL_PYTHON_EXAMPLES=ON \
  -D WITH_V4L=ON \
  -D WITH_FFMPEG=OFF \
  -D BUILD_EXAMPLES=OFF \
  -D BUILD_TESTS=OFF \
  -D BUILD_PERF_TESTS=OFF \
  -D BUILD_DOCS=OFF \
  -D BUILD_opencv_python2=OFF \
  -D BUILD_opencv_python3=ON \
  -D BUILD_opencv_video=OFF \
  -D BUILD_opencv_videoio=OFF \
  -D BUILD_opencv_videostab=OFF \
  -D PYTHON_EXECUTABLE=$(which python) \
  "$OPENCV_DIR"
make -j2
sudo make install
pip install opencv-python
```

# Check install

```
python -c "import cv2;print(cv2.__version__)"
```

and you'll got `3.2.0`.
