<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_local"></a> [local](#provider\_local) | n/a |
| <a name="provider_tls"></a> [tls](#provider\_tls) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_instance.bastion](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_instance.skywalking-oap](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_instance.skywalking-ui](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_key_pair.ssh-user](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair) | resource |
| [aws_security_group.bastion](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.skywalking-oap](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.skywalking-ui](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [local_file.ssh-user](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [tls_private_key.ssh-user](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |
| [aws_ami.amazon-linux](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bastion_enabled"></a> [bastion\_enabled](#input\_bastion\_enabled) | Enable bastion host, if you want to access the instances via SSH, you must enable it. | `bool` | `true` | no |
| <a name="input_bastion_instance_type"></a> [bastion\_instance\_type](#input\_bastion\_instance\_type) | CPU, memory, storage and networking capacity for bastion host | `string` | `"t2.micro"` | no |
| <a name="input_bastion_ssh_cidr_blocks"></a> [bastion\_ssh\_cidr\_blocks](#input\_bastion\_ssh\_cidr\_blocks) | CIDR blocks for SSH access to bastion host | `list(string)` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the cluster | `string` | `"skywalking-cluster"` | no |
| <a name="input_create_lb"></a> [create\_lb](#input\_create\_lb) | Create a load balancer for UI instances | `bool` | `true` | no |
| <a name="input_extra_tags"></a> [extra\_tags](#input\_extra\_tags) | Additional tags to be added to all resources | `map(string)` | `{}` | no |
| <a name="input_oap_instance_ami_id"></a> [oap\_instance\_ami\_id](#input\_oap\_instance\_ami\_id) | AMI ID for OAP instances, if not set, a suitable AMI ID will be selected automatically. | `string` | `""` | no |
| <a name="input_oap_instance_count"></a> [oap\_instance\_count](#input\_oap\_instance\_count) | Number of OAP instances, if you want to use H2 storage, you must set it to 1. | `number` | `1` | no |
| <a name="input_oap_instance_security_group_ids"></a> [oap\_instance\_security\_group\_ids](#input\_oap\_instance\_security\_group\_ids) | Additional security groups for OAP instances | `list(string)` | `[]` | no |
| <a name="input_oap_instance_subnet_id"></a> [oap\_instance\_subnet\_id](#input\_oap\_instance\_subnet\_id) | Subnet ID for OAP instances | `string` | n/a | yes |
| <a name="input_oap_instance_type"></a> [oap\_instance\_type](#input\_oap\_instance\_type) | CPU, memory, storage and networking capacity for OAP instances | `string` | `"c5.xlarge"` | no |
| <a name="input_public_key_path"></a> [public\_key\_path](#input\_public\_key\_path) | Path to store the key file for SSH access to the instances. | `string` | `"~/.ssh"` | no |
| <a name="input_storage"></a> [storage](#input\_storage) | Storage type for SkyWalking OAP, can be `h2`, `elasticsearch` or `rds-postgresql` | `string` | `"rds-postgresql"` | no |
| <a name="input_ui_instance_ami_id"></a> [ui\_instance\_ami\_id](#input\_ui\_instance\_ami\_id) | AMI ID for UI instances, if not set, a suitable AMI ID will be selected automatically. | `string` | `""` | no |
| <a name="input_ui_instance_count"></a> [ui\_instance\_count](#input\_ui\_instance\_count) | Number of UI instances | `number` | `1` | no |
| <a name="input_ui_instance_security_group_ids"></a> [ui\_instance\_security\_group\_ids](#input\_ui\_instance\_security\_group\_ids) | Additional security groups for UI instances | `list(string)` | `[]` | no |
| <a name="input_ui_instance_subnet_id"></a> [ui\_instance\_subnet\_id](#input\_ui\_instance\_subnet\_id) | Subnet ID for UI instances | `string` | n/a | yes |
| <a name="input_ui_instance_type"></a> [ui\_instance\_type](#input\_ui\_instance\_type) | CPU, memory, storage and networking capacity for UI instances | `string` | `"t2.medium"` | no |
| <a name="input_vpc_bastion_subnet_id"></a> [vpc\_bastion\_subnet\_id](#input\_vpc\_bastion\_subnet\_id) | Subnet ID for bastion host | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC ID | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bastion_instances"></a> [bastion\_instances](#output\_bastion\_instances) | The bastion instances |
| <a name="output_bastion_ips"></a> [bastion\_ips](#output\_bastion\_ips) | The public IP that can be used to SSH into the bastion host |
| <a name="output_oap_instance_ids"></a> [oap\_instance\_ids](#output\_oap\_instance\_ids) | The IDs of the OAP instances |
| <a name="output_oap_instances"></a> [oap\_instances](#output\_oap\_instances) | The OAP instances |
| <a name="output_oap_ips"></a> [oap\_ips](#output\_oap\_ips) | The private IPs of the OAP instances |
| <a name="output_oap_security_groups"></a> [oap\_security\_groups](#output\_oap\_security\_groups) | The security groups of the OAP instances |
| <a name="output_ssh_user_key_file"></a> [ssh\_user\_key\_file](#output\_ssh\_user\_key\_file) | The SSH key file that can be used to connect to the bastion instance. |
| <a name="output_ui_instance_ids"></a> [ui\_instance\_ids](#output\_ui\_instance\_ids) | The IDs of the SkyWalking UI instances |
| <a name="output_ui_instances"></a> [ui\_instances](#output\_ui\_instances) | The SkyWalking UI instances |
| <a name="output_ui_ips"></a> [ui\_ips](#output\_ui\_ips) | The IPs of the SkyWalking UI instances |
| <a name="output_ui_security_groups"></a> [ui\_security\_groups](#output\_ui\_security\_groups) | The security groups of the SkyWalking UI instances |
<!-- END_TF_DOCS -->