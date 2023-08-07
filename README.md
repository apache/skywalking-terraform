# SkyWalking Terraform and Ansible

This repository contains the Terraform scripts to create the infrastructure for SkyWalking on cloud vendors,
and the Ansible playbooks to install SkyWalking on the created infrastructure, or on the existing infrastructure,
no matter on-premises or on cloud vendors, such as AWS.

# Terraform

For now, we have supported the following cloud vendors, and we welcome everyone to contribute supports for
more cloud vendors:

- Amazon Web Services (AWS): go to the [aws](aws) folder for more details.

# Ansible

You can use the Ansible playbook in combination with the Terraform to create necessary infrastructure and install
SkyWalking on the created infrastructure, or you can use the Ansible to install SkyWalking on the existing infrastructure.
The Ansible playbook and documentation about how to use it can be found in the [ansible](ansible) folder.
