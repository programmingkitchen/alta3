#!/bin/bash
    
red="\033[31m"

sudo ip netns exec wrouter ip addr del 10.1.3.1/24 dev wrout2wbrg

printf "${red}\nOOPS! Network down. :(\n\n"

