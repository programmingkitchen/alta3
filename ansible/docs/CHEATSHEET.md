# Common Cheat Sheet Commands

## Source Control 

```bash
cd ~/mycode
git status
git add /home/student/mycode/*
git commit -m "First playbook"
git push origin
cd ~/
```


## Setup

**Initialize lab environment:**
```bash
bash ~/px/scripts/full-setup.sh
```

**Check running containers:**
```bash
docker ps
```

## Ad-hoc Commands

**Test connectivity to a single host:**
```bash
ansible fry -m ping
```

**Test connectivity to a group of hosts:**
```bash
ansible planetexpress -m ping
```

## Inventory Management

**List the full inventory in JSON format:**
```bash
ansible-inventory -i ~/test_inventory1.ini --list
```

**Show inventory structure as a graph:**
```bash
ansible-inventory -i ~/test_inventory1.ini --graph
```

**Get details about a specific host:**
```bash
ansible-inventory -i ~/test_inventory1.ini --host fry
```

## Configuration

**Set default inventory in .ansible.cfg:**
```ini
[defaults]
inventory = /home/student/test_inventory1.ini
```

- The file ansible.cfg will be searched for in the following order. If a file is found, Ansible will ignore any remaining sources:

1. The environmental variable ```ANSIBLE_CONFIG``` (environment variable if set)
2. The file `ansible.cfg` (in the current directory)
3. `~/.ansible.cfg` (in the home directory)
4. `/etc/ansible/ansible.cfg` (last location checked)

### Key config parameters


