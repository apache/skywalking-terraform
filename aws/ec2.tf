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

resource "aws_instance" "skywalking" {
  ami = "ami-026ebd4cfe2c043b2"
  instance_type = "t2.medium"
  tags = {
    Name = "skywalking-terraform"
    Description = "Skywalking installed on RHEL"
  }
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
}

output publicip {
  value = aws_instance.skywalking.public_ip
}
