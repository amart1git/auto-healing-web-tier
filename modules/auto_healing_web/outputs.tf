output "alb_dns_name" {
  value = "http://${aws_lb.alb.dns_name}"
}
