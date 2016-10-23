---
title: hexo+github
date: 2016-10-24 02:27:06
tags: hexo
categories: init
toc: true

---
install hexo on arch linux

# 安装nodejs、npm和hexo

``` bash
pacman -S nodejs
pacman -S npm
npm install -g hexo

[root@ArchLinux-husa hexo]# pacman -Qo /usr/bin/node
/usr/bin/node is owned by nodejs 6.9.1-1
```



# 给npm换源

``` bash
[root@ArchLinux-husa ~]# cat ~/.npmrc 
registry = https://registry.npm.taobao.org
```

# 配置blog

``` bash
mkdir -pv /search/huaxiong/hexo
cd hexo
hexo init
	... long wait...
hexo generate
hexo server
```

此时可以访问arch linux地址：http://192.168.133.131:4000，能够看到landscape主题的Hello World


# 配置github ssh

## ssh
``` bash
[root@ArchLinux-husa ~]# 
[root@ArchLinux-husa ~]# ssh-keygen -t rsa -b 4096 -C "************@126.com"	# 
[root@ArchLinux-husa ~]# ssh -T git@github.com
The authenticity of host 'github.com (192.30.253.112)' can't be established.
RSA key fingerprint is SHA256:nThbg6kXUpJWGl7E1IGOCspRomTxdCARLviKw6E5SY8.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added 'github.com,192.30.253.112' (RSA) to the list of known hosts.
Hi ******! You've successfully authenticated, but GitHub does not provide shell access.

[root@ArchLinux-husa github]# git config --global user.name "******"
[root@ArchLinux-husa github]# git config --global user.email "************@126.com"

```

## github

new repository --> [repository name]为 github_account_name.github.io --> create
settings --> SSH and GPG keys --> new SSH key --> copy ssh pub key



# hexo配置

``` bash

vim /search/huaxiong/hexo/_config.yml
	content below:
		url: http://hxlhxl.github.io
		deploy:
		  type: git
		    repository: https://github.com/hxlhxl/hxlhxl.github.io.git
			  branch: master
```

添加git deploye工具

``` bash
[root@ArchLinux-husa github]# npm install hexo-deployer-git --save
```


# write blog

``` bash
[root@ArchLinux-husa hexo]# hexo new "hello"
 INFO  Created: /search/huaxiong/hexo/source/_posts/hello.md
# deploy
hexo clean
hexo generate
hexo deploy
```



# 安装theme

``` bash
		  cd /search/huaxiong/hexo

		  git clone https://github.com/tufu9441/maupassant-hexo.git themes/maupassant
		  npm install hexo-renderer-jade --save
		  npm install hexo-renderer-sass --save

		  以上命令可能因为网络原因不成功，则使用cnpm
		  npm install -g cnpm --registry=https://registry.npm.taobao.org

		  cnpm install hexo-renderer-sass --save
```



# 配置主题


# write blog ...

``` bash
vim hello.md
---
title: hexo+github
date: 2016-10-24 02:27:06
tags: hexo
categories: init
toc: true
---
abstract
# title1
## title2
markdown syntax ...

```

# END

---- end ----

``` bash
		  npm op

		  npm install -g hexo
		  hexo init hexo
		  npm install hexo-deployer-git --save
		  git clone https://github.com/tufu9441/maupassant-hexo.git themes/maupassant
		  npm install hexo-renderer-jade --save
		  npm install hexo-renderer-sass --save
```
