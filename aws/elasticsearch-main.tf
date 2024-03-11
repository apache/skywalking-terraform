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

locals {
  elasticsearch_domain_name                = coalesce(lookup(local.storage_config, "domain_name", var.cluster_name))
  elasticsearch_version                    = coalesce(lookup(local.storage_config, "version", "7.10"))
  elasticsearch_instance_type              = coalesce(lookup(local.storage_config, "instance_type","m3.medium.elasticsearch"))
  elasticsearch_instance_count             = coalesce(lookup(local.storage_config, "instance_count", 2))
  elasticsearch_additional_security_groups = coalesce(lookup(local.storage_config, "additional_security_groups", []))
  elasticsearch_zone_awareness_enabled     = coalesce(lookup(local.storage_config, "zone_awareness_enabled", false))
  elasticsearch_availability_zone_count    = coalesce(lookup(local.storage_config, "availability_zone_count",2))
  elasticsearch_ebs_enabled                = coalesce(lookup(local.storage_config, "ebs_enabled",false))
}

data "aws_caller_identity" "current" {}

resource "aws_elasticsearch_domain" "elasticsearch" {
  count = local.storage_name == "elasticsearch" ? 1 : 0

  domain_name           = local.elasticsearch_domain_name
  elasticsearch_version = local.elasticsearch_version

  cluster_config {
    instance_type          = local.elasticsearch_instance_type
    instance_count         = local.elasticsearch_instance_count
    zone_awareness_enabled = local.elasticsearch_zone_awareness_enabled
    zone_awareness_config {
      availability_zone_count = local.elasticsearch_availability_zone_count
    }
  }

  vpc_options {
    subnet_ids = slice(module.vpc.private_subnets, 0, local.elasticsearch_zone_awareness_enabled ? 2 : 1)

    security_group_ids = [aws_security_group.elasticsearch.id]
  }

  ebs_options {
    ebs_enabled = local.elasticsearch_ebs_enabled
  }

  access_policies = <<CONFIG
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "es:*",
      "Principal": "*",
      "Effect": "Allow",
      "Resource": "arn:aws:es:${var.region}:${data.aws_caller_identity.current.account_id}:domain/${local.elasticsearch_domain_name}/*"
    }
  ]
}
CONFIG

  tags = var.extra_tags
}

resource "aws_security_group" "elasticsearch" {
  name        = "${module.vpc.vpc_id}-elasticsearch-${local.elasticsearch_domain_name}"
  description = "Security group to allow requests to ElasticSearch"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = module.skywalking.oap_security_groups
  }
}

resource "local_file" "elasticsearch_vars" {
  count = local.storage_name == "elasticsearch" ? 1 : 0

  filename        = "${path.module}/../ansible/inventory/group_vars/skywalking_oap.yaml"
  file_permission = "0600"
  content = templatefile("${path.module}/../ansible/template/group_vars/skywalking_oap.yaml.tftpl", {
    database_type     = local.storage_name
    database_host     = local.storage_name == "elasticsearch" ? aws_elasticsearch_domain.elasticsearch[0].endpoint : ""
    database_port     = ""
    database_user     = ""
    database_name     = ""
    database_password = ""
  })
}
