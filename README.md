# Overview
This project aims to demonstrate a basic example of how Terraform and Ansible can be used together in the best ways to maximally leverage the respective tools' capabilities, orchestrated by Github Actions.

Terraform and Ansible can both be used independently to deploy and provision cloud resources, though they excel at different things. Terraform is an IaC tool and is more geared towards deploying infrastructure across different cloud providers. Ansible is a server configuration tool and is more geared towards staging servers with fine-grained control.

# How Terraform + Ansible can work
## Terraform calling Ansible
Terraform's provisioner can be used to execute ansible commands, such as executing a playbook to configure the servers after deployment.

- Pros
    - easy to setup
- Cons
    - Terraform cannot model the actions of provisioners as part of a plan because they can in principle take any action
    - Successful use of provisioners requires coordinating many more details than Terraform usage usually requires
    - Will not recognize underlying changes required (i.e. playbook changes if running ansible-playbook)

Terraform provisioners are considered a [last resort](https://developer.hashicorp.com/terraform/language/resources/provisioners/syntax) even by Hashicorp.    
## Ansible calling Terraform
Ansible can orchestrate Terraform to be executed as part of a larger workflow, using [Ansible's Terraform module](https://docs.ansible.com/ansible/latest/collections/community/general/terraform_module.html) to create tasks that execute Terraform commands.
- Pros
    - Great for abstracting away infrastructure deployment as a single step within a higher level plan
    - Ansible recognizes changes in Terraform plan on executing playbook
- Cons
    - Terraform functionality only as up-to-date as its Ansible Terraform module, may not have all Terraform features
## Terraform alongside Ansible
Terraform deploys infrastructure, then Ansible configures the deployed servers as a separate step.

- Pros
    - Separation of concerns empowers scalability
    - No need to worry about the capabilities about how one tool calls another, avoiding integration issues altogether
    - Terraform plan and Ansible playbook changes will be recognized every time
- Con
    - requires setup to parse Terraform state or output to be passed as input for Ansible

# Sources
- https://www.hashicorp.com/resources/ansible-terraform-better-together
- https://www.cprime.com/resources/blog/terraform-and-ansible-tutorial-integrating-terraform-managed-instances-with-ansible-control-nodes/