# HOW TO WORK WITH JINJA TEMPLATES

This chapter shows practical ways to use Jinja2 templates in Ansible.
The style is simple: each topic starts with what to do, then a short playbook or template snippet.

## Before you begin

Ansible uses Jinja2 as its templating engine.
Templates appear in two places:

- Inline inside playbooks — wrapped in `{{ }}` or `{% %}`.
- In `.j2` template files rendered with `ansible.builtin.template`.

Key ideas:

- `{{ expression }}` outputs a value.
- `{% statement %}` controls logic (loops, conditionals).
- `{# comment #}` adds a comment that does not appear in output.
- Template files are rendered on the control node and copied to the target.

## How to render a simple variable

Use `{{ variable }}` to insert a variable value into a string or file.

**Playbook**

```yaml
---
- name: How to render a simple variable
  hosts: all
  gather_facts: false
  vars:
    app_name: myapp
    app_port: 8080
  tasks:
    - name: Print app info
      ansible.builtin.debug:
        msg: "App {{ app_name }} listens on port {{ app_port }}"
```

**Output**

```
App myapp listens on port 8080
```

## How to render a template file

Put the template in a `.j2` file. Use `ansible.builtin.template` to render it and place it on the target host.

**Template — templates/app.conf.j2**

```
[app]
name = {{ app_name }}
port = {{ app_port }}
env  = {{ app_env }}
```

**Playbook**

```yaml
---
- name: How to render a template file
  hosts: all
  become: true
  gather_facts: false
  vars:
    app_name: myapp
    app_port: 8080
    app_env: production
  tasks:
    - name: Deploy app config
      ansible.builtin.template:
        src: templates/app.conf.j2
        dest: /etc/myapp/app.conf
        owner: root
        group: root
        mode: "0644"
```

## How to use a conditional in a template

Use `{% if %}` to include or exclude blocks based on a variable.

**Template — templates/nginx.conf.j2**

```
server {
    listen {{ http_port }};
    server_name {{ server_name }};

{% if enable_ssl %}
    listen {{ https_port }} ssl;
    ssl_certificate     {{ ssl_cert }};
    ssl_certificate_key {{ ssl_key }};
{% endif %}

    root {{ web_root }};
}
```

**Playbook**

```yaml
---
- name: How to use a conditional in a template
  hosts: all
  become: true
  gather_facts: false
  vars:
    http_port: 80
    https_port: 443
    server_name: example.com
    enable_ssl: true
    ssl_cert: /etc/ssl/certs/example.pem
    ssl_key: /etc/ssl/private/example.key
    web_root: /var/www/html
  tasks:
    - name: Render nginx config
      ansible.builtin.template:
        src: templates/nginx.conf.j2
        dest: /etc/nginx/sites-available/default
        mode: "0644"
```

## How to use an if-else block

Use `{% else %}` to provide a fallback value.

**Template — templates/env-banner.j2**

```
# Environment: {% if app_env == 'production' %}PRODUCTION — handle with care{% else %}{{ app_env | upper }}{% endif %}
```

**Playbook**

```yaml
---
- name: How to use an if-else block
  hosts: all
  gather_facts: false
  vars:
    app_env: staging
  tasks:
    - name: Render environment banner
      ansible.builtin.template:
        src: templates/env-banner.j2
        dest: /etc/myapp/banner.txt
        mode: "0644"
```

## How to loop over a list in a template

Use `{% for item in list %}` to repeat a block for every item.

**Template — templates/hosts-allow.j2**

```
# Allowed hosts
{% for host in allowed_hosts %}
{{ host }}
{% endfor %}
```

**Playbook**

```yaml
---
- name: How to loop over a list in a template
  hosts: all
  become: true
  gather_facts: false
  vars:
    allowed_hosts:
      - 10.0.0.10
      - 10.0.0.11
      - 10.0.0.12
  tasks:
    - name: Write hosts.allow
      ansible.builtin.template:
        src: templates/hosts-allow.j2
        dest: /etc/hosts.allow
        mode: "0644"
```

## How to loop over a list of dictionaries

Access dictionary keys with dot notation or bracket notation inside the loop.

**Template — templates/users.conf.j2**

```
# User accounts
{% for user in users %}
[{{ user.name }}]
  uid  = {{ user.uid }}
  home = {{ user.home }}
{% endfor %}
```

**Playbook**

```yaml
---
- name: How to loop over a list of dictionaries
  hosts: all
  become: true
  gather_facts: false
  vars:
    users:
      - name: alice
        uid: 1001
        home: /home/alice
      - name: bob
        uid: 1002
        home: /home/bob
  tasks:
    - name: Render user config
      ansible.builtin.template:
        src: templates/users.conf.j2
        dest: /etc/myapp/users.conf
        mode: "0644"
```

## How to use loop index and loop last

`loop.index` gives a 1-based counter. `loop.last` is true on the final iteration — useful for omitting trailing separators.

**Template — templates/server-list.j2**

