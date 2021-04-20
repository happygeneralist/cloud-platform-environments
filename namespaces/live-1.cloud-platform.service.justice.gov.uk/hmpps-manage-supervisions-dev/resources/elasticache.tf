module "hmpps_manage_supervisions_redis" {
  source                 = "github.com/ministryofjustice/cloud-platform-terraform-elasticache-cluster?ref=5.1"
  cluster_name           = var.cluster_name
  application            = var.application
  environment-name       = var.environment
  is-production          = var.is_production
  infrastructure-support = var.infrastructure_support
  team_name              = var.team_name
  number_cache_clusters  = var.number_cache_clusters
  node_type              = "cache.t2.small"
  engine_version         = "6.x"
  parameter_group_name   = "default.redis6.x"
  namespace              = var.namespace

  providers = {
    aws = aws.london
  }
}

resource "kubernetes_secret" "hmpps_manage_supervisions_redis" {
  metadata {
    name      = "hmpps-manage-supervisions-elasticache-redis"
    namespace = var.namespace
  }

  data = {
    primary_endpoint_address = module.hmpps_manage_supervisions_redis.primary_endpoint_address
    auth_token               = module.hmpps_manage_supervisions_redis.auth_token
    member_clusters          = jsonencode(module.hmpps_manage_supervisions_redis.member_clusters)
  }
}
