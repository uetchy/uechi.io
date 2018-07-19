---
title: Install Python and Jupyter on macOS with Minimal Effort
date: 2017-02-28 11:14:00 +09:00
---

Maybe you don't need `pyenv` and/or `virtualenv` in most cases.

## Install Python

> Don't have `brew`? Go to <https://brew.sh>.

```
brew install python3
```

If you still need Python 2, run `brew install python`.

## Install Jupyter Notebook

```
pip3 install jupyter
python3 -m ipykernel install --user
```

You also want Python 2 kernel, so then:

```
pip install ipykernel
python -m ipykernel install --user
```

That's all.

# How about `virtualenv`?

Since Python 3 got its own virtual environment tool called [venv](https://docs.python.org/3/library/venv.html), You no longer need `virtualenv` itself.

If you want a virtual envs on your project, run:

```
python3 -m venv venv
source ./venv/bin/activate
```

then `venv` will creates virtual envs on **./venv** folder on the root of your project.
