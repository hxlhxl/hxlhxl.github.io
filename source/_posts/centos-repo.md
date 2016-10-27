---
title: centos-repo
date: 2016-10-26 12:54:12
tags: init
categories: init
toc: true
---
centos 常用源安装方式

# epel

``` bash
rpm -ivh http://download.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-6
```


# remi

``` bash
rpm -ivh http://rpms.famillecollet.com/enterprise/remi-release-6.rpm
rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-remi
```
