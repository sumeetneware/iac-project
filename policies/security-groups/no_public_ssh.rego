package terraform.security

deny contains msg if {
  resource := input.resource_changes[_]

  resource.type == "aws_security_group"

  ingress := resource.change.after.ingress[_]

  ingress.from_port == 22
  ingress.to_port == 22

  ingress.cidr_blocks[_] == "0.0.0.0/0"

  msg := sprintf(
    "Security Group '%s' allows public SSH access",
    [resource.name]
  )
}