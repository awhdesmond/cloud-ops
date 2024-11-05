# Cloud Ops

IaC repository for terraform configuration of cloud resources.

## Pre-requisites

1. Install `aws` CLI by following the instructions [here](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
2. Create an AWS account for `terraform` with `AdministratorAccess` permission

## Getting Started
```bash
aws configure --profile terraform

terraform init
terraform apply

# Configure kube context
aws eks update-kubeconfig --region eu-west-1 --name eks --profile terraform
```

See [quick start](./docs/quick-start.md) for quick start instructions.

