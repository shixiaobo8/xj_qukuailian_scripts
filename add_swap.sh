#!/bin/bash
# 检查系统当前的swap空间大小
swap_size=`free -m  | grep Swap | awk '{print $2}' | awk '{print $1}'` 
echo $swap_size
mkdir -p /data/swapfiles
dd if=/dev/zero of=/data/swapfiles/swapfile2 bs=1M count=1024
mkswap /data/swapfiles/swapfile2
swapon /data/swapfiles/swapfile2
echo "/data/swapfiles/swapfile2  swap swap defaults 0 0" >> /etc/fstab
free -m
