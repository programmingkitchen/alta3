# Common Cheat Sheet Commands

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

 