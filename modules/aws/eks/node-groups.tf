# Allow EC2 service to assume this role
resource "aws_iam_role" "nodes_general" {
  name = "${var.eks_name}-node-group-general"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "amazon_eks_worker_policy_general" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"

  # the role the policy should be applied to.
  role = aws_iam_role.nodes_general.name
}

resource "aws_iam_role_policy_attachment" "amazon_eks_cni_policy_general" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"

  # the role the policy should be applied to.
  role = aws_iam_role.nodes_general.name
}

resource "aws_iam_role_policy_attachment" "amazon_ec2_container_registry_read_only" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"

  # the role the policy should be applied to.
  role = aws_iam_role.nodes_general.name
}

resource "aws_iam_role_policy_attachment" "cloudwatch_agent_server_policy" {
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"

  # the role the policy should be applied to.
  role = aws_iam_role.nodes_general.name
}


data "aws_ssm_parameter" "eks_ami_release_version" {
  name = "/aws/service/eks/optimized-ami/${aws_eks_cluster.eks.version}/amazon-linux-2/recommended/release_version"
}


resource "aws_eks_node_group" "nodes_general" {
  cluster_name    = aws_eks_cluster.eks.name
  node_group_name = "nodes-general"
  version         = var.eks_version

  # IAM role that provides permissions for the EKS node group
  node_role_arn = aws_iam_role.nodes_general.arn

  ## only private subnets
  subnet_ids = var.private_subnet_ids

  scaling_config {
    desired_size = 3
    max_size     = 10
    min_size     = 1
  }

  ami_type        = "AL2_x86_64"
  release_version = nonsensitive(data.aws_ssm_parameter.eks_ami_release_version.value)

  capacity_type = "ON_DEMAND" # ON_DEMAND or SPOT
  disk_size     = 10     # 10GiB

  # Force version update if existing pods are unable to be
  # drained due to a Pod distruption budget
  force_update_version = false

  # https://instances.vantage.sh/?filter=t3.
  instance_types = ["t3.medium"]

  update_config {
    max_unavailable = 1
  }

  labels = {
    role = "nodes-general"
  }

  depends_on = [
    aws_iam_role_policy_attachment.amazon_eks_worker_policy_general,
    aws_iam_role_policy_attachment.amazon_eks_cni_policy_general,
    aws_iam_role_policy_attachment.amazon_ec2_container_registry_read_only,
    aws_iam_role_policy_attachment.cloudwatch_agent_server_policy,
  ]

  lifecycle {
    ignore_changes = [scaling_config[0].desired_size]
  }
}