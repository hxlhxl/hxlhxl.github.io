---
title: SSH用户认证
date: 2016-11-08 13:32:30
tags: SSH
categories: system_admin
toc: true
---

普通用户的SSH认证



# 认证

``` bash
# 新建用户
useradd guest
echo "guest" | passwd --stdin guest

su - guest
ssh-kengen

cd .ssh
vim authorized_keys
	"向以上文件放入公钥"

# 最重要的一步，就是权限的问题，如果文件权限有问题，就会出现即使复制了公钥，仍然不能实现无密认证

​```
[root@OpConsole ~]# ll .ssh
总用量 596
-rw------- 1 root root   2903 10月  2 18:33 authorized_keys
-rw-r--r-- 1 root root    214 9月  27 09:55 config
-rw------- 1 root root   1675 8月   6 00:03 id_rsa
-rw-r--r-- 1 root root    400 8月   6 00:03 id_rsa.pub
-rw-r--r-- 1 root root 586016 11月  8 11:05 known_hosts
​```
chmod 600 authorized_keys
```



**authorized_keys 文件的权限要是600**