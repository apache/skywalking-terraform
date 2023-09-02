# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

resource "tls_private_key" "ssh-user" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "ssh-user" {
  key_name   = "skywalking"
  public_key = tls_private_key.ssh-user.public_key_openssh
  tags       = var.extra_tags
}

resource "local_file" "ssh-user" {
  filename        = "${pathexpand(var.public_key_path)}/${aws_key_pair.ssh-user.key_name}.pem"
  content         = tls_private_key.ssh-user.private_key_pem
  file_permission = "0600"
}
