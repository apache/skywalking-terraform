# Terraform module for SkyWalking

For now, we have supported the following cloud vendors, and we welcome everyone to contribute supports for
more cloud vendors:

- [AWS](aws): Terraform scripts to provision necessary resources on Amazon Web Services.

> [!NOTE]
> HashiCorp had changed the LICENSE of Terraform from MPL 2.0 to BSL/BUSL 1.1
> since its 1.5.6 release. We don't have hard-dependencies on Terraform.
> 
> OpenTF Foundation announced to maintain the MPL 2.0 based fork of Terraform.
> Read their [announcement](https://opentf.org/announcement) and
> [website](https://opentf.org/) for more details.
> 
> All Terraform and/or OpenTF scripts are just for end-user convenience.
> The Apache 2.0 License is only for the scripts.


# Ansible playbook for SkyWalking

You can use the Ansible playbook in combination with the Terraform to create
necessary infrastructure and install SkyWalking on the created infrastructure,
or you can use the Ansible to install SkyWalking on the existing infrastructure.

Please go to the [ansible](ansible) folder for more details.
