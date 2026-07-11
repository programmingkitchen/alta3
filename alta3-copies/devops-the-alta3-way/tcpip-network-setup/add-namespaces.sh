#!/bin/bash

grn="\033[32m"
wht="\033[0m"

set -eou pipefail

# namespace
printf "${grn}Setting up the network namespaces${wht}\n"
sudo ip netns add ohost
sudo ip netns add phost    
sudo ip netns add whost
sudo ip netns add yhost
sudo ip netns add prouter
sudo ip netns add yrouter
sudo ip netns add wrouter
sudo ip netns add orouter
sudo ip netns add crouter
sudo ip netns

