---
title: flask-uwsgi-nginx部署
date: 2016-11-08 23:47:19
tags: init
categories: init
toc: true
---

如何使用uwsgi、nginx部署flask app

# flask app



``` python
#!/usr/bin/python
# coding: utf8

# /search/service/nginx/html/opWeb/index.py

from flask import Flask
from flask.ext.script import Manager

import ldap

app = Flask(__name__)
manager = Manager(app)


@app.route("/")
def index():
    return "hexo"

@app.route("/hexo")
def hexo():
    return "hexo"

if __name__ == "__main__":
    manager.run()
```



``` bash
# /search/service/nginx/html/opWeb/start_opweb.sh
python index.py runserver --host 0.0.0.0 --port 6555 --debug --reload

cat << EOF > /dev/null
optional arguments:
  -?, --help            show this help message and exit
  -h HOST, --host HOST
  -p PORT, --port PORT
  --threaded
  --processes PROCESSES
  --passthrough-errors
  -d, --debug           enable the Werkzeug debugger (DO NOT use in production
                        code)
  -D, --no-debug        disable the Werkzeug debugger
  -r, --reload          monitor Python files for changes (not 100{'const':
                        True, 'help': 'monitor Python files for changes (not
                        100% safe for production use)', 'option_strings':
                        ['-r', '--reload'], 'dest': 'use_reloader',
                        'required': False, 'nargs': 0, 'choices': None,
                        'default': None, 'prog': 'index.py runserver',
                        'container': <argparse._ArgumentGroup object at
                        0x7feaab483ed0>, 'type': None, 'metavar': None}afe for
                        production use)
  -R, --no-reload       do not monitor Python files for changes
EOF
```



python环境为pyenv安装的Python 2.7.12

切换到特定用户(Python 2.7.12环境)



``` bash
# 启动脚本
$ sh start_opweb.sh
/home/guest/.pyenv/versions/2.7.12/lib/python2.7/site-packages/flask/exthook.py:71: ExtDeprecationWarning: Importing flask.ext.script is deprecated, use flask_script instead.
  .format(x=modname), ExtDeprecationWarning
auth fail
auth success
 * Running on http://0.0.0.0:6555/ (Press CTRL+C to quit)
 * Restarting with stat
/home/guest/.pyenv/versions/2.7.12/lib/python2.7/site-packages/flask/exthook.py:71: ExtDeprecationWarning: Importing flask.ext.script is deprecated, use flask_script instead.
  .format(x=modname), ExtDeprecationWarning
auth fail
auth success
 * Debugger is active!
 * Debugger pin code: 934-549-734
 # 响应日志
127.0.0.1 - - [08/Nov/2016 23:56:33] "GET /hexo HTTP/1.1" 200 - 
 
 # 请求服务
$ curl "http://127.0.0.1:6555/hexo"
hexo
```



# 安装、使用uwsgi

``` bash
su - guest
$ pip install uwsgi -i https://pypi.douban.com/simple
```



## wsgi

``` python
#!/usr/bin/env python
# coding: utf8

# /search/service/nginx/html/opWeb/wsgi.py

from index import app
```



## uwsgi http



``` ini
; http-opWeb.ini
[uwsgi]
http = 127.0.0.1:6555
; 这里要使用socket,使用http-socket或者http都会使nginx不能和Nginx通信
stats = :9092
wsgi-file = /search/service/nginx/html/opWeb/wsgi.py
; 这里要使用绝对路径,我操
callable = app
uid = guest
gid = guest
chdir = /search/service/nginx/html/opWeb
master = true
processes = 4
pidfile = /var/run/uwsgi/opWeb.pid
daemonize = /search/service/uwsgi/logs/uwsgi_opWeb.log
```

使用uwsgi启动python app时，必须在guest用户下，因为只有guest用户下才有uwsgi程序和相应的flask环境，因此上面非常重要的一点是指定uid和gid为guest用户。

另外，需要修改对应目录、文件的属主数组

``` bash
$ chown -R guest.guest /var/run/uwsgi/
$ chown -R guest.guest /search/service/uwsgi/logs/
$ chown -R guest.guest /search/service/nginx/html/opWeb
```



还有一点需要注意，坑死老子了，就是**wsgi-file最好使用 绝对路径**

启动

