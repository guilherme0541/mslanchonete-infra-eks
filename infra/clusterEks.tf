module "eks_cluster" {
  source = "terraform-aws-modules/eks/aws"

  cluster_name                             = "${var.project_name}-cluster"
  cluster_version                          = "1.30"
  cluster_endpoint_private_access          = true
  cluster_endpoint_public_access           = true
  enable_cluster_creator_admin_permissions = true

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  eks_managed_node_groups = {
    one = {
      name                   = "node-group-1"
      min_size               = 1
      max_size               = 3
      desired_size           = 1
      vpc_security_group_ids = [aws_security_group.ssh_cluster.id]
      instance_types         = ["t2.micro"]
    }

    two = {
      name                   = "node-group-2"
      min_size               = 1
      max_size               = 3
      desired_size           = 1
      vpc_security_group_ids = [aws_security_group.ssh_cluster.id]
      instance_types         = ["t2.micro"]
    }
  }

}