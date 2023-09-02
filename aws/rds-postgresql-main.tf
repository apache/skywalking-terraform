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

resource "random_password" "rds_password" {
  length  = 16
  special = false
}

locals {
  database_instance_class   = coalesce(lookup(local.storage_config, "db_instance_class", "db.t3.small"))
  database_storage_size     = coalesce(lookup(local.storage_config, "db_storage_size_gb", 20))
  database_max_storage_size = coalesce(lookup(local.storage_config, "db_max_storage_size_gb", 100))
  database_name             = coalesce(lookup(local.storage_config, "db_name", "skywalking"))
  database_username         = coalesce(lookup(local.storage_config, "db_username", "skywalking"))
  database_password         = coalesce(lookup(local.storage_config, "db_password", random_password.rds_password.result))
}

module "rds" {
  source  = "terraform-aws-modules/rds/aws"
  version = "~> 5.0"

  count = local.storage_name == "rds_postgresql" ? 1 : 0

  identifier = var.cluster_name

  allocated_storage     = local.database_storage_size
  max_allocated_storage = local.database_max_storage_size

  db_name                = local.database_name
  username               = local.database_username
  password               = local.database_password
  create_random_password = false
  port                   = "5432"

  create_db_subnet_group              = true
  iam_database_authentication_enabled = true
  skip_final_snapshot                 = true

  vpc_security_group_ids = [module.vpc.default_security_group_id, aws_security_group.allow_apps.id]

  multi_az = "false"

  maintenance_window      = "Wed:00:00-Wed:03:00"
  backup_window           = "03:00-06:00"
  backup_retention_period = "35"

  monitoring_role_name   = "RDSMonitoringRole"
  create_monitoring_role = false

  subnet_ids = module.vpc.database_subnets

  engine                 = "postgres"
  engine_version         = "15"
  family                 = "postgres15"
  major_engine_version   = "15.3"
  instance_class         = local.database_instance_class
  create_db_option_group = "false"

  parameters = [
    {
      name  = "client_encoding"
      value = "utf8"
    }
  ]
}

resource "aws_security_group" "allow_apps" {
  name        = "allow_apps"
  description = "Allow apps inbound traffic and database outbound traffic"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = module.skywalking.oap_security_groups
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "local_file" "rds_postgresql_vars" {
  count = local.storage_name == "rds_postgresql" ? 1 : 0

  filename        = "${path.module}/../ansible/inventory/group_vars/skywalking_oap.yaml"
  file_permission = "0600"
  content = templatefile("${path.module}/../ansible/template/group_vars/skywalking_oap.yaml.tftpl", {
    database_type     = local.storage_name
    database_host     = local.storage_name == "rds_postgresql" ? module.rds[0].db_instance_address : ""
    database_port     = local.storage_name == "rds_postgresql" ? module.rds[0].db_instance_port : ""
    database_user     = local.storage_name == "rds_postgresql" ? module.rds[0].db_instance_username : ""
    database_name     = local.storage_name == "rds_postgresql" ? module.rds[0].db_instance_name : ""
    database_password = local.storage_name == "rds_postgresql" ? local.database_password : ""
  })
}
