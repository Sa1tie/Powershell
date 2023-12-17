# Create Ansible base directory
$ansibleDir = "C:\Users\roger.n.mcnulty\Desktop\Automation-Roger\Ansible\example-ansible-directory"
New-Item -ItemType Directory -Path $ansibleDir

# Create folder structure
New-Item -ItemType Directory -Path "$ansibleDir\roles" # Roles directory
New-Item -ItemType Directory -Path "$ansibleDir\playbooks" # Playbooks directory  
New-Item -ItemType Directory -Path "$ansibleDir\inventories" # Inventories directory

# Create example basic-template.yml playbook 
$playbook = @"
---
- name: Install and start Apache 
  hosts: webservers
  become: yes

  tasks:
  - name: Install Apache
    yum:
      name: httpd
      state: present

  - name: Start Apache service  
    service:
      name: httpd
      state: started
"@

Set-Content -Path "$ansibleDir\playbooks\basic-template.yml" -Value $playbook

# Create example inventory
$inventory = @'
[webservers]  
server1.example.com
server2.example.com

[dbservers]
db1.example.com 
db2.example.com
'@

Set-Content -Path "$ansibleDir\inventories\hosts" -Value $inventory

# Create example role directory structure
New-Item -ItemType Directory -Path "$ansibleDir\roles\common\tasks" # Tasks
New-Item -ItemType Directory -Path "$ansibleDir\roles\common\handlers" # Handlers
New-Item -ItemType Directory -Path "$ansibleDir\roles\common\files" # Files
New-Item -ItemType Directory -Path "$ansibleDir\roles\common\templates" # Templates
New-Item -ItemType Directory -Path "$ansibleDir\roles\common\vars" # Variables
New-Item -ItemType Directory -Path "$ansibleDir\roles\common\defaults" # Defaults
New-Item -ItemType Directory -Path "$ansibleDir\roles\common\meta" # Metadata

# Create README
$readme = @"
# Ansible Directory

This directory contains an Ansible setup with examples. 

## Contents

- playbooks - Example playbook to install and configure Apache
- roles - Example common role  
- inventories - Example inventory file
"@

Set-Content -Path "$ansibleDir\README.md" -Value $readme