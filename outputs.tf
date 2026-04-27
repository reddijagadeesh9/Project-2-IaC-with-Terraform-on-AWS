output "launch_template_id" {
  value = module.compute.launch_template_id
}

output "autoscaling_group_name" {
  value = module.compute.autoscaling_group_name
}

output "rds_endpoint" {
  value = module.database.rds_endpoint
}
