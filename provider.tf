module "global_variables" {
  source="modules/global_variables"
}

provider "aws" {
  region     = "${module.global_variables.region}"
  profile    = "${module.global_variables.profile}"
}