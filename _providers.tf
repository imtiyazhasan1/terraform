# providers.tf : Apart from region definition, this file is the same for all projects

variable "DEPLOY_ROLE" {} # Defined as (TF_VAR_)environment variable in CodeBuild

provider "aws" {
  region = var.region # replace with target region which has the codecommit repos, do not change after first being set

  assume_role {
    role_arn = var.DEPLOY_ROLE
  }
}
