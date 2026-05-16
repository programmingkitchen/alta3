# Overview 

## Git Configuration 

- Alta3 key created on my WSL.
- Configured that key (cut and paste) as the private key on the Alta3 box. 
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
