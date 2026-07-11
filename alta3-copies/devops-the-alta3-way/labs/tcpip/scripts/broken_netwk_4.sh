#!/bin/bash

red="\033[31m"

sudo ip netns exec prouter ip addr del 10.1.1.1/24 dev prout2pbrg
sudo ip netns exec prouter ip addr add 10.1.1.1/30 dev prout2pbrg

printf "${red}\nATTENTION, networker! The network is DOWN!!! :( Better get to work!\n\n"
