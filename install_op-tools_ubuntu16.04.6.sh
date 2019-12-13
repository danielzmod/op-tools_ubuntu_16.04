#!/bin/bash

# 1. Core tools
# some duplicate install kepping them for simplicity.
sudo apt install git curl

# Install Python 3.7.3
pyenv install 3.7.3
pyenv global 3.7.3
pip install --upgrade pip
pip install pipenv

# ffmpeg
sudo apt install ffmpeg libavformat-dev libavcodec-dev libavdevice-dev libavutil-dev libswscale-dev libavresample-dev libavfilter-dev

# Build tools
sudo apt install autoconf automake clang libtool pkg-config build-essential clang-3.8 

# libarchive-dev
sudo apt install libarchive-dev

# python-qt4
sudo apt install python-qt4

# Install dependencies for matplotlib (needed to make pip install work in later step)
#sudo apt install libpng-dev libfreetype6-dev

# zeromq
curl -LO https://github.com/zeromq/libzmq/releases/download/v4.2.3/zeromq-4.2.3.tar.gz
tar xfz zeromq-4.2.3.tar.gz
pushd zeromq-4.2.3
./autogen.sh
./configure CPPFLAGS=-DPIC CFLAGS=-fPIC CXXFLAGS=-fPIC LDFLAGS=-fPIC --disable-shared --enable-static
make
sudo make install
popd

# 2. capnproto
curl -O https://capnproto.org/capnproto-c++-0.6.1.tar.gz
tar xvf capnproto-c++-0.6.1.tar.gz
pushd capnproto-c++-0.6.1
./configure --prefix=/usr/local CPPFLAGS=-DPIC CFLAGS=-fPIC CXXFLAGS=-fPIC LDFLAGS=-fPIC --disable-shared --enable-static
make -j4
sudo make install
popd
rm -rf capnproto-c++-0.6.1 capnproto-c++-0.6.1.tar.gz

git clone https://github.com/commaai/c-capnproto.git
pushd c-capnproto
git submodule update --init --recursive
autoreconf -f -i -s
CFLAGS="-fPIC" ./configure --prefix=/usr/local
make -j4
sudo make install
popd
rm -rf capnproto-c++-0.6.1 capnproto-c++-0.6.1.tar.gz

# clone and create virtualenv for openpilot
cd # Clone into home directory root
git clone https://github.com/commaai/openpilot
pushd openpilot
pipenv install # Install dependencies in a virtualenv

# 4. Clone tools within openpilot, and install dependencies
git clone https://github.com/commaai/openpilot-tools.git tools
pushd tools
git checkout v0.6.6  # the tag must match the openpilot version you are using (see https://github.com/commaai/openpilot-tools/tags) TODO: make user supplied variable
popd
popd

# 5. Add openpilot to your PYTHONPATH
#echo 'export PYTHONPATH="$PYTHONPATH:/home/openpilot/openpilot"' >> ~/.bashrc Using safe assignment instead. To avoid problems with path starting with colon.
echo 'export PYTHONPATr="/home/openpilot/openpilot"' >> ~/.bashrc
source ~/.bashrc

# 6. Add folders to root
sudo mkdir -v /data
sudo mkdir -v /data/params
sudo chown -v $USER /data/params

# Activate shell
pushd openpilot
echo ""
echo "##################################################################################"
echo "Run these two commands inside the virtual environment to finish the installation"
echo "cd tools"
echo "pip install -r requirements.txt"
echo ""
echo "###################################################################################"
echo "Activating virtual environment..."

pipenv shell # Activate the virtualenv

# Run manually
#pushd tools
#pip install -r requirements.txt # Install openpilot-tools dependencies in virtualenv

