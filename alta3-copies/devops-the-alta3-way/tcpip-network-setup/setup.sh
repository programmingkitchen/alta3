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

# Veths
printf "${grn}Install VETHs${wht}\n"
# Connects phost to the pbridge (1)
sudo ip link add phost2pbrg type veth peer name pbrg2phost
sudo ip link set phost2pbrg netns phost
sudo ip link set dev pbrg2phost master pbridge
sudo ip link set dev pbrg2phost up

# Connects prouter to the pbridge (2)
sudo ip link add prout2pbrg type veth peer name pbrg2prout
sudo ip link set prout2pbrg netns prouter
sudo ip link set dev pbrg2prout master pbridge
sudo ip link set dev pbrg2prout up

# Connects yhost to the ybridge (3)
sudo ip link add yhost2ybrg type veth peer name ybrg2yhost
sudo ip link set yhost2ybrg netns yhost
sudo ip link set dev ybrg2yhost master ybridge
sudo ip link set dev ybrg2yhost up

# Connects yrouter to the ybridge (4)
sudo ip link add yrout2ybrg type veth peer name ybrg2yrout
sudo ip link set yrout2ybrg netns yrouter
sudo ip link set dev ybrg2yrout master ybridge
sudo ip link set dev ybrg2yrout up

# Connects whost to the wbridge (5)
sudo ip link add whost2wbrg type veth peer name wbrg2whost
sudo ip link set whost2wbrg netns whost
sudo ip link set dev wbrg2whost master wbridge
sudo ip link set dev wbrg2whost up

# Connects wrouter to the wbridge (6)
sudo ip link add wrout2wbrg type veth peer name wbrg2wrout
sudo ip link set wrout2wbrg netns wrouter
sudo ip link set dev wbrg2wrout master wbridge
sudo ip link set dev wbrg2wrout up

# Connects ohost to the obridge (7)
sudo ip link add ohost2obrg type veth peer name obrg2ohost
sudo ip link set ohost2obrg netns ohost
sudo ip link set dev obrg2ohost master obridge
sudo ip link set dev obrg2ohost up

# Connects orouter to the obridge (8)
sudo ip link add orout2obrg type veth peer name obrg2orout
sudo ip link set orout2obrg netns orouter
sudo ip link set dev obrg2orout master obridge
sudo ip link set dev obrg2orout up

# Connects prouter to crouter (9)
sudo ip link add crout2prout type veth peer name prout2crout
sudo ip link set crout2prout netns crouter
sudo ip link set prout2crout netns prouter

# Connects yrouter to crouter (10)
sudo ip link add crout2yrout type veth peer name yrout2crout
sudo ip link set crout2yrout netns crouter
sudo ip link set yrout2crout netns yrouter

# Connects wrouter to crouter (11)
sudo ip link add crout2wrout type veth peer name wrout2crout
sudo ip link set crout2wrout netns crouter
sudo ip link set wrout2crout netns wrouter

# Connects orouter to crouter (12)
sudo ip link add crout2orout type veth peer name orout2crout
sudo ip link set crout2orout netns crouter
sudo ip link set orout2crout netns orouter

# Connects crouter to nat
# Connects nat to crouter (13)
sudo ip link add crout2nat type veth peer name nat2crout
sudo ip link set crout2nat netns crouter

#Leave the other end of the veth DANGLE in the root namespace.

# IP Forwarding
printf "${grn}Setting IP Forwarding${wht}\n"
sudo sysctl net.bridge.bridge-nf-call-iptables=0
echo 'net.ipv4.ip_forward = 1
net.ipv6.conf.default.forwarding = 1
net.ipv6.conf.all.forwarding = 1' | sudo tee /etc/sysctl.d/10-ip-forwarding.conf

sudo ip netns exec prouter sysctl -p /etc/sysctl.d/10-ip-forwarding.conf
sudo ip netns exec yrouter sysctl -p /etc/sysctl.d/10-ip-forwarding.conf
sudo ip netns exec wrouter sysctl -p /etc/sysctl.d/10-ip-forwarding.conf
sudo ip netns exec orouter sysctl -p /etc/sysctl.d/10-ip-forwarding.conf
sudo ip netns exec crouter sysctl -p /etc/sysctl.d/10-ip-forwarding.conf

