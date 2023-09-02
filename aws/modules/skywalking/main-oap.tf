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
  oap_ami_id = var.oap_instance_ami_id != "" ? var.oap_instance_ami_id : data.aws_ami.amazon-linux.id
}

resource "aws_instance" "skywalking-oap" {
  count         = var.oap_instance_count
  ami           = local.oap_ami_id
  instance_type = var.oap_instance_type
  key_name      = aws_key_pair.ssh-user.id
  subnet_id     = var.oap_instance_subnet_id

  vpc_security_group_ids = concat(
    var.oap_instance_security_group_ids,
    [aws_security_group.skywalking-oap.id]
  )

  tags = merge(
    {
      Name        = "skywalking-oap"
      Description = "Installing and configuring SkyWalking OAP on AWS"
    },
    var.extra_tags
  )

  lifecycle {
    precondition {
      condition     = !(var.oap_instance_count > 1 && var.storage == "h2")
      error_message = "OAP instance count must be 1 if storage is h2"
    }
  }
}

resource "aws_security_group" "skywalking-oap" {
  name        = "skywalking-oap"
  description = "Security group for SkyWalking OAP"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 12800
    to_port         = 12800
    protocol        = "tcp"
    security_groups = [aws_security_group.skywalking-ui.id]
    description     = "Allow incoming HTTP connections from SkyWalking UI"
  }
  ingress {
    from_port       = 9412
    to_port         = 9412
    protocol        = "tcp"
    security_groups = [aws_security_group.skywalking-ui.id]
    description     = "Allow incoming HTTP connections from SkyWalking UI"
  }
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
  }

  tags = var.extra_tags
}

