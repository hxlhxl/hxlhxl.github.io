---
title: init-openldap
date: 2016-10-27 23:50:49
tags: init
categories: init
toc: true
---
CentOS 6.5 x86_64安装openldap

# install

``` bash
yum install openldap openldap-servers openldap-clients openldap-devel compat-openldap –y
```

# config

``` bash
cp /usr/share/openldap-servers/DB_CONFIG.example /var/lib/ldap/DB_CONFIG 
cp /usr/share/openldap-servers/slapd.conf.obsolete /etc/openldap/slapd.conf 
chown -R ldap.ldap /etc/openldap/
chown -R ldap.ldap /var/lib/ldap
```

/etc/openldap/slapd.conf配置如下

``` bash
include		/etc/openldap/schema/corba.schema
include		/etc/openldap/schema/core.schema
include		/etc/openldap/schema/cosine.schema
include		/etc/openldap/schema/duaconf.schema
include		/etc/openldap/schema/dyngroup.schema
include		/etc/openldap/schema/inetorgperson.schema
include		/etc/openldap/schema/java.schema
include		/etc/openldap/schema/misc.schema
include		/etc/openldap/schema/nis.schema
include		/etc/openldap/schema/openldap.schema
include		/etc/openldap/schema/ppolicy.schema
include		/etc/openldap/schema/collective.schema
allow bind_v2
pidfile		/var/run/openldap/slapd.pid
argsfile	/var/run/openldap/slapd.args
TLSCACertificatePath /etc/openldap/certs
TLSCertificateFile "\"OpenLDAP Server\""
TLSCertificateKeyFile /etc/openldap/certs/password
database config
access to *
	by dn.exact="gidNumber=0+uidNumber=0,cn=peercred,cn=external,cn=auth" manage
	by * none
database monitor
access to *
	by dn.exact="gidNumber=0+uidNumber=0,cn=peercred,cn=external,cn=auth" read
        by dn.exact="cn=Manager,dc=my-domain,dc=com" read
        by * none
database	bdb
suffix		"dc=hust,dc=com"
checkpoint	1024 15
rootdn		"cn=OP,dc=hust,dc=com"
rootpw	{SSHA}2I0JT/mtt6VHbg255Jad0MKpkP5c/dIw
access to attrs="userPassword"
        by anonymous auth
        by self write
        by * none
access to *
        by self write
        by users read
directory	/var/lib/ldap
index objectClass                       eq,pres
index ou,cn,mail,surname,givenname      eq,pres,sub
index uidNumber,gidNumber,loginShell    eq,pres
index uid,memberUid                     eq,pres,sub
index nisMapName,nisMapEntry            eq,pres,sub
```

其中rootpw使用以下命令生成

``` bash
[root@hexo ~]# slappasswd -s helloworld
{SSHA}SawfQ13np3BLsV74rP0eCpOhjp6p090M
```

配置好配置文件之后使用一下命令生成检查、生成规则

``` bash

```

如果报错db_open(/var/lib/ldap/id2entry.bdb) failed: No such file or directory (2).
1、安装db4
2、修改权限
3、启动一次ldap再执行命令
```bash
yum install db4 -y
chown -R ldap.ldap /etc/openldap/
chown -R ldap.ldap /var/lib/ldap
[root@hexo openldap]# service slapd start
slaptest -f /etc/openldap/slapd.conf
config file testing succeeded
```

执行之后还有一个坑，就是有一些配置没有写入，再次执行以下命令

``` bash
rm -rf /etc/openldap/slapd.d/*
slaptest -f /etc/openldap/slapd.conf -F /etc/openldap/slapd.d
chown -R ldap.ldap /etc/openldap/slapd.d
# 重启ldap
service slapd restart

```


# init person

创建people.ldif文件
```
# root
dn: dc=hust,dc=com
objectClass: top
objectClass: dcObject
objectclass: organization
o: hust com
dc: hust

# root --> people
dn: ou=people,dc=hust,dc=com
objectClass: organizationalUnit
ou: people

# root --> people --> person
dn: cn=shirley,ou=people,dc=hust,dc=com
ou: people
cn: shirley
givenname: 思宇
mail: huasiyu@gmail.com
objectclass: inetOrgPerson
objectclass: top
objectclass: organizationalPerson
sn: 华
userpassword: {SSHA}l3LfJOnYl0gADuhnYmRPxa/24ktP4E0J

```

ldif文件具有固定的格式，出错则添加entry会失败，要注意

创建entry
```
[root@hexo init]# !lda
ldapadd -x -D "cn=OP,dc=hust,dc=com" -w ldap -f people.ldif
adding new entry "dc=hust,dc=com"

adding new entry "ou=people,dc=hust,dc=com"

adding new entry "cn=shirley,ou=people,dc=hust,dc=com"
```

# start

``` bash
chown -R ldap.ldap /etc/openldap/
chown -R ldap.ldap /var/lib/ldap
service slapd start

```


# auth




