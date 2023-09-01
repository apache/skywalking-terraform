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

variable "region" {
  type        = string
  description = "Physical location for clustered data centers."
  default     = "us-east-1"
}

variable "access_key" {
  type        = string
  description = "Access key of the AWS account, if you have configured AWS CLI, you can leave it empty."
  default     = ""
}

variable "secret_key" {
  type        = string
  description = "Secret key of the AWS account, if you have configured AWS CLI, you can leave it empty."
  default     = ""
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

variable "ui_instance_count" {
  type        = number
  description = "Number of UI instances"
  default     = 1
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

variable "instance_type" {
  type        = string
  description = "CPU, memory, storage and networking capacity for OAP and UI instances"
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

## VPC
variable "cidr" {
  type        = string
  description = "CIDR for database tier"
  default     = "11.0.0.0/16"
}

variable "private_subnets" {
  type        = set(string)
  description = "CIDR used for private subnets"
  default     = ["11.0.1.0/24", "11.0.2.0/24", "11.0.3.0/24"]
}

variable "public_subnets" {
  type        = set(string)
  description = "CIDR used for public subnets"
  default     = ["11.0.101.0/24", "11.0.102.0/24", "11.0.103.0/24"]
}

variable "database_subnets" {
  type        = set(string)
  description = "CIDR used for database subnets"
  default     = ["11.0.104.0/24", "11.0.105.0/24", "11.0.106.0/24"]
}

## Storage
variable "storage" {
  type        = string
  description = "Storage type for SkyWalking OAP, can be 'h2', or 'rds-postgresql'"
  default     = "rds-postgresql"

  validation {
    condition     = contains(["h2", "rds-postgresql"], var.storage)
    error_message = "Allowed values for storage are \"h2\", \"rds-postgresql\"."
  }
}

variable "db_name" {
  type        = string
  description = "Name of the database"
  default     = "skywalking"
}

variable "db_username" {
  type        = string
  description = "Username for the database"
  default     = "skywalking"
}

variable "db_password" {
  type        = string
  description = "Password for the database, if not set, a random password will be generated."
  default     = null
}

variable "db_storage_size" {
  type        = number
  description = "Storage size for the database, in GB"
  default     = 5
}

variable "db_max_storage_size" {
  type        = number
  description = "Maximum storage size for the database, in GB"
  default     = 100
}

variable "db_instance_class" {
  type        = string
  description = "Instance class for the database"
  default     = "db.t3.medium"
}

