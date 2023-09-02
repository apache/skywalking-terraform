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

output "ui_instances" {
  value       = aws_instance.skywalking-ui
  description = "The SkyWalking UI instances"
}

output "ui_instance_ids" {
  value       = aws_instance.skywalking-ui.*.id
  description = "The IDs of the SkyWalking UI instances"
}

output "ui_ips" {
  value       = aws_instance.skywalking-ui.*.private_ip
  description = "The IPs of the SkyWalking UI instances"
}

output "ui_security_groups" {
  value       = [aws_security_group.skywalking-ui.id]
  description = "The security groups of the SkyWalking UI instances"
}

output "oap_instances" {
  value       = aws_instance.skywalking-oap
  description = "The OAP instances"
}

output "oap_instance_ids" {
  value       = aws_instance.skywalking-oap.*.id
  description = "The IDs of the OAP instances"
}

output "oap_ips" {
  value       = aws_instance.skywalking-oap.*.private_ip
  description = "The private IPs of the OAP instances"
}

output "oap_security_groups" {
  value       = [aws_security_group.skywalking-oap.id]
  description = "The security groups of the OAP instances"
}

output "bastion_instances" {
  value       = aws_instance.bastion
  description = "The bastion instances"
}

output "bastion_ips" {
  value       = aws_instance.bastion.*.public_ip
  description = "The public IP that can be used to SSH into the bastion host"
}

output "ssh_user_key_file" {
  value       = local_file.ssh-user.filename
  description = "The SSH key file that can be used to connect to the bastion instance."
}

