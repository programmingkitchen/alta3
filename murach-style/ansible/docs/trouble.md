# Trouble

## Wrong

- name: Example host group
  hosts: all
  become: true
  gather_facts: false
  tasks: []

  
## Right

- name: How to run commands in a specific directory
  hosts: localhost
  gather_facts: false
  tasks:


- This is a common error


randall@HPLaptop:~/github/alta3/murach-style/ansible/lab$ ansible-playbook 1.directory.yml
[WARNING]: provided hosts list is empty, only localhost is available. Note that the implicit localhost does not match 'all'

PLAY [Example host group] ******************************************************************************************************************
skipping: no hosts matched

PLAY [How to run a simple shell command] ***************************************************************************************************
skipping: no hosts matched

PLAY RECAP **********************************************