```
servers:
{% for srv in servers %}
  - address: {{ srv }}
    id: {{ loop.index }}
{% if not loop.last %}
    # ---
{% endif %}
{% endfor %}
```

**Playbook**

```yaml
---
- name: How to use loop index and loop last
  hosts: all
  gather_facts: false
  vars:
    servers:
      - 192.168.1.10
      - 192.168.1.11
      - 192.168.1.12
  tasks:
    - name: Render server list
      ansible.builtin.template:
        src: templates/server-list.j2
        dest: /tmp/server-list.yaml
        mode: "0644"
```

## How to apply filters to variables

Filters transform values. Chain them with `|`.

**Playbook**

```yaml
---
- name: How to apply filters to variables
  hosts: all
  gather_facts: false
  vars:
    raw_name: "  my application  "
    version: ""
    tag_list:
      - web
      - api
      - db
  tasks:
    - name: Show common filter results
      ansible.builtin.debug:
        msg:
          - "Trimmed:    {{ raw_name | trim }}"
          - "Upper:      {{ raw_name | trim | upper }}"
          - "Default:    {{ version | default('1.0.0') }}"
          - "Joined:     {{ tag_list | join(', ') }}"
          - "Length:     {{ tag_list | length }}"
          - "First:      {{ tag_list | first }}"
          - "Last:       {{ tag_list | last }}"
          - "Sorted:     {{ tag_list | sort | join(', ') }}"
          - "Unique:     {{ tag_list | unique | join(', ') }}"
```

## How to use the default filter to handle missing variables

Use `default()` so templates do not fail when a variable is undefined.

**Template — templates/service.conf.j2**

```
[service]
port    = {{ service_port | default(8080) }}
workers = {{ workers | default(4) }}
debug   = {{ debug_mode | default(false) | lower }}
```

**Playbook**

```yaml
---
- name: How to use the default filter
  hosts: all
  become: true
  gather_facts: false
  vars:
    service_port: 9000
  tasks:
    - name: Render service config with defaults
      ansible.builtin.template:
        src: templates/service.conf.j2
        dest: /etc/myapp/service.conf
        mode: "0644"
```

## How to use the replace and regex_replace filters

Use `replace` for literal substitution, `regex_replace` for pattern-based substitution.

**Playbook**

```yaml
---
- name: How to use replace and regex_replace
  hosts: all
  gather_facts: false
  vars:
    path: /var/log/app.log
    version_string: "version-2.3.4-beta"
  tasks:
    - name: Show filter results
      ansible.builtin.debug:
        msg:
          - "Replace:       {{ path | replace('app', 'myapp') }}"
          - "Regex replace: {{ version_string | regex_replace('-beta$', '') }}"
```

## How to use the select and reject filters

`select` keeps items that match a test. `reject` removes them.

**Playbook**

```yaml
---
- name: How to use select and reject filters
  hosts: all
  gather_facts: false
  vars:
    ports:
      - 22
      - 80
      - 443
      - 8080
      - 8443
  tasks:
    - name: Show filtered port lists
      ansible.builtin.debug:
        msg:
          - "Standard ports: {{ ports | select('lt', 1024) | list }}"
          - "High ports:     {{ ports | reject('lt', 1024) | list }}"
```

## How to use the map filter on a list of dictionaries

`map(attribute=...)` extracts a single field from every dict in a list.

**Playbook**

```yaml
---
- name: How to use the map filter
  hosts: all
  gather_facts: false
  vars:
    users:
      - name: alice
        uid: 1001
      - name: bob
        uid: 1002
      - name: carol
        uid: 1003
  tasks:
    - name: Extract usernames
      ansible.builtin.debug:
        msg: "{{ users | map(attribute='name') | list }}"
```

## How to define a variable inside a template

Use `{% set %}` to create a local variable in a template.

**Template — templates/summary.j2**

```
{% set total = web_servers | length + db_servers | length %}
# Cluster summary
web_servers : {{ web_servers | length }}
db_servers  : {{ db_servers | length }}
total       : {{ total }}
```

**Playbook**

```yaml
---
- name: How to define a variable inside a template
  hosts: all
  gather_facts: false
  vars:
    web_servers:
      - web1
      - web2
    db_servers:
      - db1
  tasks:
    - name: Render summary
      ansible.builtin.template:
        src: templates/summary.j2
        dest: /tmp/cluster-summary.txt
        mode: "0644"
```

## How to include another template

Use `{% include %}` to compose large templates from smaller parts.

**Template — templates/main.conf.j2**

```
# Main configuration
{% include 'partials/logging.conf.j2' %}
{% include 'partials/network.conf.j2' %}
```

**Template — templates/partials/logging.conf.j2**

```
[logging]
level = {{ log_level | default('info') }}
path  = {{ log_path | default('/var/log/app.log') }}
```

**Playbook**

```yaml
---
- name: How to include another template
  hosts: all
  become: true
  gather_facts: false
  vars:
    log_level: warning
    log_path: /var/log/myapp.log
  tasks:
    - name: Render main config
      ansible.builtin.template:
        src: templates/main.conf.j2
        dest: /etc/myapp/main.conf
        mode: "0644"
```

