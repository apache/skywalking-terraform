# SkyWalking Terraform and Ansible

This repository contains the Terraform scripts to create the infrastructure for SkyWalking on cloud vendors,
and the Ansible playbooks to install SkyWalking on the created infrastructure, or on the existing infrastructure,
no matter on-premises or on cloud vendors, such as AWS.

# Terraform

**Notice, HashiCorp had changed the LICENSE of Terraform from MPL 2.0 to BSL/BUSL 1.1 since its 1.5.6 release. We don't have hard-dependencies on Terraform.**

**OpenTF Foundation announced to maintain the MPL 2.0 based fork of Terraform. Read their [announcement](https://opentf.org/announcement) and [website](https://opentf.org/) for more details.**

**All Terraform and/or OpenTF scripts are just for end-user convenience. The Apache 2.0 License is only for the scripts.**

For now, we have supported the following cloud vendors, and we welcome everyone to contribute supports for
more cloud vendors:

- Amazon Web Services (AWS): go to the [aws](aws) folder for more details.

## Prerequisites

1. Terraform installed
2. AWS Credentials: Ensure your environment is set up with the necessary AWS credentials. This can be done in various ways, such as:
  - Configuring using the AWS CLI.
  - Setting up environment variables (`AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`).
  - Using IAM roles with necessary permissions if you're running Terraform on an AWS EC2 instance.
  - For more information on configuring AWS credentials for Terraform, see the [official documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs#authentication-and-configuration).
3. A working knowledge of Terraform and AWS resources

## Instructions

### 1. Initialization

Before applying any Terraform script, initialize your Terraform working directory:

```bash
cd aws/
terraform init
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
terraform plan
terraform apply
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

This guide provides steps on using Ansible to install Apache SkyWalking on AWS instances.

## Prerequisites

1. Ansible installed.
2. A working knowledge of Ansible and AWS resources.
3. An active SSH key and access to AWS EC2 instances.

## Instructions

### 1. Change diroectory and set the SSH Key File Path

Save the SSH key file path generated by Terraform to a variable for future use:

```
cd ../ansible/
SSH_KEY_FILE=$(terraform -chdir=../aws output -raw ssh-user-key-file)
echo $SSH_KEY_FILE
```

**Expected Output**:

You should see a file path similar to: `/Users/kezhenxu94/.ssh/skywalking.pem`

### 2. Test Connectivity to the EC2 Instances

Before installing SkyWalking, ensure that you can connect to the EC2 instances:

```
ANSIBLE_HOST_KEY_CHECKING=False ansible -m ping all -u ec2-user --private-key "$SSH_KEY_FILE"
```

**Expected Output**:

You should see output for each IP with a `SUCCESS` status:
```text
<ip1> | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": false,
    "ping": "pong"
}
<ip2> | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": false,
    "ping": "pong"
}
```

### 3. Install Apache SkyWalking

After confirming connectivity, proceed to install Apache SkyWalking using the Ansible playbook:

```
ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u ec2-user --private-key "$SSH_KEY_FILE" playbooks/install-skywalking.yml
```

### 4. Configurations

The Ansible playbook can be customized to install Apache SkyWalking with
different configurations. The following variables can be modified to suit your
needs: 

> For full configurations, refer to the
> [ansible/roles/skywalking/vars/main.yml](ansible/roles/skywalking/vars/main.yml).
> file.

```yaml
# `skywalking_tarball` can be a remote URL or a local path, if it's a remote URL
# the remote file will be downloaded to the remote host and then extracted,
# if it's a local path, the local file will be copied to the remote host and
# then extracted.
skywalking_tarball: "https://dist.apache.org/repos/dist/release/skywalking/9.5.0/apache-skywalking-apm-9.5.0.tar.gz"

# `skywalking_ui_environment` is a dictionary of environment variables that will
# be sourced when running the skywalking-ui service. All environment variables
# that are supported by SkyWalking webapp can be set here.
skywalking_ui_environment: {}

# `skywalking_oap_environment` is a dictionary of environment variables that will
# be sourced when running the skywalking-oap service. All environment variables
# that are supported by SkyWalking OAP can be set here.
skywalking_oap_environment: {}

```