# Assign IP Addresses
printf "${grn}Assigning IP addresses${wht}\n"
# phost LAN link
sudo ip netns exec phost ip addr add 10.1.1.21/24 dev phost2pbrg
sudo ip netns exec phost ip link set dev phost2pbrg up
sudo ip netns exec phost ip link set dev lo up

# prouter LAN link
sudo ip netns exec prouter ip addr add 10.1.1.1/24 dev prout2pbrg
sudo ip netns exec prouter ip link set dev prout2pbrg up
sudo ip netns exec prouter ip link set dev lo up

# ohost LAN link
sudo ip netns exec ohost ip addr add 10.1.4.21/24 dev ohost2obrg
sudo ip netns exec ohost ip link set dev ohost2obrg up
sudo ip netns exec ohost ip link set dev lo up

# orouter LAN link
sudo ip netns exec orouter ip addr add 10.1.4.1/24 dev orout2obrg
sudo ip netns exec orouter ip link set dev orout2obrg up
sudo ip netns exec orouter ip link set dev lo up

# yhostA LAN link
sudo ip netns exec yhost ip addr add 10.1.2.21/24 dev yhost2ybrg
sudo ip netns exec yhost ip link set dev yhost2ybrg up
sudo ip netns exec yhost ip link set dev lo up

# yrouter LAN link
sudo ip netns exec yrouter ip addr add 10.1.2.1/24 dev yrout2ybrg
sudo ip netns exec yrouter ip link set dev yrout2ybrg up
sudo ip netns exec yrouter ip link set dev lo up

# whost LAN link
sudo ip netns exec whost ip addr add 10.1.3.21/24 dev whost2wbrg
sudo ip netns exec whost ip link set dev whost2wbrg up
sudo ip netns exec whost ip link set dev lo up

# wrouterA LAN link
sudo ip netns exec wrouter ip addr add 10.1.3.1/24 dev wrout2wbrg
sudo ip netns exec wrouter ip link set dev wrout2wbrg up
sudo ip netns exec wrouter ip link set dev lo up

# PURPLE WAN LINK (number 1)
   # PROUTER -> CROUTER
sudo ip netns exec prouter ip addr add 10.1.5.2/30 dev prout2crout
sudo ip netns exec prouter ip link set dev prout2crout up
sudo ip netns exec prouter ip link set dev lo up
   # CROUTER -> PROUTER WAN link
sudo ip netns exec crouter ip addr add 10.1.5.1/30 dev crout2prout
sudo ip netns exec crouter ip link set dev crout2prout up
sudo ip netns exec crouter ip link set dev lo up

# YELLOW WAN LINK (number 2)
  # YROUTER -> CROUTER WAN LINK
sudo ip netns exec yrouter ip addr add 10.1.5.6/30 dev yrout2crout
sudo ip netns exec yrouter ip link set dev yrout2crout up
sudo ip netns exec yrouter ip link set dev lo up
  # CROUTER -> YROUTER WAN LINK
sudo ip netns exec crouter ip addr add 10.1.5.5/30 dev crout2yrout
sudo ip netns exec crouter ip link set dev crout2yrout up
sudo ip netns exec crouter ip link set dev lo up

# WHITE WAN LINK (number 3)
  # WROUTER -> CROUTER 
sudo ip netns exec wrouter ip addr add 10.1.5.10/30 dev wrout2crout
sudo ip netns exec wrouter ip link set dev wrout2crout up
sudo ip netns exec wrouter ip link set dev lo up
  # CROUTER -> WROUTER
sudo ip netns exec crouter ip addr add 10.1.5.9/30 dev crout2wrout
sudo ip netns exec crouter ip link set dev crout2wrout up
sudo ip netns exec crouter ip link set dev lo up

# ORANGE WAN LINK (number 4)
  # OROUTER -> CROUTER
sudo ip netns exec orouter ip addr add 10.1.5.14/30 dev orout2crout
sudo ip netns exec orouter ip link set dev orout2crout up
sudo ip netns exec orouter ip link set dev lo up
  # CROUTER -> OROUTER
