# HOW TO WORK WITH SHELL COMMANDS

This chapter shows practical ways to run shell commands with Ansible.
The style is simple: each topic starts with what to do, then a short playbook.

## Before you begin

Use these examples as a starting point.

```yaml
---
- name: Example host group
  hosts: all
  become: true
  gather_facts: false
  tasks: []
```

Key ideas:

- Use `ansible.builtin.command` when you do not need shell features.
- Use `ansible.builtin.shell` when you need pipes, redirects, globs, variable expansion, or compound commands.
- Prefer idempotent tasks. A command that always changes state can make playbooks noisy and risky.

## How to run a simple shell command

Use `shell` when you need shell behavior.

```yaml
---
- name: How to run a simple shell command
  hosts: all
  gather_facts: false
  tasks:
    - name: Show current user and working directory
      ansible.builtin.shell: "whoami && pwd"
      register: identity

    - name: Print command output
      ansible.builtin.debug:
        var: identity.stdout_lines
```

## How to run commands in a specific directory

Use `args.chdir` to avoid hardcoding `cd` into command text.

```yaml
---
- name: How to run commands in a specific directory
  hosts: all
  gather_facts: false
  tasks:
    - name: List files in /etc
      ansible.builtin.shell: "ls -1"
      args:
        chdir: /etc
      register: etc_files

    - name: Show first few files
      ansible.builtin.debug:
        msg: "{{ etc_files.stdout_lines[:5] }}"
```

## How to use pipes and redirects

Pipes and redirects require `shell`.

```yaml
---
- name: How to use pipes and redirects
  hosts: all
  become: true
  gather_facts: false
  tasks:
    - name: Save top memory consumers
      ansible.builtin.shell: |
        ps aux --sort=-%mem | head -n 6 > /tmp/top_mem.txt

    - name: Verify output file
      ansible.builtin.shell: "wc -l /tmp/top_mem.txt"
      register: top_mem_count

    - name: Show line count
      ansible.builtin.debug:
        var: top_mem_count.stdout
```

## How to pass environment variables to shell commands

Set `environment` per task to make commands predictable.

```yaml
---
- name: How to pass environment variables to shell commands
  hosts: all
  gather_facts: false
  tasks:
    - name: Use a custom app environment
      ansible.builtin.shell: "echo APP_MODE=$APP_MODE"
      environment:
        APP_MODE: production
      register: app_mode

    - name: Display APP_MODE
      ansible.builtin.debug:
        var: app_mode.stdout
```

## How to make a shell task idempotent with creates

Use `creates` so the command runs only once.

```yaml
---
- name: How to make a shell task idempotent with creates
  hosts: all
  become: true
  gather_facts: false
  tasks:
    - name: Create a marker file only if missing
      ansible.builtin.shell: "date > /opt/setup-complete.txt"
      args:
        creates: /opt/setup-complete.txt
```

## How to make a shell task idempotent with removes

Use `removes` to run a cleanup command only when a file exists.

```yaml
---
- name: How to make a shell task idempotent with removes
  hosts: all
  become: true
  gather_facts: false
  tasks:
    - name: Remove stale lock if present
      ansible.builtin.shell: "rm -f /tmp/myapp.lock"
      args:
        removes: /tmp/myapp.lock
```

## How to control success and change conditions

Use `failed_when` and `changed_when` to express intent.

```yaml
---
- name: How to control success and change conditions
  hosts: all
  gather_facts: false
  tasks:
    - name: Check if nginx process is running
      ansible.builtin.shell: "pgrep -x nginx"
      register: nginx_check
      failed_when: false
      changed_when: false

    - name: Report status
      ansible.builtin.debug:
        msg: >-
          nginx is {{ 'running' if nginx_check.rc == 0 else 'not running' }}
```

## How to use command output in later tasks

Register output, then feed it into another task.

```yaml
---
- name: How to use command output in later tasks
  hosts: all
  gather_facts: false
  tasks:
    - name: Get kernel version
      ansible.builtin.shell: "uname -r"
      register: kernel
      changed_when: false

    - name: Write kernel version to a file
      ansible.builtin.copy:
        dest: /tmp/kernel-version.txt
        content: "Kernel: {{ kernel.stdout }}\n"
```

## How to find a user in /etc/passwd from registered output

This version reads `/etc/passwd` once, registers it, and then searches in memory.

```yaml
---
- name: How to find a user in /etc/passwd from registered output
  hosts: all
  gather_facts: false
  vars:
    lookup_user: "root"
  tasks:
    - name: Read passwd file
      ansible.builtin.command: cat /etc/passwd
      register: passwd_file
      changed_when: false

    - name: Find matching passwd line for the user
      ansible.builtin.set_fact:
        matched_passwd_line: >-
          {{
            passwd_file.stdout_lines
            | select('match', '^' ~ (lookup_user | regex_escape) ~ ':')
            | list
            | first
            | default('')
          }}

    - name: Show match result
      ansible.builtin.debug:
        msg: >-
          {{
            'User ' ~ lookup_user ~ ' found: ' ~ matched_passwd_line
            if matched_passwd_line | length > 0
            else 'User ' ~ lookup_user ~ ' not found in /etc/passwd'
          }}
```

## How to extract UID and home directory from a matched passwd line

Use the registered line and split it into fields to drive later logic.

