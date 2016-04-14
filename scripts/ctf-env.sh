#!/bin/bash

if [ `uname` != 'Linux' ]; then
    echo this script is for Debian-based system only :\(
    echo run: sudo -H bash ctf-env.sh
    exit 1
fi

if [ $UID -ne 0 ]; then
    echo run with root please.
    exit 1
fi

dpkg --add-architecture i386
apt-get update
apt-get install -y python-software-properties
apt-get install -y \
                libc6:i386 \
                libc6-dbg:i386 \
                linux-libc-dev:i386 \
                gcc-aarch64-linux-gnu g++-aarch64-linux-gnu \
                gcc-arm-linux-gnueabihf g++-arm-linux-gnueabihf \
                gcc-powerpc-linux-gnu g++-powerpc-linux-gnu \
                software-properties-common \
                build-essential gcc \
                ipython python-dev python-pip \
                libjpeg-dev libpng-dev \
                nasm gdb git-core vim qemu

[ -f /usr/lib/libcapstone.so.3 ] || (
    cd /tmp; mkdir install-ctf; cd install-ctf;
    wget https://github.com/aquynh/capstone/archive/3.0.4.tar.gz -O capstone.tar.gz;
    tar -xvf capstone.tar.gz;
    cd capstone-3.0.4;
    make; make install
)

# apache2 + php
#LC_ALL=en_US.UTF-8 add-apt-repository ppa:ondrej/php -y && apt-get install apache2 php5 php-json php-mysqlnd-ms php-mcrypt -y

# fix libcapstone.so not found problem for ROPgadget
(cd /usr/lib; ln -s libcapstone.so.3 libcapstone.so)

pip2 install -U pip pyasn1
pip2 install -U ipython pwntools ROPgadget requests beautifulsoup4 virtualenv
pip2 install -U pillow

virtualenv /usr/local/share/ropgadget-venv
( source /usr/local/share/ropgadget-venv/bin/activate && pip2 install -U ROPgadget )
cat > /usr/local/bin/ROPgadget << EOF
#!/bin/bash

source /usr/local/share/ropgadget-venv/bin/activate
exec ROPgadget "\$@"
EOF


# install gdb for new users, /etc/skel template for new user's home
[ -d /usr/local/share/peda ] || (
    git clone https://github.com/longld/peda.git --depth 1 /usr/local/share/peda;
    echo 'source /usr/local/share/peda/peda.py' >> /etc/skel/.gdbinit
)

cat > /etc/skel/.pythonrc.py <<EOF
from pwn import *
import requests
import sys

if sys.stdin.isatty():
    print('[+] pwntools and requests were loaded!')
EOF
echo 'export PYTHONSTARTUP=~/.pythonrc.py' >> /etc/skel/.bashrc

echo "
H4sIAFFpyFYCA9WYQW6DMBRE97lCNuwCEopJcBSj9CZF+rkAN/iHL12kfBAD4xqidjcamQGFefnG
x886PG6PUHfZ8UfKcc6dlzFrX/JyaYwO79M3/z7tzX2Dp7Tsuf4+PM/14nfXr2e7Vua+pE65dtCN
0fVbtRyGzussCb9xp9QI0NlGvhBtF8KPyiGpYZqvW/g9NbrW8InOCH81Z0KBgrYrQVAO/GLWH1Mj
QFMUENeuZ5r30phu9FpjKBMDkYLyW98RgDyJHFvyEwFFa7SCNas5PUTt1iCk+PcwKjkCyvqOgOW5
llMN73EJkFjQUKYDECko+YkAoQW+I4B6GohG4CCgIkBb2sIJsSVDDOYgB7HA+JaRIibHh1G37dAp
EhiRHYZR7NBBOTkYRrEDKE9gDW3hPgim9vWH3+ebC0lhCuUcACRCwMOsb4ldWgl8BNt5LdObgbpQ
+jOAxGoHrm2Ja0vwLcQMJNlifRXMHzoGoySAYXLsrk7BkFAwbITwmcx5qDyEpwVgWF1GwjZA25ic
pisOf/hQQQFIGnlIEDt5ojInOzuk3dYHDEkHA//zUAF9HmWg9IxWAjarXQ9M1X0BPNagjjQUAAA=
" | base64 -d | gzip -d
