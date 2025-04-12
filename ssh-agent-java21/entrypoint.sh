#!/bin/bash

# Khởi động SSH server
exec /usr/sbin/sshd -D

java -jar agent.jar -url http://10.255.255.254:8080/ -secret a7bd952bb35be64d1f7bb181c8bc959795303f1b5b1fd6d41ad462ff250c35b3 -name "first-node" -webSocket -workDir "/jenkins-worker"