```yaml
---
- name: How to extract UID and home directory from a matched passwd line
  hosts: all
  gather_facts: false
  vars:
    lookup_user: "root"
  tasks:
    - name: Read passwd file
      ansible.builtin.command: cat /etc/passwd
      register: passwd_file
      changed_when: false

    - name: Capture matching line
      ansible.builtin.set_fact:
        matched_passwd_line: >-
          {{
            passwd_file.stdout_lines
            | select('match', '^' ~ (lookup_user | regex_escape) ~ ':')
            | list
            | first
            | default('')
          }}

    - name: Fail if user is missing
      ansible.builtin.fail:
        msg: "User {{ lookup_user }} not found in /etc/passwd"
      when: matched_passwd_line == ''

    - name: Parse passwd fields
      ansible.builtin.set_fact:
        passwd_fields: "{{ matched_passwd_line.split(':') }}"

    - name: Show parsed values
      ansible.builtin.debug:
        msg:
          - "user={{ passwd_fields[0] }}"
          - "uid={{ passwd_fields[2] }}"
          - "home={{ passwd_fields[5] }}"
          - "shell={{ passwd_fields[6] }}"
```

## How to branch tasks based on registered shell output

Use `when` to run different tasks depending on command output.

```yaml
---
- name: How to branch tasks based on registered shell output
  hosts: all
  gather_facts: false
  tasks:
    - name: Check if /etc/sudoers exists
      ansible.builtin.shell: "test -f /etc/sudoers && echo present || echo missing"
      register: sudoers_state
      changed_when: false

    - name: Run task if sudoers file is present
      ansible.builtin.debug:
        msg: "sudoers is present, run validation workflow"
      when: sudoers_state.stdout == 'present'

    - name: Run task if sudoers file is missing
      ansible.builtin.debug:
        msg: "sudoers is missing, run remediation workflow"
      when: sudoers_state.stdout == 'missing'
```

## How to convert registered output into a clean list

Normalize shell output before looping over it.

```yaml
---
- name: How to convert registered output into a clean list
  hosts: all
  gather_facts: false
  tasks:
    - name: Get all login-capable users from passwd
      ansible.builtin.shell: "awk -F: '$7 !~ /(nologin|false)$/ {print $1}' /etc/passwd"
      register: login_users_raw
      changed_when: false

    - name: Build cleaned list
      ansible.builtin.set_fact:
        login_users: >-
          {{
            login_users_raw.stdout_lines
            | map('trim')
            | reject('equalto', '')
            | list
          }}

    - name: Show each user
      ansible.builtin.debug:
        msg: "login user: {{ item }}"
      loop: "{{ login_users }}"
```

## How to run a shell command for multiple items

Loop over values and collect each result.

```yaml
---
- name: How to run a shell command for multiple items
  hosts: all
  gather_facts: false
  vars:
    paths_to_check:
      - /etc/passwd
      - /etc/hosts
      - /tmp/not-here
  tasks:
    - name: Test whether each file exists
      ansible.builtin.shell: "test -e {{ item }}"
      loop: "{{ paths_to_check }}"
      register: path_tests
      failed_when: false
      changed_when: false

    - name: Show results
      ansible.builtin.debug:
        msg: "{{ item.item }} exists={{ item.rc == 0 }}"
      loop: "{{ path_tests.results }}"
```

## How to run long shell commands asynchronously

Use `async` and `poll` for long-running jobs.

```yaml
---
- name: How to run long shell commands asynchronously
  hosts: all
  gather_facts: false
  tasks:
    - name: Start long job without waiting
      ansible.builtin.shell: "sleep 30 && echo done > /tmp/long-job.txt"
      async: 120
      poll: 0
      register: async_job

    - name: Poll for completion
      ansible.builtin.async_status:
        jid: "{{ async_job.ansible_job_id }}"
      register: job_status
      until: job_status.finished
      retries: 20
      delay: 3
```

## How to choose between command and shell

Use this quick rule:

- Choose `command` for safety and predictable behavior.
- Choose `shell` only when you need shell syntax.

Short comparison:

```yaml
---
- name: How to choose between command and shell
  hosts: all
  gather_facts: false
  tasks:
    - name: Good fit for command (no shell features)
      ansible.builtin.command: cat /etc/os-release
      register: os_release
      changed_when: false

    - name: Good fit for shell (uses pipe)
      ansible.builtin.shell: "cat /etc/os-release | grep PRETTY_NAME"
      register: pretty_name
      changed_when: false

    - name: Show outputs
      ansible.builtin.debug:
        msg:
          - "command: {{ os_release.stdout_lines[0] }}"
          - "shell: {{ pretty_name.stdout }}"
```

## How to avoid common mistakes

- Do not use `shell` when `command` is enough.
- Add `changed_when: false` for read-only checks.
- Use `creates` and `removes` for idempotency.
- Quote variables in shell commands when values may contain spaces.
- Prefer dedicated modules (`copy`, `file`, `package`, `service`) instead of shell when possible.

## Summary

When you work with shell commands in Ansible, think in this order:

1. Can a built-in module solve this?
2. If not, can `command` solve this?
3. If shell syntax is required, use `shell` with guardrails (`creates`, `removes`, `changed_when`, `failed_when`).

These patterns let you keep playbooks short, reliable, and easy to maintain.

