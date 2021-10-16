#!/bin/bash
# License of this script: CC0
# Installation of dependent libraries and softwares is required to use this script
# ex. nasm, yasm, libmp3lame-dev, libopus-dev, libvorbis-dev, libvpx-dev...

set -ex

# setup
temp_dir=$(mktemp -d)

# build openh264
cd $temp_dir
wget --no-check-certificate https://github.com/cisco/openh264/archive/refs/tags/v2.1.1.tar.gz
tar xf v2.1.1.tar.gz
cd openh264-2.1.1
make -j `nproc`
make install
ldconfig

# replace openh264 binary to avoid license problem
cd $temp_dir
wget --no-check-certificate https://github.com/cisco/openh264/releases/download/v2.1.1/libopenh264-2.1.1-linux64.6.so.bz2
bunzip2 libopenh264-2.1.1-linux64.6.so.bz2
cp libopenh264-2.1.1-linux64.6.so /usr/local/lib/libopenh264.so.2.1.1
rm /usr/local/lib/libopenh264.a

# build ffmpeg
cd $temp_dir
wget --no-check-certificate https://github.com/FFmpeg/FFmpeg/archive/refs/tags/n4.2.5.tar.gz
tar xf n4.2.5.tar.gz
cd FFmpeg-n4.2.5
./configure --enable-libopenh264 --enable-libmp3lame --enable-libopus --enable-libvorbis --enable-libvpx
make -j `nproc`
make install

# cleanup
cd
rm -rf $temp_dir
