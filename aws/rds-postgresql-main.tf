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
  database_password = var.db_password != null ? var.db_password : random_password.rds_password.result
}

module "rds" {
  source  = "terraform-aws-modules/rds/aws"
  version = "~> 5.0"

  count = var.storage == "rds-postgresql" ? 1 : 0

  identifier = var.cluster_name

  allocated_storage     = var.db_storage_size
  max_allocated_storage = var.db_max_storage_size

  db_name                = var.db_name
  username               = var.db_username
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
  instance_class         = var.db_instance_class
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
