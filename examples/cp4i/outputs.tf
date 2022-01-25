output "cp4i_url" {
  description = "Access your Cloud Pak for Integration deployment at this URL."
  value       = module.cp4i.endpoint
}

output "cp4i_user" {
  description = "Username for your Cloud Pak for Integration deployment."
  value       = module.cp4i.user
}

output "cp4i_pass" {
  description = "Password for your Cloud Pak for Integration deployment."
  value       = module.cp4i.password
}


