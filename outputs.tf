output "alb_dns_name" {
  value       = module.web_tier.alb_dns_name
  description = "Public URL of the Application Load Balancer"
}
