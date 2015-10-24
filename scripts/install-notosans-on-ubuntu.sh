#!/bin/bash

mkdir -p /tmp/noto
cd /tmp/noto
wget http://www.google.com/get/noto/pkgs/Noto-hinted.zip
unzip Noto-hinted.zip
mkdir -p ~/.fonts/noto
mv *.otf ~/.fonts/noto

wget -O fonts.conf https://gist.githubusercontent.com/ingramchen/21533bbfc0d2dead94a7/raw/c750592f750cb446f6a6a19d75892c7d2fb5395f/gistfile1.xml
cp -i fonts.conf ~/.fonts.conf
