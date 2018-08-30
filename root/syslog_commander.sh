#! /bin/bash

# This runs all .sh rule alert files

#exec >>/root/debug.log 2>>/root/debug.err.log

#set -x
#set -x; exec 2>/root/commander_debug.log

targets=$(find /root/syslog_rules/*.sh)

for shells in $targets
do
   $shells
done