## How to use template with host-specific variables

Ansible variables from inventory are available inside templates automatically.

**Inventory — inventory.ini**

```ini
[web]
web1 ansible_host=10.0.0.10 vhost=alpha.example.com
web2 ansible_host=10.0.0.11 vhost=beta.example.com
```

**Template — templates/vhost.conf.j2**

```
server {
    listen 80;
    server_name {{ vhost }};
    root /var/www/{{ vhost }};
}
```

**Playbook**

```yaml
---
- name: How to use host-specific variables in a template
  hosts: web
  become: true
  gather_facts: false
  tasks:
    - name: Deploy per-host vhost config
      ansible.builtin.template:
        src: templates/vhost.conf.j2
        dest: "/etc/nginx/sites-available/{{ vhost }}.conf"
        mode: "0644"
```

## How to use ansible_facts inside a template

Facts collected by `gather_facts: true` are available as `ansible_facts.*` or using legacy `ansible_*` names.

**Template — templates/motd.j2**

```
Welcome to {{ ansible_facts['hostname'] }}
OS      : {{ ansible_facts['distribution'] }} {{ ansible_facts['distribution_version'] }}
Kernel  : {{ ansible_facts['kernel'] }}
CPUs    : {{ ansible_facts['processor_vcpus'] }}
Memory  : {{ ansible_facts['memtotal_mb'] }} MB
```

**Playbook**

```yaml
---
- name: How to use ansible_facts inside a template
  hosts: all
  become: true
  gather_facts: true
  tasks:
    - name: Render MOTD
      ansible.builtin.template:
        src: templates/motd.j2
        dest: /etc/motd
        mode: "0644"
```

## How to validate a rendered template before placing it

Use `validate` to run a syntax check before the file is placed on the host.

**Playbook**

```yaml
---
- name: How to validate a rendered template
  hosts: all
  become: true
  gather_facts: false
  vars:
    http_port: 80
    server_name: example.com
    web_root: /var/www/html
    enable_ssl: false
  tasks:
    - name: Deploy and validate nginx config
      ansible.builtin.template:
        src: templates/nginx.conf.j2
        dest: /etc/nginx/sites-available/default
        mode: "0644"
        validate: "nginx -t -c %s"
```

## How to use Jinja2 to build a dynamic command string

Build shell commands or arguments as Jinja2 expressions before passing them to a task.

**Playbook**

```yaml
---
- name: How to build a dynamic command string with Jinja2
  hosts: all
  gather_facts: false
  vars:
    db_host: localhost
    db_port: 5432
    db_name: appdb
    db_user: admin
  tasks:
    - name: Run pg_dump with composed connection string
      ansible.builtin.shell: >
        pg_dump -h {{ db_host }} -p {{ db_port }}
        -U {{ db_user }} {{ db_name }}
        > /tmp/{{ db_name }}.sql
      changed_when: true
```

## How to render a template to a variable using lookup

Use `lookup('template', ...)` when you need the rendered output as an Ansible variable rather than a file.

**Template — templates/greeting.j2**

```
Hello, {{ user_name }}! You are running {{ ansible_facts['distribution'] }}.
```

**Playbook**

```yaml
---
- name: How to render a template to a variable
  hosts: all
  gather_facts: true
  vars:
    user_name: student
  tasks:
    - name: Render greeting into a variable
      ansible.builtin.set_fact:
        greeting_message: "{{ lookup('template', 'templates/greeting.j2') }}"

    - name: Show rendered greeting
      ansible.builtin.debug:
        var: greeting_message
```

## How to strip whitespace from template output

Use `{%- -%}` (with dashes) to remove whitespace and blank lines around block tags.

**Template without whitespace control — produces blank lines**

```
{% for item in items %}
{{ item }}
{% endfor %}
```

**Template with whitespace control — compact output**

```
{%- for item in items %}
{{ item }}
{%- endfor %}
```

**Playbook**

```yaml
---
- name: How to strip whitespace from template output
  hosts: all
  gather_facts: false
  vars:
    items:
      - alpha
      - beta
      - gamma
  tasks:
    - name: Render compact list
      ansible.builtin.template:
        src: templates/compact-list.j2
        dest: /tmp/compact-list.txt
        mode: "0644"
```

## How to comment out a block in a template

Use `{# #}` to add comments that do not appear in the rendered output.

**Template — templates/commented.j2**

```
[app]
name = {{ app_name }}
{# The line below is disabled until monitoring is set up #}
{# monitor_url = {{ monitor_url }} #}
port = {{ app_port }}
```

**Playbook**

```yaml
---
- name: How to add comments to a template
  hosts: all
  gather_facts: false
  vars:
    app_name: myapp
    app_port: 8080
  tasks:
    - name: Render config with comments
      ansible.builtin.template:
        src: templates/commented.j2
        dest: /etc/myapp/app.conf
        mode: "0644"
```
