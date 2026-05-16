

## Git Setup



## Lab Setup 

bash ~/px/scripts/full-setup.sh

docker ps


vim ~/test_inventory1.ini

[planetexpress]
bender      ansible_host=10.10.2.3 ansible_user=bender ansible_python_interpreter=/usr/bin/python3 fileuser=bender
fry         ansible_host=10.10.2.4 ansible_user=fry ansible_python_interpreter=/usr/bin/python3 fileuser=fry
zoidberg    ansible_host=10.10.2.5 ansible_user=zoidberg ansible_python_interpreter=/usr/bin/python3 fileuser=zoidberg
farnsworth  ansible_host=10.10.2.6 ansible_user=farnsworth ansible_ssh_pass=alta3 fileuser=farnsworth


ansible-inventory -i ~/test_inventory1.ini --host fry

vim ~/.ansible.cfg



vim ~/test_inventory2.yaml

all:
  children:
    planetexpress:
      hosts:
        fry:
          ansible_host: 10.10.2.4
          ansible_user: fry
          ansible_python_interpreter: /usr/bin/python3
          fileuser: fry
        farnsworth:
          ansible_host: 10.10.2.6
          ansible_user: farnsworth
          ansible_ssh_pass: alta3
          fileuser: farnsworth


ansible planetexpress -m ping -i ~/test_inventory2.yaml