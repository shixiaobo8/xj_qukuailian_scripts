#!/usr/bin/env python3.6
# -*- coding:utf8 -*-
# 备份数据库 单表备份和/单库备份
# 备份策略: 每天备份一次
import pymysql,time,subprocess,shutil,os,sys,tarfile


# 备份数据库信息
backup_user='root'
backup_pwd=''
backup_host='localhost'
backup_dir='/www/backup_sqls/'
all_dbs=[]


# 打开数据库连接
def execute_sql(sql):
	db = pymysql.connect(backup_host,backup_user,backup_pwd)
	# 使用 cursor() 方法创建一个游标对象 cursor
	cursor = db.cursor()
	# 使用 execute()  方法执行 SQL 查询 
	cursor.execute(sql)
	# 使用 fetchone() 方法获取单条数据.
	data = cursor.fetchall()
	print(data)
	# 关闭数据库连接
	db.close()
	return data


# 获取当前日期
def getToday():
	return time.strftime('%Y_%m_%d',time.localtime(time.time()))


# 备份数据库
def exec_shell(shell):
	print("正在执行shell命令:"+shell)
	rs=subprocess.getoutput(shell)
	print(rs[0])
	return rs


# 获取mysql 所有库名称
def get_all_dbs():
	rs=execute_sql("show databases;")
	all_dbs.extend([ r[0] for r in rs ])
	all_dbs.remove('information_schema')
	all_dbs.remove('test')


# 获取某个库所有的表名称
def get_all_tables(db_name):
	sql = "select table_name from information_schema.tables where table_schema='"+db_name+"';"
	rs=execute_sql(sql)
	tables = rs
	return tables


# 单表备份
def backup_day_db_all_tables(db_name):
	tables = get_all_tables(db_name)
	tar_file = backup_dir + db_name + "_all_tables_" + getToday() + ".tar.gz"
	tar = tarfile.open(tar_file,"w:gz")
	for table in tables:
		table = table[0]
		shell = "mysqldump -u" + backup_user + " -p" + backup_pwd + " -h" + backup_host + " " + db_name + " " + table + " > " + backup_dir + db_name + "_" + table + "_" + getToday() + ".sql" 
		rs = exec_shell(shell)
		tar.add(backup_dir + db_name + "_" + table + "_" + getToday() + ".sql")
		os.remove(backup_dir + db_name + "_" + table + "_" + getToday() + ".sql")
		
	

# 单库备份
def backup_day_single_db(db_name):
	tar_file = backup_dir + db_name + "__" + getToday() + ".tar.gz"
	tar = tarfile.open(tar_file,"w:gz")
	shell = "mysqldump -u" + backup_user + " -p" + backup_pwd + " -h" + backup_host + " " + db_name + " > " + backup_dir + db_name + "_" + getToday() + ".sql"
	rs = exec_shell(shell)
	tar.add(backup_dir + db_name + "_" + getToday() + ".sql")
	os.remove(backup_dir + db_name + "_" + getToday() + ".sql")
	print(rs)


if __name__ == '__main__':
	get_all_dbs()
	for db in all_dbs:
		backup_day_single_db(db)
		backup_day_db_all_tables(db)
