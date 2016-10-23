#!/usr/bin/expect

set user husa
set timeout 30
spawn ssh -l $husa 192.168.133.131
expect "*password:*"
send "root/r"
interact
expect eof
