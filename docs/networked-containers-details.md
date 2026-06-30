# 


## Install software

- Install Docker in WSL 

`sudo dnf -y install docker`

- Find the WSL user and group

rhuser@DellXPS:~/github/alta3$ echo $USER
rhuser

rhuser@DellXPS:~/github/alta3$ id -a
uid=1000(rhuser) gid=1000(rhuser) groups=1000(rhuser),10(wheel)

rhuser@DellXPS:~/github/alta3$ echo $USER
rhuser



sudo usermod -aG docker $USER


rhuser@DellXPS:~/github/alta3$ grep docker /etc/group
docker:x:995:rhuser


- Before 

rhuser@DellXPS:~/github/alta3$ systemctl status docker
○ docker.service - Docker Application Container Engine
     Loaded: loaded (/usr/lib/systemd/system/docker.service; disabled; preset: disabled)
    Drop-In: /usr/lib/systemd/system/service.d
             └─10-timeout-abort.conf, 50-keep-warm.conf
     Active: inactive (dead)
TriggeredBy: ○ docker.socket
       Docs: https://docs.docker.com


- After

rhuser@DellXPS:~/github/alta3$ sudo systemctl enable --now docker
Created symlink '/etc/systemd/system/multi-user.target.wants/docker.service' → '/usr/lib/systemd/system/docker.service'.
rhuser@DellXPS:~/github/alta3$ systemctl status docker
● docker.service - Docker Application Container Engine
     Loaded: loaded (/usr/lib/systemd/system/docker.service; enabled; preset: disabled)
    Drop-In: /usr/lib/systemd/system/service.d
             └─10-timeout-abort.conf, 50-keep-warm.conf
     Active: active (running) since Mon 2026-06-29 21:12:53 EDT; 9s ago
 Invocation: 458dbf99cbce4be58b33c82ce49ac39a
TriggeredBy: ● docker.socket
       Docs: https://docs.docker.com
   Main PID: 21303 (dockerd)
      Tasks: 15
     Memory: 128.7M (peak: 132.5M)
        CPU: 252ms
     CGroup: /system.slice/docker.service
             └─21303 /usr/bin/dockerd -H fd:// --containerd=/run/containerd/containerd.sock --selinux-enabled --userland-proxy-path /usr/bin/docker-proxy --init-path /usr/bin/tini-static


- We need to log out and back in to get the permissions 


huser@DellXPS:~/github/alta3$ sudo docker run --rm hello-world
Unable to find image 'hello-world:latest' locally
latest: Pulling from library/hello-world
4f55086f7dd0: Pull complete 
d5e71e642bf5: Download complete 
Digest: sha256:96498ffd522e70807ab6384a5c0485a79b9c7c08ca79ba08623edcad1054e62d
Status: Downloaded newer image for hello-world:latest

rhuser@DellXPS:~/github/alta3$ sudo docker image ls
                                                                                                                                                                                       i Info →   U  In Use
IMAGE                ID             DISK USAGE   CONTENT SIZE   EXTRA
hello-world:latest   96498ffd522e       25.9kB         9.49kB        
rhuser@DellXPS:~/github/alta3$ 


- This command causes a mess because it disconnects the WSL session and it's hard to start it, but fortunatly, VSC preserves the file.  

- From Windows PowerShell, restart WSL:

wsl --shutdown

- After shutdown the user is in the docker group

rhuser@DellXPS:~/github/alta3$ id -a
uid=1000(rhuser) gid=1000(rhuser) groups=1000(rhuser),10(wheel),995(docker)


```bash
rhuser@DellXPS:~/github/alta3$ docker ps
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES


rhuser@DellXPS:~/github/alta3$ docker image ls
IMAGE                ID             DISK USAGE   CONTENT SIZE   EXTRA
hello-world:latest   96498ffd522e       25.9kB         9.49kB        
```

## Build an Alta3 container using the file 

```bash
rhuser@DellXPS:~/github/alta3/wsl-lab$ docker build -t test-alta3 .
```

### Following Build


