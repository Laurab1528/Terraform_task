output "vpc_id" {
  description = "ID of the created VPC"
  value       = module.vpc.vpc_id
}

output "ec2_instance_ids" {
  description = "IDs of the EC2 instances"
  value       = aws_instance.ec2_instance[*].id
}

output "elb_dns_name" {
  description = "DNS name of the Load Balancer"
  value       = aws_elb.elb.dns_name
} 