``` bash
uwsgi http-opWeb.ini
$ curl "http://127.0.0.1:6555/hexo"
hexo
# 以下为日志
*** Starting uWSGI 2.0.14 (64bit) on [Wed Nov  9 00:09:41 2016] ***
compiled with version: 4.4.7 20120313 (Red Hat 4.4.7-17) on 08 November 2016 21:45:00
os: Linux-2.6.32-431.11.25.el6.ucloud.x86_64 #1 SMP Tue Jul 19 10:06:12 EDT 2016
nodename: opdev
machine: x86_64
clock source: unix
detected number of CPU cores: 1
current working directory: /search/service/nginx/html/opWeb
writing pidfile to /var/run/uwsgi/opWeb.pid
detected binary path: /home/guest/.pyenv/versions/2.7.12/bin/uwsgi
!!! no internal routing support, rebuild with pcre support !!!
chdir() to /search/service/nginx/html/opWeb
your processes number limit is 1024
your memory page size is 4096 bytes
detected max file descriptor number: 1000000
lock engine: pthread robust mutexes
thunder lock: disabled (you can enable it with --thunder-lock)
uWSGI http bound on 127.0.0.1:6555 fd 4
uwsgi socket 0 bound to TCP address 127.0.0.1:60310 (port auto-assigned) fd 3
Python version: 2.7.12 (default, Oct 28 2016, 09:29:48)  [GCC 4.4.7 20120313 (Red Hat 4.4.7-17)]
*** Python threads support is disabled. You can enable it with --enable-threads ***
Python main interpreter initialized at 0x17b8690
your server socket listen backlog is limited to 100 connections
your mercy for graceful operations on workers is 60 seconds
mapped 363840 bytes (355 KB) for 4 cores
*** Operational MODE: preforking ***
/home/guest/.pyenv/versions/2.7.12/lib/python2.7/site-packages/flask/exthook.py:71: ExtDeprecationWarning: Importing flask.ext.script is deprecated, use flask_script instead.
  .format(x=modname), ExtDeprecationWarning
WSGI app 0 (mountpoint='') ready in 1 seconds on interpreter 0x17b8690 pid: 15838 (default app)
*** uWSGI is running in multiple interpreter mode ***
spawned uWSGI master process (pid: 15838)
spawned uWSGI worker 1 (pid: 15877, cores: 1)
spawned uWSGI worker 2 (pid: 15878, cores: 1)
spawned uWSGI worker 3 (pid: 15879, cores: 1)
spawned uWSGI worker 4 (pid: 15880, cores: 1)
*** Stats server enabled on :9092 fd: 18 ***
spawned uWSGI http 1 (pid: 15881)
[pid: 15880|app: 0|req: 1/1] 127.0.0.1 () {28 vars in 394 bytes} [Wed Nov  9 00:10:29 2016] GET /hexo => generated 4 bytes in 2 msecs (HTTP/1.1 200) 2 headers in 78 bytes (1 switches on core 0)
# 上面这条就是响应

```



## uwsgi http-socket



``` ini
; httpsocket-opWeb.ini
[uwsgi]
http-socket = 127.0.0.1:6555
; 这里要使用socket,使用http-socket或者http都会使nginx不能和Nginx通信
stats = :9092
wsgi-file = /search/service/nginx/html/opWeb/wsgi.py
; 这里要使用绝对路径,我操
callable = app
uid = guest
gid = guest
chdir = /search/service/nginx/html/opWeb
master = true
processes = 4
pidfile = /var/run/uwsgi/opWeb.pid
daemonize = /search/service/uwsgi/logs/uwsgi_opWeb.log
```

这里只改动了http为http-socket，依然可以通过6555端口使用http协议访问



## uwsgi socket ip:port

``` ini
; socket-opWeb.ini
[uwsgi]
socket = 127.0.0.1:6555
; 这里要使用socket,使用http-socket或者http都会使nginx不能和Nginx通信
stats = :9092
wsgi-file = /search/service/nginx/html/opWeb/wsgi.py
; 这里要使用绝对路径,我操
callable = app
uid = guest
gid = guest
chdir = /search/service/nginx/html/opWeb
master = true
processes = 4
pidfile = /var/run/uwsgi/opWeb.pid
daemonize = /search/service/uwsgi/logs/uwsgi_opWeb.log
```

这里修改httpsocket为socket，仍然可以通过http形式访问

