#vf-common-tags.tf : Defined per project. Additional tags may be added

# [JC] Environment to be changed to "PROD" when PCS identifies the final solution ( final code )
# [JC] ManagedBy to be changed to "tssi - infra team" when PCS conclude the project and handover to TSSI for (infra) ops

locals {
  common_tags = {
    Project         = var.Project
    ManagedBy       = var.ManagedBy
    TaggingVersion  = var.TaggingVersion
    Confidentiality = var.Confidentiality
    Environment     = var.Environment
    SecurityZone    = var.SecurityZone
  }
}
