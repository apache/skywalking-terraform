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
    region = var.region
}

resource "aws_instance" "skywalking" {
  ami = var.ami
  instance_type = var.instance_type
  tags = merge(
    {
      Name = "skywalking-terraform"
      Description = "Installing and configuring Skywalking on AWS"
    },
    var.extra_tags
  )
  key_name = aws_key_pair.ssh-user.id
  vpc_security_group_ids = [ aws_security_group.ssh-access.id ]
}

resource "aws_security_group" "ssh-access" {
  name = "ssh-access"
  description = "Allow SSH access from the Internet"
  ingress = [
    {
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description     = "SSH access rule"
      ipv6_cidr_blocks = []
      prefix_list_ids = []
      security_groups = []
      self            = false
    }
  ]
  tags = var.extra_tags
}

resource "aws_key_pair" "ssh-user" {
    public_key = file(var.public_key_path)
    tags = var.extra_tags
}

resource "local_file" "write_to_host_file" {
  content  = "[skywalking-machine]\n${aws_instance.skywalking.public_ip}"
  filename = "${path.module}/../ansible/inventory/hosts"
}
