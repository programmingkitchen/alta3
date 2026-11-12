# ALTA 3 TRAINING AND CODE

# test from vm

## Revision history

| Date | Details |
| ---- | --- |
| 2026-06-29 | Develop docs for setting up Docker network lab.|
| 2026-05-17 | Repository rebuild. |
| 2026-05-16 | From Alta3 set up new branch. |

## Setting up a new Alta 3 class

### Setup Git/Git Hub

#### Using a SSH key

git@github.com:programmingkitchen/alta3.git

We have an Alta 3 key configured that can be used on new Alta3 VMs

andall@HPLaptop:~/.ssh$ ls -l
total 56
-rw------- 1 randall randall  557 Jun 24  2025 config
-rw------- 1 randall randall  411 May 16 09:59 id_alta3
-rw------- 1 randall randall   96 May 16 09:59 id_alta3.pub

Install the Alta3 private key on the vm

student@bchd:~/.ssh$ ls -la
total 28
drwx------  2 student student 4096 Nov 12 19:51 .
drwxr-x--- 12 student student 4096 Nov 12 19:51 ..
-rw-------  1 student student  961 Nov 12 19:27 authorized_keys
-rw-r--r--  1 student root     280 Oct 16 19:46 config
-rw-r--r--  1 student student  411 Nov 12 19:51 id_alta3
-r--------  1 student root    2602 Oct 16 19:46 id_rsa
-r--------  1 student root     567 Oct 16 19:46 id_rsa.pub
student@bchd:~/.ssh$ chmod 600 id_alta3 
student@bchd:~/.ssh$ 

Change the config file to use my key

student@bchd:~/.ssh$ cat config
Host 10.*
        StrictHostKeyChecking no
        UserKnownHostsFile=/dev/null

Host github.com
  HostName github.com
  IdentitiesOnly yes
  IdentityFile ~/.ssh/id_alta3
  user git

Clone the repo


git clone git@github.com:programmingkitchen/alta3.git



student@bchd:~/git$ pwd
/home/student/git
student@bchd:~/git$ ls
alta3  kubernetes-the-alta3-way  microservices-demo
student@bchd:~/git$ 


Do the branches


tudent@bchd:~/git/alta3$ ls
README.md  alta3-copies  cka   foobar.txt    scripts
alta3      ansible       docs  murach-style  wsl-lab
student@bchd:~/git/alta3$ git branch
* main
student@bchd:~/git/alta3$ git branch -r
  origin/HEAD -> origin/main
  origin/feat/cka-start
  origin/main
student@bchd:~/git/alta3$ git switch feat/cka-start 
branch 'feat/cka-start' set up to track 'origin/feat/cka-start'.
Switched to a new branch 'feat/cka-start'
student@bchd:~/git/alta3$ pwd
/home/student/git/alta3
student@bchd:~/git/alta3$ 

