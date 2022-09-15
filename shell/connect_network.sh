#! /bin/bash
ip link set wlp4s0 up
wpa_supplicant -i wlp4s0 -c /home/zh/home.conf &
dhcpcd &

