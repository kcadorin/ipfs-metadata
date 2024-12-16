module "rds" {
  source  = "terraform-aws-modules/rds/aws"
  version = "6.10.0"

  count = local.module_vars.enabled ? 1 : 0

  identifier        = local.module_vars.name
  engine            = local.module_vars.engine
  engine_version    = local.module_vars.engine_version
  instance_class    = local.module_vars.instance_class
  allocated_storage = local.module_vars.allocated_storage

  db_name  = local.module_vars.db_name
  username = local.module_vars.username
  port     = local.module_vars.port

  create_db_subnet_group = true
  subnet_ids             = local.module_vars.subnet_ids

  deletion_protection = true

  family = local.module_vars.family
}
