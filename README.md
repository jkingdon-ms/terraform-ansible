# Overview
This project aims to demonstrate a basic example of how Terraform and Ansible can be used together in the best ways to maximally leverage the respective tools' capabilities.

Terraform and Ansible can both be used independently to deploy and provision cloud resources, though they excel at different things. Terraform is an IaC tool and is more geared towards deploying infrastructure across different cloud providers. Ansible is a server configuration tool and is more geared towards staging servers with fine-grained control. Importantly, idempotence is the default behavior of both tools.

# How to Run
Open your terminal and run

`bash manual-run.sh`

in the root of the project.

This script will run the terraform apply command, followed by the Ansible playbook command.

# How Terraform + Ansible can work
## Ansible within Terraform
- Pro: easy to setup
- Cons
    - Terraform cannot model the actions of provisioners as part of a plan because they can in principle take any action
    - Successful use of provisioners requires coordinating many more details than Terraform usage usually requires
    - Will not recognize underlying changes required (i.e. playbook changes if running ansible-playbook)

Terraform provisioners are considered a [last resort](https://developer.hashicorp.com/terraform/language/resources/provisioners/syntax) even by Hashicorp.    
## Terraform alongside Ansible
This is what I think is the most fitting use case for Terraform + Ansible as it best takes advantage of the respective strengths of each tool.
- Pros
    - Separation of concerns enables scalability
    - Easier to manage with tools originally intended usage patterns
    - Will recognize changes via Playbook
- Con: requires bit more setup, parsing of Terraform state or output to be passed as input for Ansible
## Terraform within Ansible
Ansible can orchestrate Terraform to be executed as part of a larger workflow, using [Ansible's Terraform module](https://docs.ansible.com/ansible/latest/collections/community/general/terraform_module.html) to create tasks that execute Terraform commands.

# Sources
- https://www.hashicorp.com/resources/ansible-terraform-better-together
- https://www.cprime.com/resources/blog/terraform-and-ansible-tutorial-integrating-terraform-managed-instances-with-ansible-control-nodes/