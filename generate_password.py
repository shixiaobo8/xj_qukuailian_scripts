#!/usr/bin/env python3.6
# -*- coding:utf8 -*-
"""
	定期随机随机生成密码
"""
import secrets
import pymysql
import random
import datetime

mysql_root = 'root'
mysql_pwd = 'xxxxxxxxxxxxxxxxxxxxxx'
mysql_host = 'localhost'
mysql_db = 'xxxxxxxxxxxxxxxxxxxx'
users_hosts = dict()
services_hosts = []


# 执行mysql语句
def exec_mysql_sql(sql):
	try:
		# 连接database
		conn = pymysql.connect(
		host=mysql_host,
		user=mysql_root,password=mysql_pwd,
		database=mysql_db,charset="utf8")
				 
		# 得到一个可以执行SQL语句的光标对象
		cursor = conn.cursor()  # 执行完毕返回的结果集默认以元组显示
		# 得到一个可以执行SQL语句并且将结果作为字典返回的游标
		#cursor = conn.cursor(cursor=pymysql.cursors.DictCursor) 
		# 定义要执行的SQL语句	 
		# 执行SQL语句
		cursor.execute(sql)		 
		datas = cursor.fetchall()
		# 涉及写操作要注意提交
		conn.commit()
		return datas
	except Exception as e:
		print(e)
	finally:
		# 关闭光标对象
		cursor.close()	 
		# 关闭数据库连接
		conn.close()


# 获取主机ip
def get_hosts():
	sql = "select `id`,`host_inner_ip`,`sv_port`,`hostname` from sv_hosts;"
	hosts = exec_mysql_sql(sql)
	return hosts


def shuffle_str(str=''):
    l = list(str)  # 将字符串转换成列表
    random.shuffle(l)  # 调用random模块的shuffle函数
    return ''.join(l)  # 列表转字符串


# 生成一个带特殊符号的密码
def generate_pwd(num):
	# 生成一个9位数的密码
	special_label = "()*&^%$#@!~<>?|.+_-"
	pwd_str = secrets.token_urlsafe(6)  + random.choice(special_label)
	while True:
		r = shuffle_str(pwd_str)
		if r[0] not in special_label and ' ' not in r:
			return r


# 设置主机密码
def set_password(host_id):
	try:
		now = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
		c_sql = "select `last_modify`,`ctime`,`pwdstr` from `sv_hostPasswords` where `is_latest_new`=1 and `host_Id`=%d;"%int(host_id)
		pwd = exec_mysql_sql(c_sql)	
		# 生成一个9位数的密码
		pwd_str = generate_pwd(9)
		if pwd:
			u_sql = 'update `sv_hostPasswords` set is_latest_new="0" where `host_Id`=%d'%(int(host_id))
			rs = exec_mysql_sql(u_sql)
			c_sql = "insert into `sv_hostPasswords`(`ctime`,`last_modify`,`host_Id`,`is_del`,`pwdstr`,`is_latest_new`) values('%s','%s','%d','%d','%s','%d')"%(now,now,int(host_id),0,pwd_str,1)
			rs = exec_mysql_sql(c_sql)
		else:
			c_sql = "insert into `sv_hostPasswords`(`ctime`,`last_modify`,`host_Id`,`is_del`,`pwdstr`,`is_latest_new`) values('%s','%s','%d','%d','%s','%d')"%(now,now,int(host_id),0,pwd_str,1)
			rs = exec_mysql_sql(c_sql)
		print(str(host_id)+"设置密码成功!")
	except Exception as e:
		print(e)


if __name__ == "__main__":
	hosts = get_hosts()
	for host in hosts:
		set_password(host[0])
