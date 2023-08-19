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

resource "aws_instance" "skywalking-oap" {
  count = var.oap_instance_count
  ami = data.aws_ami.amazon-linux.id
  instance_type = var.instance_type
  tags = merge(
    {
      Name = "skywalking-oap"
      Description = "Installing and configuring SkyWalking OAPService on AWS"
    },
    var.extra_tags
  )
  key_name = aws_key_pair.ssh-user.id
  vpc_security_group_ids = [
    aws_security_group.ssh-access.id,
    aws_security_group.public-egress-access.id,
    aws_security_group.ui-to-oap-communication.id
  ]
}

resource "aws_instance" "skywalking-ui" {
  count = var.ui_instance_count
  ami = data.aws_ami.amazon-linux.id
  instance_type = var.instance_type
  tags = merge(
    {
      Name = "skywalking-ui"
      Description = "Installing and configuring SkyWalking UI on AWS"
    },
    var.extra_tags
  )
  key_name = aws_key_pair.ssh-user.id
  vpc_security_group_ids = [
    aws_security_group.ssh-access.id,
    aws_security_group.public-egress-access.id
  ]
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

resource "aws_security_group" "public-egress-access" {
  name = "public-egress-access"
  description = "Allow access to the Internet"
  egress = [
    {
      from_port = 0
      to_port = 0
      protocol = -1
      cidr_blocks = ["0.0.0.0/0"]
      description     = "Allow access to the Internet"
      ipv6_cidr_blocks = []
      prefix_list_ids = []
      security_groups = []
      self            = false
    }
  ]
  tags = var.extra_tags
}

resource "aws_security_group" "ui-to-oap-communication" {
  name        = "ui-to-oap-communication"
  description = "Allow communication from SkyWalking UI to SkyWalking OAP"
  ingress {
    from_port      = 0
    to_port        = 12800
    protocol       = "tcp"
    security_groups = [aws_security_group.public-egress-access.id]
  }
  tags = var.extra_tags
}

resource "local_file" "oap_instance_ips" {
  count = var.oap_instance_count
  content = join("\n", flatten([
    ["[skywalking_oap]"],
    aws_instance.skywalking-oap.*.public_ip,
    [""]  # Adds an empty string for the trailing newline
  ]))
  filename = "${path.module}/../ansible/inventory/oap-server"
  file_permission = "0600"
}

resource "local_file" "ui_instance_ips" {
  count = var.ui_instance_count
  content = join("\n", flatten([
    ["[skywalking_ui]"],
    aws_instance.skywalking-ui.*.public_ip,
    [""]  # Adds an empty string for the trailing newline
  ]))
  filename = "${path.module}/../ansible/inventory/ui-server"
  file_permission = "0600"
}
