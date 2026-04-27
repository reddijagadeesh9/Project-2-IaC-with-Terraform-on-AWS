module "networking" {
  source = "./modules/networking"
}

module "security" {
  source = "./modules/security"
  vpc_id = module.networking.vpc_id
}

module "compute" {
  source           = "./modules/compute"
  public_subnet_id = module.networking.public_subnet_1_id
  ec2_sg_id        = module.security.ec2_sg_id
}

module "database" {
  source              = "./modules/database"
  private_subnet_1_id = module.networking.private_subnet_1_id
  private_subnet_2_id = module.networking.private_subnet_2_id
  rds_sg_id           = module.security.rds_sg_id
}
