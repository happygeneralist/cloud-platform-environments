
variable "cluster_name" {
}


variable "application" {
  description = "Name of Application you are deploying"
  default     = "Track a Move"
}

variable "namespace" {
  default = "track-a-move-dev"
}

variable "business_unit" {
  description = "Area of the MOJ responsible for the service."
  default     = "HMPPS"
}

variable "team_name" {
  description = "The name of your development team"
  default     = "pecs"
}

variable "environment" {
  description = "The type of environment you're deploying to."
  default     = "development"
}

variable "environment_name" {
  description = "The name of environment"
  default     = "dev"
}

variable "environment_suffix" {
  description = "The name of environment"
  default     = "dev"
}

variable "infrastructure_support" {
  description = "The team responsible for managing the infrastructure. Should be of the form team-email."
  default     = "pecs-digital-tech@digital.justice.gov.uk"
}

variable "is_production" {
  default = "false"
}

variable "slack_channel" {
  description = "Team slack channel to use if we need to contact your team"
  default     = "hmpps_dev"
}

variable "base_domain" {
  description = "Base domain where to create the custom hostname"
  default     = "bookasecuremove.service.justice.gov.uk"
}

variable "hostname" {
  description = "Host part of the FQDN"
  default     = "data-dev"
}

variable "base_domain_route53_namespace" {
  description = "Kubernetes namespace where the base domain was created"
  default     = "hmpps-book-secure-move-api-production"
}
