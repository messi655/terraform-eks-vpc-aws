# Create an EKS Cluster and associate with existing VPC


This will help you create an EKS cluster that associate with existing VPC 
 
Example:

- This will create an EKS cluster with 2 worker nodes ( with the type of instance is `t3.micro`) on the existing private subnet 
```

module "eks" {
  source       = "../../modules/services/eks"
  cluster_name = "${local.cluster_name}"
  subnets      = ["${var.private_subnets}"]

  tags = {
    Environment = "test"
    GithubRepo  = "terraform-aws-eks"
    GithubOrg   = "terraform-aws-modules"
  }

  vpc_id        = "${var.vpc_id}"
  worker_group_count = 1

  worker_groups = [
    {
      name                          = "worker-group-1"
      instance_type                 = "t3.micro"
      additional_userdata           = "echo foo bar"
      asg_desired_capacity          = 2
      additional_security_group_ids = "${aws_security_group.worker_group_mgmt_one.id}"
    },
//    {
//      name                          = "worker-group-2"
//      instance_type                 = "t2.medium"
//      additional_userdata           = "echo foo bar"
//      additional_security_group_ids = "${aws_security_group.worker_group_mgmt_two.id}"
//      asg_desired_capacity          = 1
//    },
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

see in [eks-associate-with-vpc](https://github.com/messi655/terraform-eks-vpc-aws/tree/master/testing/eks-associate-with-vpc)

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