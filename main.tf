variable "region" {}
variable "ami" {}
variable "vpc_cidr" {}
variable "sub1_cidr" {}
variable "sub2_cidr" {}
variable "zone1" {}
variable "zone2" {}
variable "cluster_name" {}

provider "aws" {
  region = var.region
}

module "ecs" {
  source = "./module_ecs"
  vpc_cidr = var.vpc_cidr
  sub1_cidr = var.sub1_cidr
  sub2_cidr = var.sub2_cidr
  zone1 = var.zone1
  zone2 = var.zone2
  cluster_name = var.cluster_name
}