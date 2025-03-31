FROM frolvlad/alpine-python3

RUN apk add --no-cache \
        --virtual=.build-dependencies \
        ninja g++ gfortran file binutils \
        musl-dev python3-dev openblas-dev lapack-dev && \
    apk add libstdc++ openblas && \
    \
    ln -s locale.h /usr/include/xlocale.h && \
    echo 'Pin setuptools version for numpy: https://numpy.org/devdocs/reference/distutils_status_migration.html' && \
    pip install --disable-pip-version-check --no-build-isolation 'setuptools<60.0' && \
    pip install --disable-pip-version-check --no-build-isolation cython && \
    pip install --disable-pip-version-check --no-build-isolation numpy && \
    pip install --disable-pip-version-check --no-build-isolation pandas && \
    pip install --disable-pip-version-check --no-build-isolation meson-python pythran && \
    pip install --disable-pip-version-check --no-build-isolation pybind11 && \
    pip install --disable-pip-version-check --no-build-isolation scipy && \
    pip install --disable-pip-version-check --no-build-isolation scikit-learn && \
    echo 'Unpin setuptools version' && \
    pip install --disable-pip-version-check --no-build-isolation --upgrade setuptools && \
    \
    rm -r /root/.cache && \
    find /usr/lib/python3.*/ -name 'tests' -exec rm -r '{}' + && \
    find /usr/lib/python3.*/site-packages/ -name '*.so' -print -exec sh -c 'file "{}" | grep -q "not stripped" && strip -s "{}"' \; && \
    \
    rm /usr/include/xlocale.h && \
    \
    apk del .build-dependencies

# Add pycddlib and cvxopt with GLPK
RUN cd /tmp && \
    apk add --no-cache \
        --virtual=.build-dependencies \
        gcc make file binutils \
        musl-dev python3-dev gmp-dev suitesparse-dev openblas-dev && \
    apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing \
        --virtual=.build-dependencies-edge \
	libcdd-dev &&\
    apk add --no-cache gmp suitesparse && \
    \
    pip install --disable-pip-version-check --no-build-isolation pycddlib && \
    \
    wget "ftp://ftp.gnu.org/gnu/glpk/glpk-5.0.tar.gz" && \
    tar xzf "glpk-5.0.tar.gz" && \
    cd "glpk-5.0" && \
    ./configure --disable-static && \
    make -j4 && \
    make install-strip && \
    \
    cd /tmp && \  
    wget https://github.com/cvxopt/cvxopt/archive/refs/tags/1.3.0.zip && \
    unzip 1.3.0.zip && \
    cd cvxopt-1.3.0 && \
    env CVXOPT_BLAS_LIB=openblas CVXOPT_LAPACK_LIB=openblas CVXOPT_BUILD_GLPK=1 CFLAGS="-I/usr/include/suitesparse" python setup.py install && \
    \
    rm -r /root/.cache && \
    find /usr/lib/python3.*/site-packages/ -name '*.so' -print -exec sh -c 'file "{}" | grep -q "not stripped" && strip -s "{}"' \; && \
    \
    apk del .build-dependencies .build-dependencies-edge && \
    rm -rf /tmp/*

# Add opencv (cv2)
RUN apk add --no-cache \
        --virtual=.build-dependencies \
        ninja cmake g++ \
        python3-dev linux-headers && \
    pip install --disable-pip-version-check --no-build-isolation scikit-build && \
    pip install --disable-pip-version-check --no-build-isolation opencv-python && \
    pip uninstall --yes scikit-build && \
    \
    rm -r /root/.cache && \
    \
    apk del .build-dependencies && \
    rm -rf /tmp/*
