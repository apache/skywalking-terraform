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

provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}

resource "aws_security_group" "ssh-access" {
  name        = "ssh-access"
  description = "Allow SSH access from the Internet"
  ingress = [
    {
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      description      = "Allow SSH access from the Internet"
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]
  tags = var.extra_tags
}

resource "aws_security_group" "public-egress-access" {
  name        = "public-egress-access"
  description = "Allow access to the Internet"
  egress = [
    {
      from_port        = 0
      to_port          = 0
      protocol         = -1
      cidr_blocks      = ["0.0.0.0/0"]
      description      = "Allow access to the Internet"
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]
  tags = var.extra_tags
}

resource "local_file" "inventories" {
  filename        = "${path.module}/../ansible/inventory/skywalking.yaml"
  file_permission = "0600"
  content = templatefile("${path.module}/../ansible/inventory/template/skywalking.yaml.tftpl", {
    oap_instances = aws_instance.skywalking-oap
    ui_instances  = aws_instance.skywalking-ui
  })
}
