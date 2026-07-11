FROM rockylinux:9

# build with:  sudo docker build --tag ssh-rocky .
# run with:    sudo docker run -d ssh-rocky

ARG user=farnsworth
ARG pass=alta3

# Update repositories and install required packages
RUN yum -y update                                                                                             && \
    yum install -y epel-release                                                                               && \
    yum install -y jq curl sudo vim openssh-server man less python3.9 git                                     && \
    mkdir -p /var/run/sshd                                                                                    && \
    echo "AllowAgentForwarding yes" >> /etc/ssh/sshd_config

# Create user, set password, make passwordless sudoer, add authorized key
RUN useradd --create-home --shell /bin/bash ${user}                                                           && \
    install --directory --owner=${user} --group=${user} /home/${user}/.ssh                                    && \
    echo "${user}:${pass}" | chpasswd                                                                         && \
    echo "export LC_ALL=C" >> /home/${user}/.bashrc                                                           && \
    echo "${user}       ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Remove nologin file
RUN rm -f /var/run/nologin

# Allow root SSH with password and set password
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config                   && \
    echo "root:${pass}" | chpasswd

# Generate SSH host keys
RUN ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -N ''                                                      && \
    ssh-keygen -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key -N ''                                                  && \
    ssh-keygen -t ed25519 -f /etc/ssh/ssh_host_ed25519_key -N ''

EXPOSE 22
CMD ["/usr/sbin/sshd","-D"]
