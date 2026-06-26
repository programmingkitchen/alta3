#!/bin/bash

grn="\033[32m"
wht="\033[0m"

set -eou pipefail

# ethernet bridges
printf "${grn}Setting Ethernet Bridges${wht}\n"
sudo ip link add name pbridge type bridge
sudo ip link add name obridge type bridge
sudo ip link add name ybridge type bridge
sudo ip link add name wbridge type bridge
sudo ip link set dev pbridge up
sudo ip link set dev obridge up
sudo ip link set dev ybridge up
sudo ip link set dev wbridge up
brctl show

