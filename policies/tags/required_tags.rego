package terraform.security

required_tags := {
  "ManagedBy",
  "Environment",
  "Project"
}

deny contains msg if {
  resource := input.resource_changes[_]

  tags := resource.change.after.tags

  required_tag := required_tags[_]

  not tags[required_tag]

  msg := sprintf(
    "Resource '%s' missing required tag '%s'",
    [resource.name, required_tag]
  )
}