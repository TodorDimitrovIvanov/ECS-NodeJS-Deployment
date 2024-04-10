variable "region" {}
variable "ami" {}

provider "aws" {
  region = "${region}"
}

module "setup" {
  source = "./modules"
}