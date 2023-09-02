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

module "skywalking" {
  source = "./modules/skywalking"

  cluster_name = var.cluster_name
  storage      = var.storage

  oap_instance_count     = var.oap_instance_count
  oap_instance_type      = var.oap_instance_type
  oap_instance_subnet_id = element(module.vpc.private_subnets, 0)

  ui_instance_count              = var.ui_instance_count
  ui_instance_type               = var.ui_instance_type
  ui_instance_subnet_id          = element(module.vpc.private_subnets, 0)
  ui_instance_security_group_ids = var.create_lb ? aws_security_group.alb-skywalking-ui.*.id : []

  bastion_enabled         = var.bastion_enabled
  bastion_instance_type   = var.bastion_instance_type
  bastion_ssh_cidr_blocks = var.bastion_ssh_cidr_blocks
  public_key_path         = var.public_key_path

  vpc_id                = module.vpc.vpc_id
  vpc_bastion_subnet_id = element(module.vpc.public_subnets, 0)
}
