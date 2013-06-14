#!/usr/bin/bash
port=9999
user="ubuntu"
host="10.0.3.80"
scp -P ${port} *.rb cpu.c ${user}@${host}:~/
ssh -p ${port} ${user}@${host} mkdir contests