```bash
# uwsgi socket 0 bound to TCP address 127.0.0.1:6555 fd 3
$ curl "http://127.0.0.1:6555/hexo"
hexo
```



## uwsgi socket socket file

```ini
; socketfile-opWeb.ini
[uwsgi]
socket = /var/run/uwsgi/uwsgi.sock
; 这里要使用socket,使用http-socket或者http都会使nginx不能和Nginx通信
stats = :9092
; stats表示uwsgi的统计服务端口
wsgi-file = /search/service/nginx/html/opWeb/wsgi.py
; 这里要使用绝对路径,我操
callable = app
uid = guest
gid = guest
chdir = /search/service/nginx/html/opWeb
master = true
processes = 4
pidfile = /var/run/uwsgi/opWeb.pid
daemonize = /search/service/uwsgi/logs/uwsgi_opWeb.log
```



``` bash
# uwsgi socket 0 bound to UNIX address /var/run/uwsgi/uwsgi.sock fd 3

curl "http://127.0.0.1:6555/hexo"
curl: (7) couldn't connect to host

```



# uwsgi + nginx



## 方式一

**http = 127.0.0.1:6555**方式启动

``` nginx

uWSGI http bound on 127.0.0.1:6555 fd 4
uwsgi socket 0 bound to TCP address 127.0.0.1:56228 (port auto-assigned) fd 3

$ ss -ntl
State      Recv-Q Send-Q                         Local Address:Port                           Peer Address:Port
LISTEN     0      128                                        *:80                                        *:*
LISTEN     0      128                                       :::22                                       :::*
LISTEN     0      128                                        *:22                                        *:*
LISTEN     0      100                                127.0.0.1:6555                                      *:*
LISTEN     0      100                                        *:9092                                      *:*
LISTEN     0      100                                127.0.0.1:56228                                     *:*
```

可以看到在启动http服务的同时也启动了一个TCP socket，

在这里，如果把Nginx的uwsgi_pass修改为**127.0.0.1:56228**那么client还是可以访问flask web页面的，但是如果使用默认的6555就是一个http协议的端口，Nginx无法代理。



## 方式二

**http-socket = 127.0.0.1:6555**方式启动



``` bash
uwsgi socket 0 bound to TCP address 127.0.0.1:6555 fd 3


LISTEN     0      100                                127.0.0.1:6555                                      *:*
```

这种方式client访问将会出现502错误

``` verilog
120.52.92.188 - - [09/Nov/2016:00:59:32 +0800] "GET /hexo HTTP/1.1" 502 575 "-" "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.71 Safari/537.36" "-"
  
# Nginx错误日志
  
  2016/11/09 00:59:31 [error] 22256#0: *1 upstream prematurely closed connection while reading response header from upstream, client: 120.52.92.188, server: lilyzt.com, request: "GET /hexo HTTP/1.1", upstream: "uwsgi://127.0.0.1:6555", host: "lilyzt.com"

```

而且uwsgi服务根本没有和Nginx产生任何的交互

那么Nginx正确的配置方式应该是使用http协议而不再是uwsgi协议



``` nginx
upstream httpsocket_uwsgi {
    server 127.0.0.1:6555;
}

server {
    listen       80;
    server_name  lilyzt.com;
    client_max_body_size 16m;
    client_body_buffer_size 256k;

    proxy_buffering     on;
    proxy_buffer_size   4k;
    proxy_buffers   8   32k;
    sendfile on;
    keepalive_timeout 0;
    location ~ / {
      root /search/service/nginx/html/opWeb;
      access_log  /search/service/nginx/logs/opWeb.log main;
      proxy_pass http://httpsocket_uwsgi;
      #uwsgi_pass 127.0.0.1:6555;  # 指向uwsgi 所应用的内部地址,所有请求将转发给uwsgi 处理
      #uwsgi_param UWSGI_CHDIR  /search/service/nginx/html/opWeb; # 指向网站根目录
      #uwsgi_connect_timeout 600;
      #uwsgi_read_timeout 600;
      #uwsgi_param UWSGI_MODULE index;
      #uwsgi_param UWSGI_CALLABLE app;
      #include     uwsgi_params;
    }
}
```

以上这种配置就能正常的访问flask web提供的服务了







## 方式三

**socket = 127.0.0.1:6555** 方式

这种方式下Nginx的配置如下:



