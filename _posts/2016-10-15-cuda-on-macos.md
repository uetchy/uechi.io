---
title: CUDA on macOS
date: 2016-10-15 09:00:00 +09:00
redirect_from: /blog/2016/10/15/cuda-on-macos
---

Install TensorFlow with CUDA 8.0 + cuDNN 5.1 support on macOS.
All instructions are based on [TensorFlow Get Started](https://www.tensorflow.org/get_started/os_setup).

# Install CUDA and cuDNN

{% gist 568d86da5ce555e9bc6618f59391f9cd 01_install_cuda_cudnn.sh %}

You also need to add this line to your shell config.

```bash
export CUDA_HOME=/usr/local/cuda
export DYLD_LIBRARY_PATH="$DYLD_LIBRARY_PATH:$CUDA_HOME/lib"
export PATH="$CUDA_HOME/bin:$PATH"
```

and build deviceQuery as test your environment.

```bash
cd /usr/local/cuda/samples/
make -C 1_Utilities/deviceQuery
./bin/x86_64/darwin/release/deviceQuery
```

# Install TensorFlow

## Install from pip

{% gist 568d86da5ce555e9bc6618f59391f9cd 02_install_tensorflow.sh %}

## Build from source

{% gist 568d86da5ce555e9bc6618f59391f9cd 03_build_tensorflow.sh %}
