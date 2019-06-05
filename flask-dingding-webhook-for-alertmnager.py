#!/usr/bin/env python
# -*- coding:utf8 -*-
from flask import Flask
from flask import request
import json
import requests
import logging

logging.basicConfig(level=logging.DEBUG,filename='/var/log/supervisor/logs/out-flask-dinding-webhook.log',filemode='ab+',format='%(asctime)s - %(pathname)s[line:%(lineno)d] - %(levelname)s: %(message)s')

app = Flask(__name__)

@app.route('/',methods=['POST'])
def send():
    if request.method == 'POST':
        post_data = request.get_data()
	logging.debug("初始传参:"+post_data)
	pre_data = eval(post_data)['alerts'][0]
	s_data = '"当前状态: ' + pre_data['status'] + '\n'
        s_data += '事件详情: ' + pre_data['annotations']['summary'] + '\n'
        s_data += '事件描述: ' + pre_data['annotations']['description'] + '\n'
        s_data += '事件开始时间: ' + pre_data['startsAt'] + '\n'
        s_data += '事件结束时间: ' + pre_data['endsAt'] + '\n'
        s_data += '---事件级别--: ' + pre_data['labels']['severity'] + '\n'
        s_data += '---事件主机--: ' + pre_data['labels']['instance'] + '\n'
        s_data += '---事件名称--: ' + pre_data['labels']['alertname'] + '\n'
        s_data += '---事件环境--: ' + pre_data['labels']['env'] + '\n'
        s_data += '---事件主机组--: ' + pre_data['labels']['group'] + '\n'
        s_data += '---prometheus_job名称--: ' + pre_data['labels']['job'] + '\n"'
	logging.debug("content解析内容为:"+s_data)
        rs = alert_data(s_data)
    	return rs

def alert_data(data):
    url = 'https://oapi.dingtalk.com/robot/send?access_token=366aa022ece9892c528ac896b7ab61a332107739ea1d46d3946750876b305808'
    send_data = '{"msgtype": "text","text": {"content": %s}}' %(data)
    logging.debug(send_data)
    rs = requests.post(url,headers={"Content-type": "application/json"},data=send_data)
    logging.debug("钉钉服务器返回结果为:"+repr(rs.text))
    return rs.text

if __name__ == '__main__':
    app.run(host='0.0.0.0',port='8061',debug=True)
