# SkyWalking Terraform and Ansible

This repository contains the Terraform scripts to create the infrastructure for SkyWalking on cloud vendors,
and the Ansible playbooks to install SkyWalking on the created infrastructure, or on the existing infrastructure,
no matter on-premises or on cloud vendors, such as AWS.

# Terraform

For now, we have supported the following cloud vendors, and we welcome everyone to contribute supports for
more cloud vendors:

- Amazon Web Services (AWS): go to the [aws](aws) folder for more details.

## Prerequisites

1. Terraform installed
2. AWS CLI set up with appropriate permissions
3. A working knowledge of Terraform and AWS resources

## Instructions

### 1. Initialization

Before applying any Terraform script, initialize your Terraform working directory:

```bash
$ cd aws/
$ terraform init
```

### 2. Configuration

The script is designed with modularity and reusability in mind. Various parameters like region, instance count, instance type, etc., are exposed as variables for easier customization.

#### Variables:

| Variable Name       | Description                                          | Default Value               |
|---------------------|------------------------------------------------------|-----------------------------|
| `oap_instance_count`| Number of SkyWalking OAP instances                   | `1`                         |
| `ui_instance_count` | Number of SkyWalking UI instances                    | `1`                         |
| `region`            | AWS region where resources will be provisioned       | `us-east-1`                 |
| `instance_type`     | AWS instance type for SkyWalking OAP and UI          | `t2.medium`                 |
| `public_key_path`   | Path where the SSH key for instances will be stored  | `~/.ssh`                    |
| `extra_tags`        | Additional tags that can be applied to all resources | `{}`                        |

To modify the default values, you can create a `terraform.tfvars` file in the same directory as your Terraform script:

```bash
oap_instance_count = 2
ui_instance_count  = 2
region             = "us-west-1"
instance_type      = "t2.large"
public_key_path    = "/path/to/your/desired/location"
extra_tags         = {
  "Environment" = "Production"
}
```

### 3. Test and apply the outcomes of the Script

After adjusting your configuration, test and apply the script:

```bash
$ terraform plan
$ terraform apply
```

### 4. Accessing the Resources

Once the resources are created:

- **SkyWalking OAP and UI instances**: You can SSH into the instances using the generated key pair. The public IPs of these instances are stored in local files (`oap-server` and `ui-server` respectively) under the `ansible/inventory/` directory, relative to the module's path.

```bash
ssh -i /path/to/skywalking.pem ec2-user@<INSTANCE_PUBLIC_IP>
```

- **Security Groups**: Two security groups are created:
  - `ssh-access`: Allows SSH access from any IP (`0.0.0.0/0`). **Please note** that this is potentially insecure and you should restrict the IP range wherever possible.
  - `public-egress-access`: Allows egress access to the internet for the instances.

### 5. Tearing Down

To destroy the resources when they are no longer needed:

```bash
terraform destroy
```

This command will prompt you to confirm before destroying the resources.

## Security Note

SSH access is open to the entire internet (`0.0.0.0/0`). This is not recommended for production environments. Always restrict the CIDR block to known IP ranges for better security.

# Ansible

You can use the Ansible playbook in combination with the Terraform to create necessary infrastructure and install
SkyWalking on the created infrastructure, or you can use the Ansible to install SkyWalking on the existing infrastructure.
The Ansible playbook and documentation about how to use it can be found in the [ansible](ansible) folder.
