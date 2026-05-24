output "selected_region" {
  value = var.aws_region
}

output "instance_public_ip" {
  value = module.compute.instance_public_ip
}

output "instance_id" {
  value = module.compute.instance_id
}