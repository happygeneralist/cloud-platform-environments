module "rds_aurora" {
  source = "github.com/ministryofjustice/cloud-platform-terraform-rds-aurora?ref=1.6"

  team_name                   = var.team_name
  business-unit               = var.business-unit
  application                 = var.application
  is-production               = var.is-production
  namespace                   = var.namespace
  environment-name            = var.environment-name
  infrastructure-support      = var.infrastructure-support
  engine                      = "aurora-postgresql"
  engine_version              = "12.4"
  engine_mode                 = "provisioned"
  replica_count               = 1
  instance_type               = "db.t3.medium"
  storage_encrypted           = true
  apply_immediately           = true
  cluster_name                = var.cluster_name
  allow_major_version_upgrade = true

  providers = {
    aws = aws.london
  }
}

resource "random_id" "education_skills_work_employment_update_role_password" {
  byte_length = 32
}

resource "random_id" "education_skills_work_employment_read_role_password" {
  byte_length = 32
}

resource "kubernetes_secret" "education_skills_work_employment_rds_aurora" {
  metadata {
    name      = "education-skills-work-employment-rds-aurora-instance-output"
    namespace = var.namespace
  }

  data = {
    rds_cluster_endpoint                = module.rds_aurora.rds_cluster_endpoint
    rds_cluster_reader_endpoint         = module.rds_aurora.rds_cluster_reader_endpoint
    db_cluster_identifier               = module.rds_aurora.db_cluster_identifier
    database_name                       = module.rds_aurora.database_name
    database_username                   = module.rds_aurora.database_username
    database_password                   = module.rds_aurora.database_password
    education_skills_work_employment_update_password = random_id.education_skills_work_employment_update_role_password.b64
    education_skills_work_employment_read_password   = random_id.education_skills_work_employment_read_role_password.b64
    access_key_id                       = module.rds_aurora.access_key_id
    secret_access_key                   = module.rds_aurora.secret_access_key
    url                                 = "postgres://${module.rds_aurora.database_username}:${module.rds_aurora.database_password}@${module.rds_aurora.rds_cluster_endpoint}/${module.rds_aurora.database_name}"
    reader_url                          = "postgres://${module.rds_aurora.database_username}:${module.rds_aurora.database_password}@${module.rds_aurora.rds_cluster_reader_endpoint}/${module.rds_aurora.database_name}"
  }

}

