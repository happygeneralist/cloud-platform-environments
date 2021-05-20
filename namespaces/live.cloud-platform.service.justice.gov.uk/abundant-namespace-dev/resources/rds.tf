module "rds" {
  source        = "github.com/ministryofjustice/cloud-platform-terraform-rds-instance?ref=5.16.1"
  cluster_name  = var.cluster_name
  team_name     = var.team_name
  business-unit = var.business_unit
  application   = var.application
  is-production = var.is_production
  namespace     = var.namespace

  # enable performance insights
  performance_insights_enabled = true

  # change the postgres version as you see fit.
  db_engine_version           = "10"
  allow_minor_version_upgrade = true
  environment-name            = var.environment
  infrastructure-support      = var.infrastructure_support

  # rds_family should be one of: postgres9.4, postgres9.5, postgres9.6, postgres10, postgres11
  # Pick the one that defines the postgres version the best
  rds_family = "postgres10"

  # use "allow_major_version_upgrade" when upgrading the major version of an engine
  allow_major_version_upgrade = "false"

  providers = {
    # Can be either "aws.london" or "aws.ireland"
    aws = aws.london
  }
}

resource "kubernetes_secret" "rds" {
  metadata {
    name      = "example-rds-output"
    namespace = var.namespace
  }

  data = {
    rds_instance_endpoint = module.rds.rds_instance_endpoint
    database_name         = module.rds.database_name
    database_username     = module.rds.database_username
    database_password     = module.rds.database_password
    rds_instance_address  = module.rds.rds_instance_address
    access_key_id         = module.rds.access_key_id
    secret_access_key     = module.rds.secret_access_key
  }
  /* You can replace all of the above with the following, if you prefer to
     * use a single database URL value in your application code:
     *
     * url = "postgres://${module.rds.database_username}:${module.rds.database_password}@${module.rds.rds_instance_endpoint}/${module.rds.database_name}"
     *
     */
}

resource "kubernetes_config_map" "rds" {
  metadata {
    name      = "rds-instance-output"
    namespace = var.namespace
  }

  data = {
    database_name = module.rds.database_name
    db_identifier = module.rds.db_identifier

  }
}

module "borgsql" {
  source = "github.com/ministryofjustice/cloud-platform-terraform-rds-instance?ref=5.16.1"

  cluster_name           = var.cluster_name
  team_name              = var.team_name
  business-unit          = var.business_unit
  application            = var.application
  is-production          = var.is_production
  namespace              = var.namespace
  environment-name       = var.environment
  infrastructure-support = var.infrastructure_support

  # enable performance insights
  performance_insights_enabled = true

  db_engine                   = "sqlserver-ex"
  db_engine_version           = "15.00.4073.23.v1"
  db_instance_class           = "db.t3.medium"
  db_allocated_storage        = 32
  rds_family                  = "sqlserver-ex-15.0"
  allow_minor_version_upgrade = true
  allow_major_version_upgrade = false

  providers = {
    # Can be either "aws.london" or "aws.ireland"
    aws = aws.london
  }
}

resource "kubernetes_secret" "borgsql" {
  metadata {
    name      = "borgsql-output"
    namespace = var.namespace
  }

  data = {
    rds_instance_endpoint = module.borgsql.rds_instance_endpoint
    database_username     = module.borgsql.database_username
    database_password     = module.borgsql.database_password
    rds_instance_address  = module.borgsql.rds_instance_address
    access_key_id         = module.borgsql.access_key_id
    secret_access_key     = module.borgsql.secret_access_key
  }
}