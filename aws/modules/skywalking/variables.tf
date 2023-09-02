# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "vpc_bastion_subnet_id" {
  type        = string
  description = "Subnet ID for bastion host"
}

variable "cluster_name" {
  type        = string
  description = "Name of the cluster"
  default     = "skywalking-cluster"
}

variable "oap_instance_count" {
  type        = number
  description = "Number of OAP instances, if you want to use H2 storage, you must set it to 1."
  default     = 1
}

variable "oap_instance_ami_id" {
  type        = string
  description = "AMI ID for OAP instances, if not set, a suitable AMI ID will be selected automatically."
  default     = ""
}

variable "oap_instance_subnet_id" {
  type        = string
  description = "Subnet ID for OAP instances"
}

variable "oap_instance_security_group_ids" {
  type        = list(string)
  description = "Additional security groups for OAP instances"
  default     = []
}

variable "ui_instance_count" {
  type        = number
  description = "Number of UI instances"
  default     = 1
}

variable "ui_instance_ami_id" {
  type        = string
  description = "AMI ID for UI instances, if not set, a suitable AMI ID will be selected automatically."
  default     = ""
}

variable "ui_instance_subnet_id" {
  type        = string
  description = "Subnet ID for UI instances"
}

variable "ui_instance_security_group_ids" {
  type        = list(string)
  description = "Additional security groups for UI instances"
  default     = []
}

variable "bastion_enabled" {
  type        = bool
  description = "Enable bastion host, if you want to access the instances via SSH, you must enable it."
  default     = true
}

variable "bastion_instance_type" {
  type        = string
  description = "CPU, memory, storage and networking capacity for bastion host"
  default     = "t2.micro"
}

variable "bastion_ssh_cidr_blocks" {
  type        = list(string)
  description = "CIDR blocks for SSH access to bastion host"
  default     = ["0.0.0.0/0"]
}

variable "oap_instance_type" {
  type        = string
  description = "CPU, memory, storage and networking capacity for OAP instances"
  default     = "c5.xlarge"
}

variable "ui_instance_type" {
  type        = string
  description = "CPU, memory, storage and networking capacity for UI instances"
  default     = "t2.medium"
}

variable "public_key_path" {
  type        = string
  description = "Path to store the key file for SSH access to the instances."
  default     = "~/.ssh"
}

variable "extra_tags" {
  description = "Additional tags to be added to all resources"
  type        = map(string)
  default     = {}
}

## Storage
variable "storage" {
  type        = string
  description = "Storage type for SkyWalking OAP, can be `h2`, or `rds-postgresql`"
  default     = "rds-postgresql"

  validation {
    condition     = contains(["h2", "rds-postgresql"], var.storage)
    error_message = "Allowed values for storage are \"h2\", \"rds-postgresql\"."
  }
}

variable "create_lb" {
  type        = bool
  description = "Create a load balancer for UI instances"
  default     = true
}

