#!/bin/bash
  
red="\033[31m"

sudo ip link set dev obrg2ohost down
sudo ip link set dev obrg2orout down

printf "${red}\nCongratulations! You have a busted network :(\n\n"
