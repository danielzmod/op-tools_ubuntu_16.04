#!/bin/bash
set -o errexit # Exit on error
# Setup
TAG=v0.7 # Tag to checkout

# 0. From dockerfile
sudo apt update
sudo apt install -y \
    autoconf \
    build-essential \
    bzip2 \
    clang \
    cmake \
    curl \
    ffmpeg \
    git \
    libarchive-dev \
    libbz2-dev \
    libcurl4-openssl-dev \
    libeigen3-dev \
    libffi-dev \
    libglew-dev \
    libgles2-mesa-dev \
    libglib2.0-0 \
    liblzma-dev \
    libmysqlclient-dev \
    libomp-dev \
    libopencv-dev \
    libssl-dev \
    libtool \
    libusb-1.0-0-dev \
    libzmq5-dev \
    locales \
    ocl-icd-libopencl1 \
    ocl-icd-opencl-dev \
    opencl-headers \
    python-dev \
    python-pip \
    screen \
    sudo \
    vim \
    wget

# 1. Install Python 3.7.3. 
pyenv install 3.7.3
pyenv global 3.7.3
pip install --upgrade pip
pip install pipenv

# 2. Dependancies
# ffmpeg
sudo apt install -y ffmpeg libavformat-dev libavcodec-dev libavdevice-dev libavutil-dev libswscale-dev libavresample-dev libavfilter-dev
# Build tools
sudo apt install -y autoconf automake clang libtool pkg-config build-essential clang-3.8 
# libarchive-dev
sudo apt install -y libarchive-dev
# python-qt4
sudo apt install -y python-qt4
# Install dependencies for matplotlib (needed to make pip install work in later step)
sudo apt install -y libpng-dev libfreetype6-dev

# zeromq
curl -LO https://github.com/zeromq/libzmq/releases/download/v4.2.3/zeromq-4.2.3.tar.gz
tar xfz zeromq-4.2.3.tar.gz
pushd zeromq-4.2.3
./autogen.sh
./configure CPPFLAGS=-DPIC CFLAGS=-fPIC CXXFLAGS=-fPIC LDFLAGS=-fPIC --disable-shared --enable-static
make -j$(nproc)
sudo make install
popd
rm -rf zeromq-4.2.3 zeromq-4.2.3.tar.gz 

# 3. clone and create virtualenv for openpilot
cd # Clone into home directory root
git clone https://github.com/commaai/openpilot
pushd openpilot
git checkout $TAG # Checkout version specified in TAG
OPPATH=$(pwd) # Store directory for PYTHONPATH
pipenv install # Install dependencies in the virtualenv

# 4. Clone tools within openpilot, and install dependencies
git clone https://github.com/commaai/openpilot-tools.git tools
pushd tools
git checkout $TAG  # the tag must match the openpilot version you are using (see https://github.com/commaai/openpilot-tools/tags) TODO: make user supplied variable
popd

# 5. capnproto
# install with the supplied script instead
sudo cereal/install_capnp.sh
popd

# 6. Add openpilot to your PYTHONPATH
echo 'export PYTHONPATH='$OPPATH >> ~/.bashrc
source ~/.bashrc

# 7. Add folders to root
sudo mkdir -v /data
sudo mkdir -v /data/params
sudo chown -v $USER /data/params

# Guide user
echo ""
echo "##################################################################################"
echo " Automated part of installation finished successfully. "
echo "##################################################################################"
echo "Run these commands to finish the installation"
echo "cd ~/openpilot"
echo "pipenv shell"
echo "pip install -r tools/requirements.txt"
echo "scons"
echo ""
echo "###################################################################################"

# Run manually
#cd ~/openpilot
#pipenv shell # Activate the virtualenv
#scons
#cd tools
#pip install -r requirements.txt # Install openpilot-tools dependencies in virtualenv

