#!/bin/bash

red="\033[31m"

sudo ip netns exec yhost ip route del default via 10.1.2.1

printf "${red}ATTENTION, networker! The network is DOWN!!! :( Better get to work!\n\n"

