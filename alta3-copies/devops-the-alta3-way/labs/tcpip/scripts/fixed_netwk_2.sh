#!/bin/bash

sudo ip netns exec wrouter ip addr add 10.1.3.1/24 dev wrout2wbrg
sudo ip netns exec whost ping 10.1.1.21
ping 10.1.3.21
