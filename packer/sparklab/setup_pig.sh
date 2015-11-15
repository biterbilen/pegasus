#!/bin/bash

PIG_VER=0.14.0

wget http://mirror.tcpdiag.net/apache/pig/pig-$PIG_VER/pig-$PIG_VER.tar.gz -P ~/Downloads
sudo tar -zxvf ~/Downloads/pig-*.tar.gz -C /usr/local
sudo mv /usr/local/pig-* /usr/local/pig

echo -e "\nexport PIG_HOME=/usr/local/pig\nexport PATH=\$PATH:\$PIG_HOME/bin\n" | cat >> ~/.profile

. ~/.profile