## Podman Setup Guide

This document records how to install and validate Podman on:

- Fedora 44 (native Linux install)
- WSL (Windows Subsystem for Linux)

Date recorded: 2026-07-08

---

## 1) Fedora 44: Install Podman

### 1.1 Update the OS

```bash
sudo dnf -y upgrade --refresh
```

### 1.2 Install Podman and useful companion tools

```bash
sudo dnf -y install \
	podman \
	podman-docker \
	buildah \
	skopeo \
	crun \
	slirp4netns \
	fuse-overlayfs
```

What these do:

- `podman`: container runtime/CLI
- `podman-docker`: optional `docker` compatibility command
- `buildah`: container image builds
- `skopeo`: inspect/copy images between registries
- `crun`: lightweight OCI runtime (default on Fedora)
- `slirp4netns` + `fuse-overlayfs`: rootless networking/storage support

### 1.3 Confirm installation

```bash
podman --version
podman info
```

### Results


randall@HPLaptop:~$ podman --version 
podman version 5.8.4


### 1.4 (Recommended) Enable API socket for Docker-compatible tooling

```bash
systemctl --user enable --now podman.socket
```

Optional environment variable (for tools expecting a Docker socket):

```bash
echo 'export DOCKER_HOST=unix:///run/user/$UID/podman/podman.sock' >> ~/.bashrc
source ~/.bashrc
```

### 1.5 Validate with a test container

```bash
podman run --rm docker.io/library/hello-world
```

### 1.6 Optional: verify `docker` alias compatibility

```bash
docker --version
docker run --rm docker.io/library/hello-world
```

randall@HPLaptop:~$ docker --version 
Emulate Docker CLI using podman. Create /etc/containers/nodocker to quiet msg.
podman version 5.8.4

randall@HPLaptop:~$ podman run --rm docker.io/library/hello-world
WARN[0000] "/" is not a shared mount, this could cause issues or missing mounts with rootless containers 
Trying to pull docker.io/library/hello-world:latest...
Getting image source signatures
Copying blob 4f55086f7dd0 done   | 
Copying config e2ac70e731 done   | 
Writing manifest to image destination

Hello from Docker!
This message shows that your installation appears to be working correctly.

To generate this message, Docker took the following steps:
 1. The Docker client contacted the Docker daemon.
 2. The Docker daemon pulled the "hello-world" image from the Docker Hub.
    (amd64)
 3. The Docker daemon created a new container from that image which runs the
    executable that produces the output you are currently reading.
 4. The Docker daemon streamed that output to the Docker client, which sent it
    to your terminal.

To try something more ambitious, you can run an Ubuntu container with:
 $ docker run -it ubuntu bash

Share images, automate workflows, and more with a free Docker ID:
 https://hub.docker.com/

For more examples and ideas, visit:
 https://docs.docker.com/get-started/

randall@HPLaptop:~$ podman ps
CONTAINER ID  IMAGE       COMMAND     CREATED     STATUS      PORTS       NAMES
randall@HPLaptop:~$ podman image ls
REPOSITORY                     TAG         IMAGE ID      CREATED       SIZE
docker.io/library/hello-world  latest      e2ac70e7319a  3 months ago  26.6 kB



---

## 2) WSL Environment: Install Podman

These steps assume WSL2.

### 2.1 Check WSL version from Windows PowerShell

```powershell
wsl --status
wsl -l -v
```

If needed, set WSL2 as default:

```powershell
wsl --set-default-version 2
```

### 2.2 Enable systemd in your WSL distro (important for best Podman behavior)

- This is already done by default. 

Inside your WSL Linux shell, edit/create `/etc/wsl.conf`:

```ini
[boot]
systemd=true
```

Then from Windows PowerShell:

```powershell
wsl --shutdown
```

Re-open the distro and confirm:

```bash
ps -p 1 -o comm=
```

Expected output: `systemd`

---

### 2.3 WSL with Fedora distro: install Podman

If your WSL distro is Fedora:

```bash
sudo dnf -y upgrade --refresh
sudo dnf -y install \
	podman \
	podman-docker \
	buildah \
	skopeo \
	crun \
	slirp4netns \
	fuse-overlayfs
```

Verify:

```bash
podman --version
podman info
podman run --rm docker.io/library/hello-world
```

---

### 2.4 WSL with Ubuntu/Debian distro: install Podman

If your WSL distro is Ubuntu or Debian:

```bash
sudo apt update
sudo apt -y full-upgrade
sudo apt -y install podman uidmap slirp4netns fuse-overlayfs
```

Verify:

```bash
podman --version
podman info
podman run --rm docker.io/library/hello-world
```

---

## 3) Rootless and user namespace checks

Podman is rootless by default for regular users.

Check subordinate UID/GID mappings:

```bash
grep "^$USER:" /etc/subuid /etc/subgid
```

If nothing prints, add ranges (replace `myuser` with your username):

```bash
sudo usermod --add-subuids 100000-165535 --add-subgids 100000-165535 myuser
```

Log out and back in (or restart distro/session) after changing subuid/subgid.

---

## 4) Common WSL-specific fixes

### Problem: `podman info` fails with cgroup/systemd errors

- Ensure `systemd=true` is set in `/etc/wsl.conf`
- Run `wsl --shutdown` from Windows PowerShell
- Re-open distro and retry

### Problem: networking issues in rootless containers

- Confirm packages are installed: `slirp4netns` and `fuse-overlayfs`
- Retry with updated packages

```bash
sudo dnf -y upgrade --refresh    # Fedora
sudo apt update && sudo apt -y upgrade  # Ubuntu/Debian
```

### Problem: tool expects Docker socket

- Enable Podman user socket:

```bash
systemctl --user enable --now podman.socket
```

- Export `DOCKER_HOST`:

```bash
export DOCKER_HOST=unix:///run/user/$UID/podman/podman.sock
```

---

## 5) Quick validation checklist

Run all of these:

```bash
podman --version
podman info
podman images
podman ps -a
podman run --rm docker.io/library/alpine:latest echo "Podman works"
```

If all commands succeed, Podman is correctly installed.

---

## 6) Optional cleanup/test commands

```bash
podman image prune -f
podman system df
```

---

## 7) Notes from this environment

- Docker is not currently installed (`which docker` returned no result).
- Podman can provide Docker-compatible CLI behavior via `podman-docker`.
