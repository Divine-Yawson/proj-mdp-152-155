output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = [aws_subnet.public_1.id, aws_subnet.public_2.id]
}

output "s3_bucket_name" {
  description = "Name of the S3 bucket for KOPS state"
  value       = aws_s3_bucket.kops_state.bucket
}

output "region" {
  description = "AWS region in use"
  value       = var.aws_region
}
