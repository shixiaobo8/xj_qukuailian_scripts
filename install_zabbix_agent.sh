#!/bin/bash
# 一键安装zabbix agent 脚本

# 下载源码包
host_name=`hostname`
host_ip=`ip a | grep inet | awk '{print $2}' | awk -F"/" '{print $1}' | grep -v 127`
server_ip=120.76.57.171
mkdir -p /root/softs
cd /root/softs/
if [ ! -f zabbix-4.0.7.tar.gz ];then
	wget https://nchc.dl.sourceforge.net/project/zabbix/ZABBIX%20Latest%20Stable/4.0.7/zabbix-4.0.7.tar.gz
	tar -zxvf zabbix-4.0.7.tar.gz
fi
tar -zxvf zabbix-4.0.7.tar.gz

if [ ! -d /usr/local/zabbix/sbin ];then
	cd zabbix-4.0.7
	groupadd --system zabbix
	useradd --system -g zabbix -d /usr/lib/zabbix -s /sbin/nologin -c "Zabbix Monitoring System" zabbix
	mkdir -m u=rwx,g=rwx,o= -p /usr/lib/zabbix
	chown zabbix:zabbix /usr/lib/zabbix
	yum install libxml2-devel libssh2-devel mysql-devel gcc gcc-c++ cmake autoconf automake net-snmp net-snmp-devel libssh2 curl curl-devel -y
	./configure --prefix=/usr/local/zabbix --enable-server --enable-agent --with-mysql -enable-ipv6 --with-net-snmp --with-libcurl --with-libxml2 --enable-proxy --with-net-snmp --with-ssh2
	make && make install
	cp -rp misc/init.d/fedora/core5/zabbix_* /etc/init.d/
	ln -s /usr/local/zabbix/sbin/* /usr/local/sbin/
	# 修改配置文件
	echo "HostMetadataItem=system.uname" >> /usr/local/zabbix/etc/zabbix_agentd.conf
	chown -R zabbix:zabbix /usr/local/zabbix/share/zabbix/*
	echo "ListenIP=0.0.0.0" >> /usr/local/zabbix/etc/zabbix_agentd.conf
	echo "Server="$server_ip >> /usr/local/zabbix/etc/zabbix_agentd.conf
	echo "Hostname="$host_ip >> /usr/local/zabbix/etc/zabbix_agentd.conf
	echo "ServerActive="$server_ip >> /usr/local/zabbix/etc/zabbix_agentd.conf
	echo " " >> /usr/local/zabbix/etc/zabbix_agentd.userparams.conf
	echo "Include=/usr/local/zabbix/etc/zabbix_agentd.userparams.conf" >> /usr/local/zabbix/etc/zabbix_agentd.conf
	echo "Include=/usr/local/zabbix/etc/zabbix_agentd.conf.d/*.conf" >> /usr/local/zabbix/etc/zabbix_agentd.conf
fi

echo "zabbix agent installed successfully !!!"


# 重新启动zabbix agentd
/etc/init.d/zabbix_agentd start
