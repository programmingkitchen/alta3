# Overview 

## Git Configuration 

- Alta3 key created on my WSL.
- Configured that key (cut and paste) as the private key on the Alta3 box. 
- Change top 600 for id_alta3
- Configured in Git Hub
- Changed the config file

```bash
student@bchd:~/.ssh$ cat config 
Host 10.*
        StrictHostKeyChecking no
        UserKnownHostsFile=/dev/null

Host github.com
  HostName github.com
  IdentitiesOnly yes
  IdentityFile ~/.ssh/id_alta3
  user git

Host gitlab.com
  HostName gitlab.com
  IdentitiesOnly yes
  IdentityFile ~/.ssh/id_rsa_gitlab
  user git
student@bchd:~/.ssh$ 
```

- Clone my repo

git clone git@github.com:programmingkitchen/alta3.git

- Configuration

 git config --global user.email "you@example.com"
  git config --global user.name "Your Name"

to set your account's default identity.
Omit --global to set the identity only in this repository.

git config --global user.email "rgranier@gmail.com"
git config --global user.name "Randall Alta3"