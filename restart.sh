#!/bin/bash

#env file
. ~/nginx-phpfpm-mysql-phpmyadmin/.env

cd $HOMEDIR

docker-compose restart