sudo ip netns exec crouter ip addr add 10.1.5.13/30 dev crout2orout
sudo ip netns exec crouter ip link set dev crout2orout up
sudo ip netns exec crouter ip link set dev lo up

# Work around to prrevent DHCP from assigning IPs to devices
sudo ip addr add 192.168.90.3/24 dev pbrg2prout 
sudo ip addr add 192.168.90.4/24 dev pbridge

# Configure NAT link
sudo ip netns exec crouter ip addr add 10.1.5.17/30 dev crout2nat
sudo ip netns exec crouter ip link set dev crout2nat up
sudo ip addr add 10.1.5.18/30 dev nat2crout

printf "${grn}Verify Veths${wht}\n"
sudo ip netns exec phost ip -c link | grep -A 2 phost
sudo ip netns exec yhost ip -c link | grep -A 2 yhost
sudo ip netns exec whost ip -c link | grep -A 2 whost
sudo ip netns exec ohost ip -c link | grep -A 2 ohost
sudo ip netns exec crouter ip -c link | grep -A 5 rout
sudo ip netns exec prouter ip -c link | grep -A 2 prout
sudo ip netns exec yrouter ip -c link | grep -A 2 yrout
sudo ip netns exec wrouter ip -c link | grep -A 2 wrout
sudo ip netns exec orouter ip -c link | grep -A 2 orout
ip -c l

#Static Routes
printf "${grn}Setting static routes${wht}\n"
# Configure routes on the core router
sudo ip netns exec crouter ip route add 10.1.1.0/24 via 10.1.5.2
sudo ip netns exec crouter ip route add 10.1.2.0/24 via 10.1.5.6
sudo ip netns exec crouter ip route add 10.1.3.0/24 via 10.1.5.10
sudo ip netns exec crouter ip route add 10.1.4.0/24 via 10.1.5.14
sudo ip netns exec crouter ip route add default via 10.1.5.18

#Configure default routes on the hosts
sudo ip netns exec phost ip route add default via 10.1.1.1
sudo ip netns exec yhost ip route add default via 10.1.2.1
sudo ip netns exec whost ip route add default via 10.1.3.1
sudo ip netns exec ohost ip route add default via 10.1.4.1

#Configure the default routes on the edge routers
sudo ip netns exec prouter ip route add default via 10.1.5.1
sudo ip netns exec yrouter ip route add default via 10.1.5.5
sudo ip netns exec wrouter ip route add default via 10.1.5.9
sudo ip netns exec orouter ip route add default via 10.1.5.13

#DHCP
#printf "${grn}setting dhcp${wht}\n"
#sudo apt install dnsmasq -y
#sudo ip netns exec prouter dnsmasq --interface=prout2pbrg --dhcp-range=10.1.1.50,10.1.1.149,255.255.255.0
#sudo ip netns add phost2-ns  
#sudo ip link add phost22pbrg type veth peer name pbrg2phost2
#sudo ip netns exec phost2-ns ip link set dev lo up
#sudo ip link set phost22pbrg netns phost2-ns  
#sudo ip link set dev pbrg2phost2 master pbridge  
#sudo ip netns exec phost2-ns  ip link set dev phost22pbrg up
#sudo ip netns exec phost2-ns dhclient phost22pbrg  
#printf "${grn}Here is your DHCP assigned IP address${wht}\n\n"
#sudo ip netns exec phost2-ns ip -c addr | grep 10.1

# NAT
printf "${grn}Enable the NAT function${wht}\n"

sudo iptables -t nat -F
sudo iptables -t nat    -A POSTROUTING -s 10.1.0.0/16 -o ens3 -j MASQUERADE
sudo iptables -t filter -A FORWARD -i ens3 -o nat2crout -j ACCEPT
sudo iptables -t filter -A FORWARD -o ens3 -i nat2crout -j ACCEPT
sudo ip route add 10.1.0.0/16 via 10.1.5.17

printf "${grn}Testing IP connectivity including NAT${wht}\n"
fping 10.0.0.1 10.1.1.1 10.1.1.21 10.1.2.1 10.1.2.21 10.1.3.1 10.1.3.21 10.1.4.1 10.1.4.21 8.8.8.8
