# Prerequisites

- [Terraform installed](https://developer.hashicorp.com/terraform/downloads).
- AWS Credentials: Ensure your environment is set up with the necessary AWS credentials. This can be done in various ways, such as:
  - Setting the [`access_key`](configurations.md#input_access_key) and [`secret_key`](configurations.md#input_secret_key) variable in Terraform.
  - Setting up environment variables (`AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`).
  - Configuring using the [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html).
  - Using IAM roles with necessary permissions if you're running Terraform on an AWS EC2 instance.
  - For more information on configuring AWS credentials for Terraform, see the [official documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs#authentication-and-configuration).
- A working knowledge of Terraform and AWS resources

# Instructions

## Initialization

Before applying any Terraform script, initialize your Terraform working directory:

```bash
terraform init
```

## Configuration

The script is designed with modularity and reusability in mind. Various 
parameters like region, instance count, instance type, etc., are exposed
as variables for easier customization.

For the full configuration list, please refer to [the doc](configurations.md).

To modify the default values, you can create a `terraform.tfvars` file in the
same directory as your Terraform script:

```bash
cat <<EOF > terraform.tfvars
region     = "ap-southeast-1"
access_key = "<access_key>"
secret_key = "<secret_key>"
storage    = "rds-postgresql"
extra_tags         = {
  "Environment" = "Production"
}
EOF
```

## Test and apply the outcomes of the script

After adjusting your configuration, test and apply the script:

```bash
terraform plan
terraform apply
```

> [!WARNING]
> **Security Attention**: two security rules are created for the bastion host:
>  - `ssh-access`: Allows SSH access from any IP (`0.0.0.0/0`).
>    **Please note** that this is potentially insecure and you should restrict
>    the IP range by setting the variable
>    [`bastion_ssh_cidr_blocks`](configurations.md#input_bastion_ssh_cidr_blocks).
>  - `public-egress-access`: Allows egress access to the internet for the instances.

After all the resources are created, you can head to the
[Ansible part](../ansible/README.md) to start deploying SkyWalking.

## Accessing the resources

### SSH into bastion host (Optional)

You don't usually need to directly SSH into the bastion host, but if you want,
you can SSH into the bastion host with the command:

```shell
KEY_FILE=$(terraform output -raw ssh_user_key_file)
BASTION_IP=$(terraform output -json bastion_ips | jq -r '.[0]')

ssh -i "$KEY_FILE" ec2-user@"$BASTION_IP"
```

### Access the SkyWalking UI ALB

If you set the variable [`create_lb`](configurations.md#input_create_lb) to
`true` (this is set by default, so if you didn't set it to `false`, you should
have an ALB), you can access the SkyWalking UI ALB with the command:

```shell
terraform output -raw alb_dns_name
```

When you open the URL in your browser, you should see something like this:

```text
503 Service Temporarily Unavailable
```

This is because you didn't deploy SkyWalking yet, after you complete the steps
in the [Ansible part](../ansible/README.md), you should be able to see the
SkyWalking UI then.

## Tearing Down

To destroy the resources when they are no longer needed:

```bash
terraform destroy
```

This command will prompt you to confirm before destroying the resources.

