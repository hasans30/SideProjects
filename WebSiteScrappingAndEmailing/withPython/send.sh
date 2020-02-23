#!/bin/bash
pushd /home/pi/sendemail
export EMAILHELP="password"
export EMAILTO="to_someone@gmail.com"
export EMAILUSER="from_someone@live.com"
python3 /home/username/sendemail/getInfo.py
