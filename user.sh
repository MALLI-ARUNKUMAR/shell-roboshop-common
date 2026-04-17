#!/bin/bash

source ./common.sh

APP_NAME=user

check_root

APP_SETUP

NODEJS_SETUP

SYSTEMD_SETUP

PRINT_TOTAL_TIME
