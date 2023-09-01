<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.10.0 |
| <a name="provider_local"></a> [local](#provider\_local) | 2.4.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.5.1 |
| <a name="provider_tls"></a> [tls](#provider\_tls) | 4.0.4 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_alb"></a> [alb](#module\_alb) | terraform-aws-modules/alb/aws | ~> 8.0 |
| <a name="module_rds"></a> [rds](#module\_rds) | terraform-aws-modules/rds/aws | ~> 5.0 |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-aws-modules/vpc/aws | ~> 5.0 |

## Resources

| Name | Type |
|------|------|
| [aws_instance.bastion](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_instance.skywalking-oap](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_instance.skywalking-ui](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_key_pair.ssh-user](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair) | resource |
| [aws_security_group.allow_apps](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.bastion](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.public-egress-access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.skywalking-oap](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.skywalking-ui](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [local_file.inventories](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [local_file.ssh-user](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [random_password.rds_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [tls_private_key.ssh-user](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |
| [aws_ami.amazon-linux](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_key"></a> [access\_key](#input\_access\_key) | Access key of the AWS account, if you have configured AWS CLI, you can leave it empty. | `string` | `""` | no |
| <a name="input_bastion_enabled"></a> [bastion\_enabled](#input\_bastion\_enabled) | Enable bastion host, if you want to access the instances via SSH, you must enable it. | `bool` | `true` | no |
| <a name="input_bastion_instance_type"></a> [bastion\_instance\_type](#input\_bastion\_instance\_type) | CPU, memory, storage and networking capacity for bastion host | `string` | `"t2.micro"` | no |
| <a name="input_cidr"></a> [cidr](#input\_cidr) | CIDR for database tier | `string` | `"11.0.0.0/16"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the cluster | `string` | `"skywalking-cluster"` | no |
| <a name="input_database_subnets"></a> [database\_subnets](#input\_database\_subnets) | CIDR used for database subnets | `set(string)` | <pre>[<br>  "11.0.104.0/24",<br>  "11.0.105.0/24",<br>  "11.0.106.0/24"<br>]</pre> | no |
| <a name="input_db_instance_class"></a> [db\_instance\_class](#input\_db\_instance\_class) | Instance class for the database | `string` | `"db.t3.medium"` | no |
| <a name="input_db_max_storage_size"></a> [db\_max\_storage\_size](#input\_db\_max\_storage\_size) | Maximum storage size for the database, in GB | `number` | `100` | no |
| <a name="input_db_name"></a> [db\_name](#input\_db\_name) | Name of the database | `string` | `"skywalking"` | no |
| <a name="input_db_password"></a> [db\_password](#input\_db\_password) | Password for the database, if not set, a random password will be generated. | `string` | `null` | no |
| <a name="input_db_storage_size"></a> [db\_storage\_size](#input\_db\_storage\_size) | Storage size for the database, in GB | `number` | `5` | no |
| <a name="input_db_username"></a> [db\_username](#input\_db\_username) | Username for the database | `string` | `"skywalking"` | no |
| <a name="input_extra_tags"></a> [extra\_tags](#input\_extra\_tags) | Additional tags to be added to all resources | `map(string)` | `{}` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | CPU, memory, storage and networking capacity for OAP and UI instances | `string` | `"t2.medium"` | no |
| <a name="input_oap_instance_count"></a> [oap\_instance\_count](#input\_oap\_instance\_count) | Number of OAP instances, if you want to use H2 storage, you must set it to 1. | `number` | `1` | no |
| <a name="input_private_subnets"></a> [private\_subnets](#input\_private\_subnets) | CIDR used for private subnets | `set(string)` | <pre>[<br>  "11.0.1.0/24",<br>  "11.0.2.0/24",<br>  "11.0.3.0/24"<br>]</pre> | no |
| <a name="input_public_key_path"></a> [public\_key\_path](#input\_public\_key\_path) | Path to store the key file for SSH access to the instances. | `string` | `"~/.ssh"` | no |
| <a name="input_public_subnets"></a> [public\_subnets](#input\_public\_subnets) | CIDR used for public subnets | `set(string)` | <pre>[<br>  "11.0.101.0/24",<br>  "11.0.102.0/24",<br>  "11.0.103.0/24"<br>]</pre> | no |
| <a name="input_region"></a> [region](#input\_region) | Physical location for clustered data centers. | `string` | `"us-east-1"` | no |
| <a name="input_secret_key"></a> [secret\_key](#input\_secret\_key) | Secret key of the AWS account, if you have configured AWS CLI, you can leave it empty. | `string` | `""` | no |
| <a name="input_storage"></a> [storage](#input\_storage) | Storage type for SkyWalking OAP, can be 'h2', or 'rds-postgresql' | `string` | `"rds-postgresql"` | no |
| <a name="input_ui_instance_count"></a> [ui\_instance\_count](#input\_ui\_instance\_count) | Number of UI instances | `number` | `1` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_alb_dns_name"></a> [alb\_dns\_name](#output\_alb\_dns\_name) | The domain name of the ALB that can be used to access SkyWalking UI. |
| <a name="output_bastion_ips"></a> [bastion\_ips](#output\_bastion\_ips) | The public IP that can be used to SSH into the bastion host. |
| <a name="output_database_address"></a> [database\_address](#output\_database\_address) | The database address |
| <a name="output_database_name"></a> [database\_name](#output\_database\_name) | The database name |
| <a name="output_database_password"></a> [database\_password](#output\_database\_password) | The database password |
| <a name="output_database_port"></a> [database\_port](#output\_database\_port) | The database port |
| <a name="output_database_username"></a> [database\_username](#output\_database\_username) | The database username |
| <a name="output_skywalking_oap_ips"></a> [skywalking\_oap\_ips](#output\_skywalking\_oap\_ips) | The private IPs of the OAP instances |
| <a name="output_skywalking_ui_ips"></a> [skywalking\_ui\_ips](#output\_skywalking\_ui\_ips) | The IPs of the SkyWalking UI instances |
| <a name="output_ssh-user-key-file"></a> [ssh-user-key-file](#output\_ssh-user-key-file) | The SSH key file that can be used to connect to the bastion instance. |
<!-- END_TF_DOCS -->