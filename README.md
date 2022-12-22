# Overview
They can both be used independently to deploy and provision cloud resources, though they excel at different things.

Terraform is an IaC tool and is more geared towards deploying infrastructure across different cloud providers.

Ansible is a server configuration tool and is more geared towards staging servers with fine-grained control.

Idempotence is the default behavior of both tools.

# How Terraform + Ansible can work
## Ansible within Terraform
- Ansible can run within Terraform VM provisioner
    - Pro: easy to setup
    - Con: will not recognize to re-provision VM on playbook changes
- Terraform's output state as Ansible's input inventory
    - Pros
        - separation of concerns, easier to manage (IaC vs Config Management)
        - will recognize changes of playbook and/or underlying files (such as copied files like 'index.html' for example)
    - Con: requires more setup, parsing of Terraform state output for the host IPs, to be passed as input for Ansible inventory
## Terraform within Ansible
Ansible can orchestrate Terraform to be executed as part of a larger workflow, using [Ansible's Terraform module](https://docs.ansible.com/ansible/latest/collections/community/general/terraform_module.html) to create tasks that execute Terraform commands.

# Sources
- https://www.hashicorp.com/resources/ansible-terraform-better-together
- https://www.cprime.com/resources/blog/terraform-and-ansible-tutorial-integrating-terraform-managed-instances-with-ansible-control-nodes/