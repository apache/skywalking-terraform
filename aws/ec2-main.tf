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

resource "aws_security_group" "public-egress-access" {
  name        = "public-egress-access"
  description = "Allow access to the Internet"
  vpc_id      = module.vpc.vpc_id

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = -1
    cidr_blocks     = ["0.0.0.0/0"]
    description     = "Allow access to the Internet"
    security_groups = []
  }

  tags = var.extra_tags
}

resource "local_file" "inventories" {
  filename        = "${path.module}/../ansible/inventory/skywalking.yaml"
  file_permission = "0600"
  content = templatefile("${path.module}/../ansible/template/inventory.yaml.tftpl", {
    bastion           = module.skywalking.bastion_instances[0]
    oap_instances     = module.skywalking.oap_instances
    ui_instances      = module.skywalking.ui_instances
    private_key_file  = module.skywalking.ssh_user_key_file
    database_type     = var.storage
    database_host     = var.storage == "rds-postgresql" ? module.rds[0].db_instance_address : ""
    database_port     = var.storage == "rds-postgresql" ? module.rds[0].db_instance_port : ""
    database_user     = var.storage == "rds-postgresql" ? module.rds[0].db_instance_username : ""
    database_name     = var.storage == "rds-postgresql" ? module.rds[0].db_instance_name : ""
    database_password = var.storage == "rds-postgresql" ? local.database_password : ""
  })
}
