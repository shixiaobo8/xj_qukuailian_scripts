#!/usr/bin/env python3
# 批量创建用户登陆脚本
import pymysql
import json
from jinja2 import Environment, FileSystemLoader
import subprocess

mysql_root = 'root'
mysql_pwd = '123456'
mysql_host = 'localhost'
mysql_db = 'xj_omsa'
users_hosts = dict()


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
		return datas
	except Exception as e:
		print(e)
	finally:
		# 关闭光标对象
		cursor.close()	 
		# 关闭数据库连接
		conn.close()


# 获取用户名
def get_usernames():
	sql = "select id,username from sv_users;"
	users = exec_mysql_sql(sql)
	return users


# 获取用户对应
def get_user_service_hosts():
	users = get_usernames()
	for user in users:
		user_id = user[0]
		username = user[1]
		sql = "select `id`,`service_name`,`service_detail` from sv_services where is_del=0 and id in (select service_id from  services_developers where user_id="+str(user_id)+");"
		user_services = exec_mysql_sql(sql)
		users_hosts[username] = []
		for service in user_services:
			new_service = dict()
			new_service['service_id'] = service[0]
			new_service['service_name'] = service[1]
			new_service['service_detail'] = service[2]
			new_service['hosts'] = []
			hosts = get_service_hosts(service[0])
			for host in hosts:		
				new_host = dict()
				new_host['hostname'] = host[0]
				new_host['ip'] = host[1]
				new_host['ip_id'] = host[1].split('.')[-1]
				new_host['sv_port'] = host[2]
				new_service['hosts'].append(new_host)
			users_hosts[username].append(new_service)


# 获取访问对应主机
def get_service_hosts(service_id):
	sql = "select `hostname`,`host_inner_ip`,`sv_port` from `sv_hosts` where `id` in (select host_id from services_hosts where service_id=" + str(service_id) + ");"
	hosts = exec_mysql_sql(sql)
	return hosts


# 批量创建用户
def create_shell_user(username):
	# 创建用户组
	if subprocess.getstatusoutput("cat /etc/group |grep developers |wc -l")[1] != '1':
		subprocess.getstatusoutput("groupadd developers")
	# 创建用户
	create_user_cmd = "useradd -g developers -m " + username
	if subprocess.getstatusoutput("cat /etc/passwd |grep " + username + " |wc -l")[1] != '1':
		c_rs = subprocess.getstatusoutput(create_user_cmd)
	# 设置用户初始化密码为用户名+2019
		set_pwd_cmd = "echo '" + username + str(2019) + "' | passwd --stdin " + username
		s_rs = subprocess.getstatusoutput(set_pwd_cmd)
	print("用户"+username+"创建成功!")


# 生成用户登陆脚本
def create_user_login_script(username):
	env = Environment(loader = FileSystemLoader(searchpath="/etc/"))
	logininfo_template = env.get_template("login_info.j2")
	script_template = env.get_template("login_template.j2")
	script_init_template = env.get_template("login_init_template.j2")
	logininfo_script_file_name = '/etc/.logininfo_' + username
	login_script_file_name = '/usr/local/bin/login_' + username
	login_script_file_init_name = '/usr/local/bin/rinit_' + username
	script_output = script_template.render({"username":username,"user_hosts":users_hosts[username]})
	script_output_init = script_init_template.render({"root_pwd":"Pro2019@#!","username":username,"user_hosts":users_hosts[username]})
	logininfo_output = logininfo_template.render({"username":username,"user_hosts":users_hosts[username],"login_script_name":"login_"+username})
	with open(login_script_file_name,"w") as f1:
		f1.write(script_output)
	with open(login_script_file_init_name,"w") as f2:
		f2.write(script_output_init)
	with open(logininfo_script_file_name,"w") as f:
		f.write(logininfo_output)
	# 为用户创建登录脚本链接
	cs_rs = subprocess.getstatusoutput("chown " + username + " /usr/local/bin/login_" + username + " && chmod 500 /usr/local/bin/login_" + username)
	# 将登录脚本加入用户环境变量
	cp_path = "login_"+username
	tcp_rs = subprocess.getstatusoutput("cat /home/" + username + "/.bash_profile | grep -v grep | grep "+cp_path + "|wc -l")
	if tcp_rs[1] == '0':
		tcp1_rs = subprocess.getstatusoutput("echo " + cp_path + ">> /home/"+ username +"/.bash_profile")
		print(tcp1_rs)
	rrs = subprocess.getstatusoutput("chown " + username + " " + login_script_file_init_name + " && chmod 500 " + login_script_file_init_name)
	print("正在初始化用户登陆脚本")
	#print(rrs)
	print("用户" + username + "登陆脚本创建成功!")	


if __name__ == "__main__":
	get_user_service_hosts()
	print(json.dumps(users_hosts))
	# 为用户创建登陆脚本
	for user in get_usernames():
		username = user[1]
		create_shell_user(username)
		# 为用户添加登陆脚本
		create_user_login_script(username)
