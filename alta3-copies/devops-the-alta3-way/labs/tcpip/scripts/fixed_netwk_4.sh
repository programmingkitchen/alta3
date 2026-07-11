#!/bin/bash

sudo ip netns exec prouter ip addr del 10.1.1.1/30 dev prout2pbrg
sudo ip netns exec prouter ip addr add 10.1.1.1/24 dev prout2pbrg
