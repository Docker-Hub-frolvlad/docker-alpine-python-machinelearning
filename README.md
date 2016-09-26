[![Docker Stars](https://img.shields.io/docker/stars/frolvlad/alpine-python-machinelearning.svg?style=flat-square)](https://hub.docker.com/r/frolvlad/alpine-python-machinelearning/)
[![Docker Pulls](https://img.shields.io/docker/pulls/frolvlad/alpine-python-machinelearning.svg?style=flat-square)](https://hub.docker.com/r/frolvlad/alpine-python-machinelearning/)


Python Machine Learning tools Docker image
==========================================

This image is based on
[Alpine Linux Python 3.5 image](https://hub.docker.com/r/frolvlad/alpine-python3/),
which is only a 60MB image, and contains popular Machine Leaning tools:

* numpy
* pandas
* scipy
* scikit-learn

Download size of this image is only:

[![](https://images.microbadger.com/badges/image/frolvlad/alpine-python-machinelearning.svg)](http://microbadger.com/images/frolvlad/alpine-python-machinelearning "Get your own image badge on microbadger.com")


Usage Example
-------------

```bash
$ docker run --rm frolvlad/alpine-python-machinelearning python3 -c 'import numpy; print(numpy.arange(3))'
```

Once you have run this command you will get printed `array([0, 1, 2])` from Python!
