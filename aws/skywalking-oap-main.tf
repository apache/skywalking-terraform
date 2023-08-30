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

resource "aws_instance" "skywalking-oap" {
  count         = var.oap_instance_count
  ami           = data.aws_ami.amazon-linux.id
  instance_type = var.instance_type
  key_name      = aws_key_pair.ssh-user.id
  vpc_security_group_ids = [
    aws_security_group.skywalking-oap.id,
    aws_security_group.ssh-access.id,
    aws_security_group.public-egress-access.id
  ]
  tags = merge(
    {
      Name        = "skywalking-oap"
      Description = "Installing and configuring SkyWalking OAP on AWS"
    },
    var.extra_tags
  )
}

resource "aws_security_group" "skywalking-oap" {
  name        = "skywalking-oap"
  description = "Security group for SkyWalking OAP"
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
  tags = var.extra_tags
}

