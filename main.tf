provider "aws" {
  region = "eu-central-1"
}

module "setup" {
  source = "./modules"
}

variable "ami" {
  type = map 
  default = {
    debian = "ami-042e6fdb154c830c5"
  }
}