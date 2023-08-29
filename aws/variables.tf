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

variable "oap_instance_count" {
  type    = number
  default = 1
}

variable "ui_instance_count" {
  type    = number
  default = 1
}

variable "region" {
  type        = string
  description = "Physical location for clustered data centers."
  default     = "us-east-1"
}

variable "access_key" {
  type        = string
  description = "Access key of the AWS account"
  default     = ""
}

variable "secret_key" {
  type        = string
  description = "Secret key of the AWS account"
  default     = ""
}

variable "instance_type" {
  type        = string
  description = "CPU, memory, storage and networking capacity"
  default     = "t2.medium"
}

variable "public_key_path" {
  type        = string
  description = "Path to store the key file for SSH access to the instances"
  default     = "~/.ssh"
}

variable "extra_tags" {
  description = "Additional tags to be added to all resources"
  type        = map(string)
  default     = {}
}
