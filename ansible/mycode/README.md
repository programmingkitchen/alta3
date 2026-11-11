

## 21. Ansible Module - template 

```bash

ansible-playbook ~/mycode/template-playbook02.yml


ansible-playbook ~/mycode/template-playbook02.yml -e "planet='luna park'"

ansible-playbook ~/mycode/template-playbook03.yml


```


25. CHALLENGE 01 - Rerun the playbook. Make the mission-orders.txt render with orders from cineplex 14.

26. CHALLENGE 02 - Rerun the playbook. Make the mission-orders.txt render with orders from omicron persei 8.

33. CHALLENGE 03 (OPTIONAL - DIFFICULT) - Create a new template task. This single task should include a loop statement. Loop across the following list, [{"mission": "primary", "planet": "luna park"}, {"mission": "secondary", "planet": "cineplex 14"}]. The loop should produce two files, the first one should be titled primary-mission-orders.txt, and the second secondary-mission-orders.txt. Place both of these files on the remote hosts. Do all of this without modifying the template.

### Notes:  

- The template is mission-orders.txt.j2
- template-playbook-04.yml
  

  ### Trace of pattern

  