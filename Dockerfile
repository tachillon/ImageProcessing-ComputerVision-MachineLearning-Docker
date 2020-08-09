FROM nvidia/cuda:10.2-cudnn7-devel-ubuntu18.04

ENV DEBIAN_FRONTEND noninteractive
# Core Linux Deps
RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y --fix-missing --no-install-recommends apt-utils \
    build-essential                  \
    curl                             \
    binutils                         \
    gdb                              \
    git                              \
    freeglut3                        \
    freeglut3-dev                    \
    libxi-dev                        \
    libxmu-dev                       \
    gfortran                         \
    pkg-config                       \
    python-numpy                     \
    python-dev                       \
    python-setuptools                \
    libboost-python-dev              \
    libboost-thread-dev              \
    pbzip2                           \
    rsync                            \
    software-properties-common       \
    libboost-all-dev                 \
    libopenblas-dev                  \
    libtbb2                          \
    libtbb-dev                       \
    libjpeg-dev                      \
    libpng-dev                       \
    libtiff-dev                      \
    libgraphicsmagick1-dev           \
    libavresample-dev                \
    libavformat-dev                  \
    libhdf5-dev                      \
    libpq-dev                        \
    libgraphicsmagick1-dev           \
    libavcodec-dev                   \
    libgtk2.0-dev                    \
    liblapack-dev                    \
    liblapacke-dev                   \
    libswscale-dev                   \
    libcanberra-gtk-module           \
    libboost-dev                     \
    libboost-all-dev                 \
    libeigen3-dev                    \
    wget                             \
    vim                              \
    qt5-default                      \
    unzip                            \
    zip                              \
    ffmpeg                           \
    libv4l-dev                       \
    libatlas-base-dev                \
    libgphoto2-dev                   \
    libgstreamer-plugins-base1.0-dev \
    libdc1394-22-dev                 \
                                  && \
    apt-get clean                 && \
    rm -rf /var/lib/apt/lists/*   && \
    apt-get clean && rm -rf /tmp/* /var/tmp/*
ENV DEBIAN_FRONTEND noninteractive

# Install cmake version that supports anaconda python path
RUN wget -O cmake.tar.gz https://github.com/Kitware/CMake/releases/download/v3.15.4/cmake-3.15.4-Linux-x86_64.tar.gz && \
    tar -xvf cmake.tar.gz            && \
    cd /cmake-3.15.4-Linux-x86_64    && \
    cp -r bin /usr/                  && \
    cp -r share /usr/                && \
    cp -r doc /usr/share/            && \
    cp -r man /usr/share/            && \
    cd /                             && \
    rm -rf cmake-3.15.4-Linux-x86_64 && \
    rm -rf cmake.tar.gz

# For CUDA profiling, TensorFlow requires CUPTI.
ENV LD_LIBRARY_PATH /usr/local/cuda/extras/CUPTI/lib64:$LD_LIBRARY_PATH

ARG PYTHON=python3
ARG PIP=pip3

# See http://bugs.python.org/issue19846
ENV LANG C.UTF-8

RUN apt-get update && apt-get install -y \
    ${PYTHON} \
    ${PYTHON}-pip

RUN ${PIP} --no-cache-dir install --upgrade \
    pip           \
    setuptools    \
    hdf5storage   \
    h5py          \
    py3nvml       \
    opencv-python \
    scikit-image  \
    scikit-learn  \
    matplotlib    \
    pyinstrument

ARG USE_CUDA=OFF
                                                               
RUN git clone --branch 4.4.0 --depth 1 https://github.com/opencv/opencv_contrib.git && \
    git clone --branch 4.4.0 --depth 1 https://github.com/opencv/opencv.git         && \
    cd opencv && mkdir build && cd build                                            && \
    cmake ..                                                    \
          -DBUILD_TIFF=ON                                       \
          -DBUILD_opencv_java=OFF                               \
          -DWITH_CUDA=${USE_CUDA}                               \
          -DCUDA_ARCH_BIN="6.1 7.0 7.5"                         \
          -DENABLE_FAST_MATH=1                                  \
          -DCUDA_FAST_MATH=1                                    \
          -DWITH_CUBLAS=1                                       \
          -DENABLE_AVX=ON                                       \
          -DWITH_OPENGL=ON                                      \
          -DWITH_OPENCL=ON                                      \
          -DWITH-OPENMP=ON                                      \
          -DWITH_IPP=ON                                         \
          -DWITH_TBB=ON                                         \
          -DWITH_EIGEN=ON                                       \
          -DWITH_V4L=ON                                         \
          -DBUILD_TESTS=OFF                                     \
          -DBUILD_PERF_TESTS=OFF                                \
          -DCMAKE_BUILD_TYPE=RELEASE                            \
          -DCMAKE_INSTALL_PREFIX=/usr/local                     \
          -D PYTHON3_EXECUTABLE=$(which python3)                \
                  -D PYTHON_INCLUDE_DIR=$(python3 -c "from distutils.sysconfig import get_python_inc; print(get_python_inc())") \
                  -D PYTHON_INCLUDE_DIR2=$(python3 -c "from os.path import dirname; from distutils.sysconfig import get_config_h_filename; print(dirname(get_config_h_filename()))") \
                  -D PYTHON_LIBRARY=$(python3 -c "from distutils.sysconfig import get_config_var;from os.path import dirname,join ; print(join(dirname(get_config_var('LIBPC')),get_config_var('LDLIBRARY')))") \
                  -D PYTHON3_PACKAGES_PATH=$(python3 -c "from distutils.sysconfig import get_python_lib; print(get_python_lib())") \
                  -DOPENCV_ENABLE_NONFREE=ON \
                  -DOPENCV_EXTRA_MODULES_PATH=/opencv_contrib/modules \
                  -DBUILD_EXAMPLES=OFF \
                  -D CUDA_TOOLKIT_ROOT_DIR=/usr/local/cuda-10.2 \
                  -DWITH_QT=ON && \
    make -j $(nproc)       && \
    make install           && \
    ldconfig               && \
    rm -rf /opencv         && \
    rm -rf /opencv_contrib

# dlib
# RUN cd ~                                                                             && \
#    mkdir -p dlib                                                                     && \
#    git clone -b 'v19.16' --single-branch https://github.com/davisking/dlib.git dlib/ && \
#    cd  dlib/                                                                         && \
#    python3 setup.py install --yes USE_AVX_INSTRUCTIONS --yes DLIB_USE_CUDA --clean

COPY ./CMakeLists.txt /opt/CMakeLists.txt
COPY ./src /opt/src
COPY ./img.png /opt/img.png

RUN cd /opt                       && \
    mkdir build                   && \
    cd build                      && \
    cmake ..                         \
          -DWITH_CUDA=${USE_CUDA} && \
    make -j $(nproc)              && \
    make install                  && \
    ldconfig