``` nginx
server {
    listen       80;
    server_name  lilyzt.com;
    client_max_body_size 16m;
    client_body_buffer_size 256k;

    proxy_buffering     on;
    proxy_buffer_size   4k;
    proxy_buffers   8   32k;
    sendfile on;
    keepalive_timeout 0;
    location ~ / {
      root /search/service/nginx/html/opWeb;
      access_log  /search/service/nginx/logs/opWeb.log main;
      uwsgi_pass 127.0.0.1:6555;  # 指向uwsgi 所应用的内部地址,所有请求将转发给uwsgi 处理
      uwsgi_param UWSGI_CHDIR  /search/service/nginx/html/opWeb; # 指向网站根目录
      uwsgi_connect_timeout 600;
      uwsgi_read_timeout 600;
      uwsgi_param UWSGI_MODULE index;
      uwsgi_param UWSGI_CALLABLE app;
      include     uwsgi_params;
    }
}

```





## 方式四

**socket = /var/run/uwsgi/uwsgi.sock**方式

``` ini
; socketfile-opWeb.ini
[uwsgi]
socket = /var/run/uwsgi/uwsgi.sock
; 这里要使用socket,使用http-socket或者http都会使nginx不能和Nginx通信
stats = :9092
; stats表示uwsgi的统计服务端口
wsgi-file = /search/service/nginx/html/opWeb/wsgi.py
; 这里要使用绝对路径,我操
callable = app
uid = guest
gid = guest
chdir = /search/service/nginx/html/opWeb
master = true
processes = 4
pidfile = /var/run/uwsgi/opWeb.pid
daemonize = /search/service/uwsgi/logs/uwsgi_opWeb.log
```

**这里要记得修改/var/run/uwsgi/的属主数组**

``` bash
$ chown -R guest.guest /var/run/uwsgi/
```



启动uwsgi

``` bash
[guest@opdev opWeb]$ uwsgi socketfile-opWeb.ini
[uWSGI] getting INI configuration from socketfile-opWeb.ini

LISTEN     0      100                                        *:9092                                      *:*

# uwsgi socket 0 bound to UNIX address /var/run/uwsgi/uwsgi.sock fd 3
```

这种方式启动并不会开启TCP端口监听



因此Nginx的配置应该如下:

``` nginx
server {
    listen       80;
    server_name  lilyzt.com;
    client_max_body_size 16m;
    client_body_buffer_size 256k;

    proxy_buffering     on;
    proxy_buffer_size   4k;
    proxy_buffers   8   32k;
    sendfile on;
    keepalive_timeout 0;
    location ~ / {
      root /search/service/nginx/html/opWeb;
      access_log  /search/service/nginx/logs/opWeb.log main;
      #proxy_pass http://httpsocket_uwsgi;
      uwsgi_pass unix:///var/run/uwsgi/uwsgi.sock;  # 指向uwsgi 所应用的内部地址,所有请求将转发给uwsgi 处理
      uwsgi_param UWSGI_CHDIR  /search/service/nginx/html/opWeb; # 指向网站根目录
      uwsgi_connect_timeout 600;
      uwsgi_read_timeout 600;
      uwsgi_param UWSGI_MODULE index;
      uwsgi_param UWSGI_CALLABLE app;
      include     uwsgi_params;
    }
}

```

上面把uwsgi的协议方式修改为了unix socket方式



浪费了老子这么多时间，可是人家早就在文档中写好了，不冷静下来看文档也就只能到处搜一下乱七八糟千篇一律浪费时间的玩意儿。



> The `http-socket ` option will make uWSGI natively speak HTTP. If your web server does not support the [*uwsgi protocol*](http://uwsgi-docs.readthedocs.io/en/latest/Protocol.html) but is able to speak to upstream HTTP proxies, or if you are using a service like Webfaction or Heroku to host your application, you can use `http-socket`. If you plan to expose your app to the world with uWSGI only, use the `http` option instead, as the router/proxy/load-balancer will then be your shield.
>
> 

人家都说了要么使用socket方式，要么使用http-socket+http方式，要么使用uwsgi裸奔，浪费我时间。



另外，还有一点是uwsgi有的时候也会产生core文件哦~

![uwsgi core file](http://lilyzt.com/hexo/image/flask-uwsgi-nginx%E9%83%A8%E7%BD%B2/01.png)



[Http Native Support](http://uwsgi-docs.readthedocs.io/en/latest/HTTP.html#native-http-support)

