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

locals {
  ui_ami_id = var.ui_instance_ami_id != "" ? var.ui_instance_ami_id : data.aws_ami.amazon-linux.id
}

resource "aws_instance" "skywalking-ui" {
  count         = var.ui_instance_count
  ami           = local.ui_ami_id
  instance_type = var.ui_instance_type
  key_name      = aws_key_pair.ssh-user.id
  subnet_id     = var.ui_instance_subnet_id

  vpc_security_group_ids = concat(
    var.ui_instance_security_group_ids,
    [aws_security_group.skywalking-ui.id]
  )

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
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    description     = "Allow SSH access from the bastion"
    security_groups = [aws_security_group.bastion.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = var.extra_tags
}

