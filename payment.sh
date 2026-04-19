#!/bin/bash

source ./common.sh

APP_NAME=payment

check_root
APP_SETUP

PYTHON_SETUP

SYSTEMD_SETUP

PRINT_TOTAL_TIME