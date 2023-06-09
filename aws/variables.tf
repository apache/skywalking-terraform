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

variable "ami" {
  type        = string
  description = "Amazon Machine Image"
  default     = "ami-026ebd4cfe2c043b2"
}

variable "instance_type" {
  type        = string
  description = "CPU, memory, storage and networking capacity"
  default     = "t2.medium"
}

variable "public_key_path" {
  type        = string
  description = "Path to the public key file"
  default     = "~/.ssh/skywalking-terraform.pub"
}

variable "extra_tags" {
  description = "Additional tags to be added to all resources"
  type        = map(string)
  default     = {}
}
