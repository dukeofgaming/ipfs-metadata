
# # IGW to ECS - 1:N
# # resource "aws_vpc_endpoint" "ecs_network_insights_destination" {
# #   vpc_endpoint_type     = "Interface"
# #   vpc_id                = module.vpc.vpc_id

# #   service_name          = "com.amazonaws.${var.aws_region}.ecs"
# #   security_group_ids    = [aws_security_group.ecs.id]
# #   subnet_ids            = module.vpc.private_subnets

# # }

# data "aws_ami" "amazon_arm64" {
#   most_recent = true
#   owners      = ["amazon"]

#   filter {
#     name   = "architecture"
#     values = ["arm64"]
#   }

#   filter {
#     name   = "name"
#     values = ["al2023-ami-2023*"]
#   }
# }

# resource "aws_instance" "ecs_network_insights_destinations" {
#   count = length(module.vpc.private_subnets)

#   ami           = data.aws_ami.amazon_arm64.id
#   instance_type = "t4g.nano"
#   subnet_id     = module.vpc.private_subnets[count.index]
# }

# resource "aws_ec2_network_insights_path" "igw_to_ecs_subnets" {
#   count = length(aws_instance.ecs_network_insights_destinations)

#   source = module.vpc.igw_id

#   protocol = "tcp"
#   #   destination = aws_vpc_endpoint.ecs_network_insights_destination.id
#   destination      = aws_instance.ecs_network_insights_destinations[count.index].id
#   destination_port = var.container_port

#   tags = {
#     "Service"         = "Network Insights"
#     "Name"            = "IGW to ECS"
#     "NetworkInsights" = "ECS"
#   }
# }

# resource "aws_ec2_network_insights_analysis" "igw_to_ecs_subnets" {
#   count = length(aws_ec2_network_insights_path.igw_to_ecs_subnets)


#   network_insights_path_id = aws_ec2_network_insights_path.igw_to_ecs_subnets[count.index].id

#   tags = {
#     "Service"         = "Network Insights"
#     "Name"            = "IGW to ECS)"
#     "NetworkInsights" = "ECS"
#   }

#   depends_on = [
#     aws_ecs_task_definition.this
#   ]
# }

# # ECS to RDS
# # resource "aws_ec2_network_insights_path" "ecs_to_rds_subnets" {
# #   count = length(module.vpc.private_subnets)

# #   source = module.vpc.private_subnets[count.index]

# #   protocol = "TCP"
# #   destination = aws_db_instance.database.address
# #   destination_port = var.database_port

# #   tags = {
# #     "Service"         = "Network Insights"
# #     "Name"            = "ECS to RDS (Subnet-${count.index})"
# #     "NetworkInsights" = "RDS"
# #   }
# # }

