module "security" {
    source       = "./modules/security"
    project_name = var.project_name
    vpc_id       = data.aws_vpc.default.id
}

module "rds" {
    source        = "./modules/rds"
    project_name  = var.project_name

    db_username   = var.db_username
    db_password   = var.db_password

    subnet_ids    = data.aws_subnets.default.ids
    rds_sg_id     = module.security.rds_sg_id
}

module "alb" {
  source        = "./modules/alb"
  project_name  = var.project_name

  subnet_ids    = data.aws_subnets.default.ids
  alb_sg_id     = module.security.alb_sg_id
  vpc_id        = data.aws_vpc.default.id
}

module "ecs" {
  source = "./modules/ecs"

  project_name      = var.project_name
  subnet_ids        = data.aws_subnets.default.ids
  ecs_sg_id         = module.security.ecs_sg_id
  target_group_arn  = module.alb.target_group_arn

  execution_role_arn = var.execution_role_arn
  image_uri          = var.image_uri

  db_endpoint = module.rds.db_endpoint
  db_port     = module.rds.db_port
  db_username = var.db_username
  db_password = var.db_password
}