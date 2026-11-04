#!/bin/bash

app_name=user
source ./common.sh

app_setup
nodejs_setup
systemd_setup

restart
total_time