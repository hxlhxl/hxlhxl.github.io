---
title: 一次SSH认证失败
date: 2016-11-07 08:32:17
tags: SSH
categories: system_admin
toc: true
---

一次SSH认证失败，初始化机器之后SSH认证失败调试。。。

# 如何调试?

## 关闭sshd服务

## 开启sshd调试模式
最后连接查看 认证失败原因

``` bash
[root@10-10-155-146 ~]# /usr/sbin/sshd -d
debug1: sshd version OpenSSH_5.3p1
debug1: read PEM private key done: type RSA
debug1: private host key: #0 type 1 RSA
debug1: read PEM private key done: type DSA
debug1: private host key: #1 type 2 DSA
debug1: rexec_argv[0]='/usr/sbin/sshd'
debug1: rexec_argv[1]='-d'
Set /proc/self/oom_score_adj from 0 to -1000
debug1: Bind to port 22 on 0.0.0.0.
Server listening on 0.0.0.0 port 22.
debug1: Bind to port 22 on ::.
Server listening on :: port 22.
debug1: Server will not fork when running in debugging mode.
debug1: rexec start in 5 out 5 newsock 5 pipe -1 sock 8
debug1: inetd sockets after dupping: 3, 3
Connection from 10.10.228.212 port 48662
debug1: Client protocol version 2.0; client software version OpenSSH_5.3
debug1: match: OpenSSH_5.3 pat OpenSSH*
debug1: Enabling compatibility mode for protocol 2.0
debug1: Local version string SSH-2.0-OpenSSH_5.3
debug1: permanently_set_uid: 74/74
debug1: list_hostkey_types: ssh-rsa,ssh-dss
debug1: SSH2_MSG_KEXINIT sent
debug1: SSH2_MSG_KEXINIT received
debug1: kex: client->server aes128-ctr hmac-md5 none
debug1: kex: server->client aes128-ctr hmac-md5 none
debug1: SSH2_MSG_KEX_DH_GEX_REQUEST received
debug1: SSH2_MSG_KEX_DH_GEX_GROUP sent
debug1: expecting SSH2_MSG_KEX_DH_GEX_INIT
debug1: SSH2_MSG_KEX_DH_GEX_REPLY sent
debug1: SSH2_MSG_NEWKEYS sent
debug1: expecting SSH2_MSG_NEWKEYS
debug1: SSH2_MSG_NEWKEYS received
debug1: KEX done
debug1: userauth-request for user root service ssh-connection method none
debug1: attempt 0 failures 0
debug1: PAM: initializing for "root"
debug1: userauth-request for user root service ssh-connection method publickey
debug1: attempt 1 failures 0
debug1: test whether pkalg/pkblob are acceptable
debug1: PAM: setting PAM_RHOST to "10.10.228.212"
debug1: PAM: setting PAM_TTY to "ssh"
debug1: temporarily_use_uid: 0/0 (e=0/0)
debug1: trying public key file /root/.ssh/authorized_keys
debug1: fd 4 clearing O_NONBLOCK
Authentication refused: bad ownership or modes for directory /root
debug1: restore_uid: 0/0
debug1: temporarily_use_uid: 0/0 (e=0/0)
  bug1: trying public key file /root/.ssh/authorized_keys2
debug1: Could not open authorized keys '/root/.ssh/authorized_keys2': No such file or directory
debug1: restore_uid: 0/0
Failed publickey for root from 10.10.228.212 port 48662 ssh2
```

可以看到原因为 ** '/root/.ssh/authorized_keys2': No such file or directory**

当初出现这个原因好像是 直接把 id_rsa.pub复制到authorized_keys文件中了，而ssh还没有生成这个文件。。。