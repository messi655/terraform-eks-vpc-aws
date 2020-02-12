# Create VPC and EKS Cluster


This will help you a full flow to create a [VPC](https://docs.aws.amazon.com/vpc/latest/userguide//VPC_Subnets.html) and then create the [EKS](https://docs.aws.amazon.com/eks/latest/userguide/what-is-eks.html) cluster associate inside this VPC. 
 
Create:
 ```
- 2 public and 2 private subnets
- 1 Internet Getway
- 1 NAT Getway associate with 2 private subnets
- EKS associated with this VPC and includes 2 nodes on the private subnet
```

Example:
- This configuration will create a VPC with CIDR = `10.0.0.0/16` and 2 public and 2 private subnets and enable NAT Gateway on Region `N.Virginia`
```

provider "aws" {
  region  = "us-east-1"
}

module "vpc" {
  source             = "../../modules/services/vpc"
  name               = "test-vpc"
  cidr               = "10.0.0.0/16"
  azs                 = ["us-east-1a", "us-east-1b"]
  private_subnets     = ["10.0.10.0/24", "10.0.20.0/24"]
  public_subnets      = ["10.0.1.0/24", "10.0.2.0/24"]
  enable_nat_gateway = true
  single_nat_gateway = true

  tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
  }

  public_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"             = "true"
  }
}

```

- This will create an EKS cluster with 2 worker nodes ( with the type of instance is t2.small) on the private subnet and assign it to the Autoscaling group and associate with above VPC.
```

module "eks" {
  source       = "../../modules/services/eks"
  cluster_name = "${local.cluster_name}"
  subnets      = ["${module.vpc.private_subnets}"]

  tags = {
    Environment = "test"
    GithubRepo  = "terraform-aws-eks"
    GithubOrg   = "terraform-aws-modules"
  }

  vpc_id             = "${module.vpc.vpc_id}"
  worker_group_count = 1

  worker_groups = [
    {
      name                          = "worker-group-1"
      instance_type                 = "t2.small"
      additional_userdata           = "echo foo bar"
      asg_desired_capacity          = 2
      additional_security_group_ids = "${aws_security_group.worker_group_mgmt_one.id}"
    },
  ]

  worker_additional_security_group_ids = ["${aws_security_group.all_worker_mgmt.id}"]
  map_roles                            = "${var.map_roles}"
  map_roles_count                      = "${var.map_roles_count}"
  map_users                            = "${var.map_users}"
  map_users_count                      = "${var.map_users_count}"
  map_accounts                         = "${var.map_accounts}"
  map_accounts_count                   = "${var.map_accounts_count}"
}
```

 
## Prepare
### Terraform versions
Terraform => 0.11.8 and <= 0.11.14

### AWS Account
- [AWS Credential for Terraform](https://www.terraform.io/docs/providers/aws/index.html), I suggest use `Shared Credentials file`
- [Amazon EKS Service IAM Role](https://docs.aws.amazon.com/eks/latest/userguide/service_IAM_role.html)
- [User Policy](https://docs.aws.amazon.com/vpc/latest/userguide/security_iam_service-with-iam.html#security_iam_service-with-iam-resource-based-policies)

### Software required
- [`kubectl`](https://kubernetes.io/docs/tasks/tools/install-kubectl/#install-kubectl) (>=1.10) 
- [`aws-iam-authenticator`](https://github.com/kubernetes-sigs/aws-iam-authenticator#4-set-up-kubectl-to-use-authentication-tokens-provided-by-aws-iam-authenticator-for-kubernetes)

## Usage

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Destroy
```bash
$ terraform destroy
```