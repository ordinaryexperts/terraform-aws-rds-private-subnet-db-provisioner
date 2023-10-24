locals {
  tags = {
    Terratest = var.name
  }
}
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.2"

  name             = var.name
  cidr             = "10.0.0.0/16"
  azs              = ["${var.region}a", "${var.region}b", "${var.region}c"]
  private_subnets  = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  database_subnets = ["10.1.1.0/24", "10.1.2.0/24", "10.1.3.0/24"]
  tags             = local.tags
}

resource "random_password" "master" {
  length  = 20
  special = false
}

data "aws_rds_engine_version" "postgresql" {
  engine  = "aurora-postgresql"
  version = "14.5"
}

module "rds" {
  source  = "terraform-aws-modules/rds-aurora/aws"
  version = "8.5.0"

  name                 = var.name
  engine               = data.aws_rds_engine_version.postgresql.engine
  engine_mode          = "provisioned"
  engine_version       = data.aws_rds_engine_version.postgresql.version
  storage_encrypted    = false
  vpc_id               = module.vpc.vpc_id
  db_subnet_group_name = module.vpc.database_subnet_group_name
  master_password      = random_password.master.result
  apply_immediately    = true
  skip_final_snapshot  = true
  tags                 = local.tags

  security_group_rules = {
    vpc_ingress = {
      cidr_blocks = module.vpc.private_subnets_cidr_blocks
    }
  }

  serverlessv2_scaling_configuration = {
    min_capacity = 0.5
    max_capacity = 1.0
  }

}

resource "aws_security_group" "db_access" {
  name   = "${var.name}-db-access"
  vpc_id = module.vpc.vpc_id
}

resource "aws_security_group_rule" "db_access" {
  description              = "Access from SG ${aws_security_group.db_access.name} to RDS"
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 5432
  to_port                  = 5432
  security_group_id        = module.rds.security_group_id
  source_security_group_id = aws_security_group.db_access.id
}

module "db_provisioner" {
  source = "../"

  name               = "db-provisioner-experiment"
  subnet_ids         = module.vpc.private_subnets
  security_group_ids = [aws_security_group.db_access.id]
}
