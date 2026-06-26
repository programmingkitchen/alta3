#!/bin/bash

sudo ip netns exec yhost ip route add default via 10.1.2.1

ping 10.1.2.21
sudo ip netns exec yhost ping 10.1.1.21
