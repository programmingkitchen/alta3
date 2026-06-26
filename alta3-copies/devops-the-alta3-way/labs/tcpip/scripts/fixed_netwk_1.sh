#!/bin/bash

sudo ip link set dev obrg2orout up
sudo ip link set dev obrg2ohost up

sudo ip netns exec ohost ping 10.1.2.21 -c 1
ping 10.1.4.21 -c 1