rhuser@DellXPS:~/github/alta3/wsl-lab$ docker ps
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
rhuser@DellXPS:~/github/alta3/wsl-lab$ docker image ls

IMAGE                ID             DISK USAGE   CONTENT SIZE   EXTRA
hello-world:latest   96498ffd522e       25.9kB         9.49kB        
test-alta3:latest    a89d6d12c53c        525MB          139MB        
rhuser@DellXPS:~/github/alta3/wsl-lab$ 

### Run it

docker run -d --name test-alta3 test-alta3

means:
- run a container in detached mode
- name the container test-alta3
- use the image named test-alta3


huser@DellXPS:~/github/alta3/wsl-lab$ docker run -d --name test-alta3 test-alta3
43036d39f9b5bef5344903ba586129c244c11a4fe45e7f547a6601a2461f8bbe

rhuser@DellXPS:~/github/alta3/wsl-lab$ docker ps
CONTAINER ID   IMAGE        COMMAND               CREATED          STATUS          PORTS     NAMES
43036d39f9b5   test-alta3   "/usr/sbin/sshd -D"   21 seconds ago   Up 21 seconds   22/tcp    test-alta3
rhuser@DellXPS:~/github/alta3/wsl-lab$ 

###  Stop and delete the container 

rhuser@DellXPS:~/github/alta3/wsl-lab$ docker stop test-alta3
test-alta3
rhuser@DellXPS:~/github/alta3/wsl-lab$ docker ps
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
rhuser@DellXPS:~/github/alta3/wsl-lab$ docker rm test-alta3
test-alta3

rhuser@DellXPS:~/github/alta3/wsl-lab$ docker ps -a
CONTAINER ID   IMAGE        COMMAND               CREATED              STATUS              PORTS                                     NAMES
de55abe9f19a   test-alta3   "/usr/sbin/sshd -D"   About a minute ago   Up About a minute   0.0.0.0:2222->22/tcp, [::]:2222->22/tcp   test-alta3
rhuser@DellXPS:~/github/alta3/wsl-lab$ 



### Try it with port forwarding 

rhuser@DellXPS:~/github/alta3/wsl-lab$ docker run -d --name test-alta3 -p 2222:22 test-alta3
de55abe9f19a409332f47800163e025a3b92c42c62094a18678ac0011dbd5fb3
rhuser@DellXPS:~/github/alta3/wsl-lab$ docker ps
CONTAINER ID   IMAGE        COMMAND               CREATED          STATUS          PORTS                                     NAMES
de55abe9f19a   test-alta3   "/usr/sbin/sshd -D"   35 seconds ago   Up 34 seconds   0.0.0.0:2222->22/tcp, [::]:2222->22/tcp   test-alta3
rhuser@DellXPS:~/github/alta3/wsl-lab$ 


### It worked 

