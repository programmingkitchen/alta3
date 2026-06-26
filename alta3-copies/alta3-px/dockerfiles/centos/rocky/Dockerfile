FROM rockylinux:8

# Build with: sudo docker build --tag ssh-rocky .
# Run with:   sudo docker run -d ssh-rocky

ARG user=farnsworth
ARG pass=alta3

# Update system and install required packages
RUN dnf -y update && \
    dnf install -y epel-release && \
    dnf install -y jq curl sudo vim openssh-server man less python39 git && \
    mkdir -p /var/run/sshd && \
    echo "AllowAgentForwarding yes" >> /etc/ssh/sshd_config

# Create user, set password, make passwordless sudoer, add authorized key
RUN useradd --create-home --shell /bin/bash ${user} && \
    install --directory --owner=${user} --group=${user} /home/${user}/.ssh && \
    echo "${user}:${pass}" | chpasswd && \
    echo "export LC_ALL=C" >> /home/${user}/.bashrc && \
    echo "${user} ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Allow root ssh with password and set password
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    echo "root:${pass}" | chpasswd

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
