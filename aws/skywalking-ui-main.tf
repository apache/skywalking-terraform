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

resource "aws_instance" "skywalking-ui" {
  count         = var.ui_instance_count
  ami           = data.aws_ami.amazon-linux.id
  instance_type = var.instance_type
  key_name      = aws_key_pair.ssh-user.id
  vpc_security_group_ids = [
    aws_security_group.skywalking-ui.id,
    aws_security_group.ssh-access.id,
    aws_security_group.public-egress-access.id
  ]
  tags = merge(
    {
      Name        = "skywalking-ui"
      Description = "Installing and configuring SkyWalking UI on AWS"
    },
    var.extra_tags
  )
}

resource "aws_security_group" "skywalking-ui" {
  name        = "skywalking-ui"
  description = "Security group for SkyWalking UI"
  ingress = [
    {
      from_port        = 8080
      to_port          = 8080
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      description      = "Allow access from Intenet to SkyWalking UI"
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]
  tags = var.extra_tags
}

