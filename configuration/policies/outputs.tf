output "superuser" {
  description = "Root privileges for Vault administration"
  value       = "${file("${path.module}/superuser.hcl")}"
}

output "app_worker" {
  description = "IAM role for background worker app"
  value       = "${file("${path.module}/app-worker.hcl")}"
}
