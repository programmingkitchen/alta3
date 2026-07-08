# Podman:  running a container network 

## Exploration 

randall@HPLaptop:/etc$ podman network ls
NETWORK ID    NAME        DRIVER
2f259bab93aa  podman      bridge


- If you create a container you get the default bridge. You need to install networking commands (iproute2, net-tools)
- SSH may not be open

2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 65520 qdisc fq_codel state UNKNOWN group default qlen 1000
    link/ether 12:e1:99:7a:3a:ac brd ff:ff:ff:ff:ff:ff
    inet 172.22.127.48/20 brd 172.22.127.255 scope global eth0
       valid_lft forever preferred_lft forever
    inet6 fe80::10e1:99ff:fe7a:3aac/64 scope link nodad proto kernel_ll 
       valid_lft forever preferred_lft forever
root@cf1a5398ef69:/usr/sbin# 


apt install -y net-tools


podman network create --subnet 10.10.2.0/24 ansible-net


podman network create \
  --subnet 10.10.2.0/24 \
  --gateway 10.10.2.1 \
  ansible-net

  podman run -d \
  --name ubuntu-lab \
  --network ansible-net \
  --ip 10.10.2.10 \
  docker.io/library/ubuntu:latest \
  sleep infinity

  sleep infinity keeps the container running without doing any work.

In a Podman or Docker run command, the container exits when its main process exits. If you start Ubuntu with bash as the main process, the container stays up only while that shell is active. If you want a long-lived container for later exec or SSH tests, sleep infinity gives it a process that never ends, so the container remains running.



docker run -d --name test-alta3 --network ansible-net -p 2222:22 test-alta3



## Ubuntu container

podman pull docker.io/library/ubuntu:latest

randall@HPLaptop:/etc$ docker image ls
Emulate Docker CLI using podman. Create /etc/containers/nodocker to quiet msg.
REPOSITORY                     TAG         IMAGE ID      CREATED       SIZE
docker.io/library/ubuntu       latest      4aaf0b273f92  11 days ago   112 MB
docker.io/library/hello-world  latest      e2ac70e7319a  3 months ago  26.6 kB



podman run -it --name ubuntu-lab docker.io/library/ubuntu:latest bash

randall@HPLaptop:/etc$ podman run -it --name ubuntu-lab docker.io/library/ubuntu:latest bash
root@cf1a5398ef69:/# id
uid=0(root) gid=0(root) groups=0(root)
root@cf1a5398ef69:/# pwd
/
root@cf1a5398ef69:/# ls


apt update && apt -y upgrade

apt -y install sl

## Logging into a container 

podman start ubuntu-lab
podman exec -it ubuntu-lab bash


## path

export PATH="$PATH:/usr/games"
sl

podman exec -it -u ubuntu ubuntu-lab bash


# Top Ubuntu Packages

apt install -y sl
apt install -y net-tools