rhuser@DellXPS:~/github/alta3/wsl-lab$ ssh student@localhost -p 2222
The authenticity of host '[localhost]:2222 ([127.0.0.1]:2222)' can't be established.
ED25519 key fingerprint is SHA256:BqbIxaVWjPDshvocvnoMhQsB/eoIiCi/gURz612LYUY.
This key is not known by any other names.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '[localhost]:2222' (ED25519) to the list of known hosts.
student@localhost's password: 
Welcome to Ubuntu 22.04.1 LTS (GNU/Linux 6.18.33.2-microsoft-standard-WSL2 x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

This system has been minimized by removing packages and content that are
not required on a system that users do not log into.

To restore this content, you can run the 'unminimize' command.

The programs included with the Ubuntu system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Ubuntu comes with ABSOLUTELY NO WARRANTY, to the extent permitted by
applicable law.

student@de55abe9f19a:~$ 

### Clean up

rhuser@DellXPS:~/github/alta3/wsl-lab$ docker container rm test-alta3
test-alta3

rhuser@DellXPS:~/github/alta3/wsl-lab$ docker ps -a
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
rhuser@DellXPS:~/github/alta3/wsl-lab$ 



rhuser@DellXPS:~/github/alta3/wsl-lab$ docker image ls
                                                                                                                                                                                                                                      i Info →   U  In Use
IMAGE                ID             DISK USAGE   CONTENT SIZE   EXTRA
hello-world:latest   96498ffd522e       25.9kB         9.49kB        
test-alta3:latest    a89d6d12c53c        525MB          139MB        
rhuser@DellXPS:~/github/alta3/wsl-lab$ docker image prune -a
WARNING! This will remove all images without at least one container associated to them.
Are you sure you want to continue? [y/N] y
Deleted Images:
untagged: hello-world:latest
deleted: sha256:96498ffd522e70807ab6384a5c0485a79b9c7c08ca79ba08623edcad1054e62d
deleted: sha256:d1a8d0a4eeb63aff09f5f34d4d80505e0ba81905f36158cc3970d8e07179e59e
deleted: sha256:8e752a1cddeafc02597e756f4a0ec96e29f63ac4bc4af87682daf3f1de843bb7
untagged: test-alta3:latest
deleted: sha256:a89d6d12c53ccf469871477af73c40a56a975e42039baeea449dbaaff7c6e7d8
deleted: sha256:84760930394ccfdaf58dcf8ba9ddbfd941a8e01c7a627b03d4b48165b428ff60
deleted: sha256:6008b04693f1d935873be323cf4f20626d019ced03cdadc33ba38da2cbc8e866

Total reclaimed space: 28.71kB
rhuser@DellXPS:~/github/alta3/wsl-lab$ docker image ls
                                                                                                                                                                                                                                      i Info →   U  In Use
IMAGE   ID             DISK USAGE   CONTENT SIZE   EXTRA
rhuser@DellXPS:~/github/alta3/wsl-lab$ 


## Networks

sudo docker network create --opt com.docker.network.driver.mtu=1450 --subnet 10.10.2.0/24 ansible-net

rhuser@DellXPS:~/github/alta3/wsl-lab$ sudo docker network create --opt com.docker.network.driver.mtu=1450 --subnet 10.10.2.0/24 ansible-net
c0a028e4f2d398b104e80733676dabc3afa892f7c904c996d2b72fafdcb342a2
rhuser@DellXPS:~/github/alta3/wsl-lab$ docker network ls
NETWORK ID     NAME          DRIVER    SCOPE
c0a028e4f2d3   ansible-net   bridge    local
05ddea6edbff   bridge        bridge    local
9c1ef71c8f2d   host          host      local
0c49fd7ae773   none          null      local
rhuser@DellXPS:~/github/alta3/wsl-lab$ 


At startup, Docker typically has these default networks:

bridge
host
none
Anything else, like ansible-net, is a custom network created later. If you want, I can also show how to tell which ones are default vs user-created from docker network ls.


```bash
rhuser@DellXPS:~/github/alta3/wsl-lab$ docker network inspect ansible-net
[
    {
        "Name": "ansible-net",
        "Id": "c0a028e4f2d398b104e80733676dabc3afa892f7c904c996d2b72fafdcb342a2",
        "Created": "2026-06-29T21:48:12.214112409-04:00",
        "Scope": "local",
        "Driver": "bridge",
        "EnableIPv4": true,
        "EnableIPv6": false,
        "IPAM": {
            "Driver": "default",
            "Options": {},
            "Config": [
                {
                    "Subnet": "10.10.2.0/24",
                    "Gateway": "10.10.2.1"
                }
            ]
        },
        "Internal": false,
        "Attachable": false,
        "Ingress": false,
        "ConfigFrom": {
            "Network": ""
        },
        "ConfigOnly": false,
        "Options": {
            "com.docker.network.driver.mtu": "1450"
        },
        "Labels": {},
        "Containers": {},
        "Status": {
            "IPAM": {
                "Subnets": {
                    "10.10.2.0/24": {
                        "IPsInUse": 3,
                        "DynamicIPsAvailable": 253
                    }
                }
            }
        }
    }
]
rhuser@DellXPS:~/github/alta3/wsl-lab$ 
```

