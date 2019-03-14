---
title: Building TensorFlow from Source
date: 2018-04-10 09:41:00 +09:00
---

As you may notice lines of snippet showed on [dockerfile-machinelearning](https://github.com/uetchy/dockerfile-machinelearning/blob/ffc2cadaf192b19509df0f4b87bc9d427aa30966/Dockerfile#L54-L86), TensorFlow can be non-interactively installed from source.

The code here are hugely depend on [PatWie's gist](https://gist.github.com/PatWie/0c915d5be59a518f934392219ca65c3d). I just added some build options for a newer version of TensorFlow and remove options that affect nothing.

```
PYTHON_BIN_PATH=$(which python) \
CUDA_TOOLKIT_PATH=/usr/local/cuda \
CUDNN_INSTALL_PATH=/usr/local/cuda \
PYTHON_LIB_PATH="$($PYTHON_BIN_PATH -c 'import site; print(site.getsitepackages()[0])')" \
TF_NEED_GCP=0 \
TF_NEED_CUDA=1 \
TF_CUDA_VERSION="$($CUDA_TOOLKIT_PATH/bin/nvcc --version | sed -n 's/^.*release \(.*\),.*/\1/p')" \
TF_CUDA_COMPUTE_CAPABILITIES=6.1,5.2,3.5 \
TF_NEED_HDFS=0 \
TF_NEED_OPENCL=0 \
TF_NEED_JEMALLOC=1 \
TF_ENABLE_XLA=0 \
TF_NEED_VERBS=0 \
TF_CUDA_CLANG=0 \
TF_CUDNN_VERSION="$(sed -n 's/^#define CUDNN_MAJOR\s*\(.*\).*/\1/p' $CUDNN_INSTALL_PATH/include/cudnn.h)" \
TF_NEED_MKL=0 \
TF_DOWNLOAD_MKL=0 \
TF_NEED_MPI=0 \
TF_NEED_OPENCL_SYCL=0 \
TF_NEED_S3=0 \
TF_NEED_KAFKA=0 \
TF_NEED_TENSORRT=0 \
TF_NEED_GDR=0 \
TF_SET_ANDROID_WORKSPACE=0 \
GCC_HOST_COMPILER_PATH=$(which gcc) \
CC_OPT_FLAGS="-march=native" ./configure
bazel build --config=opt --config=cuda //tensorflow/tools/pip_package:build_pip_package && \
bazel-bin/tensorflow/tools/pip_package/build_pip_package /tmp/tensorflow_pkg && \
pip install /tmp/tensorflow_pkg/tensorflow-1.7.0-cp36-cp36m-linux_x86_64.whl
```
