---
title: init-pyenv
date: 2016-10-28 00:01:58
tags: init
categories: init
toc: true
---

CentOS 6 x86_64 安装pyenv多版本python环境

# init

auth.sh

# install

``` bash
# pyenv.sh
# sh pyenv.sh guest
#!/bin/bash
USER_NAME=$1
groupadd $USER_NAME
useradd -s /bin/bash -d /home/$USER_NAME -g $USER_NAME $USER_NAME
echo $USER_NAME |passwd $USER_NAME --stdin
runuser -l $USER_NAME -c 'curl -L https://raw.githubusercontent.com/yyuu/pyenv-installer/master/bin/pyenv-installer | bash'
runuser -l $USER_NAME -c $'echo \'export PATH=\"~/.pyenv/bin:$PATH\"\'' >> /home/$USER_NAME/.bash_profile
runuser -l $USER_NAME -c $'echo \'eval \"$(pyenv init -)\"\'' >> /home/$USER_NAME/.bash_profile
runuser -l $USER_NAME -c $'echo \'eval \"$(pyenv virtualenv-init -)\"\'' >> /home/$USER_NAME/.bash_profile

su - $USER_NAME -c "pyenv install 2.7.12"
su - $USER_NAME -c "pyenv global 2.7.12"
```

# pyenv 安装 virtualenv

``` bash
su - guest
pyenv virtualenv 2.7.12 venv
pyenv activate venv	# 激活venv虚拟环境
```


# 安装各种python包

``` bash
vim requiremet.txt

	cffi==1.8.3
	cryptography==1.5.2
	enum34==1.1.6
	gevent==1.1.2
	greenlet==0.4.10
	idna==2.1
	ipaddress==1.0.17
	lxml==3.6.4
	mechanize==0.2.5
	MySQL-python==1.2.5
	ndg-httpsclient==0.4.2
	pyasn1==0.1.9
	pycparser==2.16
	pyOpenSSL==16.2.0
	PySocks==1.5.7
	redis==2.10.5
	requests==2.11.1
	six==1.10.0
	user-agent==0.1.5
# 使用豆瓣pip源
pip install -r requirement.txt -i https://pypi.douban.com/simple
# 如果遇到安装MySQL-python错误就安装一下两个包
yum install mysql-devel
yum install mysql-server
```

# 使用
https://github.com/yyuu/pyenv#command-reference 
https://github.com/yyuu/pyenv/blob/master/COMMANDS.md#pyenv-install
