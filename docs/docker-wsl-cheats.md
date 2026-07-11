# Docker Cheatsheet (with WSL Commands)

## Quick check

```bash
docker --version
docker info
docker ps
```

## Images

```bash
docker pull nginx:latest
docker images
docker rmi nginx:latest
```

## Containers

```bash
# Run interactive shell
docker run -it ubuntu:22.04 /bin/bash

# Run web server in background with port mapping
docker run -d --name web1 -p 8080:80 nginx:latest

# List running / all containers
docker ps
docker ps -a

# Stop, start, restart, remove
docker stop web1
docker start web1
docker restart web1
docker rm web1
docker rm -f web1
```

## Exec, logs, inspect

```bash
docker logs web1
docker logs -f web1
docker exec -it web1 /bin/bash
docker inspect web1
docker stats
```

## Build and push

```bash
docker build -t myapp:dev .
docker tag myapp:dev yourdockerhub/myapp:dev
docker login
docker push yourdockerhub/myapp:dev
```

## Volumes and networks

```bash
docker volume ls
docker volume create appdata

docker network ls
docker network create appnet

docker run -d --name api --network appnet myapp:dev
```

## Cleanup

```bash
docker system df
docker system prune
docker system prune -a
```

## WSL-specific commands

### Identify distro and version

```powershell
wsl -l -v
```

```bash
cat /etc/os-release
uname -r
```

### Install Docker engine in Fedora/RHEL-based WSL distro (dnf)

```bash
sudo dnf -y install docker
sudo usermod -aG docker $USER
newgrp docker
```

### Install Docker engine in Ubuntu/Debian WSL distro (apt)

```bash
sudo apt update
sudo apt install -y docker.io
sudo usermod -aG docker $USER
newgrp docker
```

### Start Docker daemon in WSL

If your distro supports systemd:

```bash
sudo systemctl enable --now docker
sudo systemctl status docker
```

If systemd is not enabled in WSL:

```bash
sudo service docker start
sudo service docker status
```

### Verify Docker socket and access

```bash
ls -l /var/run/docker.sock
id
docker ps
docker run --rm hello-world
```

### Docker Desktop + WSL integration checks (Windows side)

```powershell
wsl --status
wsl --update
```

### Common WSL troubleshooting

```bash
# If "Cannot connect to the Docker daemon"
sudo service docker start

# If permission denied on docker.sock
sudo usermod -aG docker $USER
newgrp docker

# Re-test
docker ps
```

## Daily workflow example

```bash
docker build -t demo:latest .
docker run -d --name demo1 -p 8000:80 demo:latest
docker ps
docker logs -f demo1
docker exec -it demo1 /bin/bash
docker stop demo1 && docker rm demo1
```
