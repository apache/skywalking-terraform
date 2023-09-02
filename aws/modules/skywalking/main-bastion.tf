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

resource "aws_instance" "bastion" {
  count                       = var.bastion_enabled ? 1 : 0
  ami                         = data.aws_ami.amazon-linux.id
  instance_type               = var.bastion_instance_type
  key_name                    = aws_key_pair.ssh-user.id
  subnet_id                   = var.vpc_bastion_subnet_id
  associate_public_ip_address = true

  vpc_security_group_ids = [aws_security_group.bastion.id]
  tags = merge(
    {
      Name        = "Bastion Host"
      Description = "Bastion host for SSH access"
    },
    var.extra_tags
  )

  connection {
    host        = self.public_ip
    user        = "ec2-user"
    type        = "ssh"
    private_key = tls_private_key.ssh-user.private_key_pem
  }

  provisioner "file" {
    content     = tls_private_key.ssh-user.private_key_pem
    destination = "/home/ec2-user/.ssh/id_rsa"

  }

  provisioner "remote-exec" {
    inline = ["chmod og-rwx /home/ec2-user/.ssh/id_rsa"]
  }
}

resource "aws_security_group" "bastion" {
  name        = "bastion"
  description = "Security group for bastion"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH access from the Internet"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.bastion_ssh_cidr_blocks
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.extra_tags
}
