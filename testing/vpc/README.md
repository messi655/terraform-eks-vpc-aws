# Create VPC with 2 public and 2 private subnet

This will help you create a [VPC](https://docs.aws.amazon.com/vpc/latest/userguide//VPC_Subnets.html) with:
 - 2 public and 2 private subnets
 - 1 Internet Getway
 - 1 NAT Getway associate with 2 private subnets
 
 Example
 
 - This configuration will create a VPC with CIDR = `10.0.0.0/16` and 2 public and 2 private subnets and enable NAT Gateway on Region `N.Virginia`
 ```
 provider "aws" {
   region = "us-east-1"
 }
 
 
 module "vpc" {
   source = "../../modules/services/vpc"
 
   name = "vpc"
 
   cidr = "10.0.0.0/16"
 
   azs                 = ["us-east-1a", "us-east-1b"]
   private_subnets     = ["10.0.10.0/24", "10.0.20.0/24"]
   public_subnets      = ["10.0.1.0/24", "10.0.2.0/24"]
   enable_nat_gateway   = true
   single_nat_gateway   = true
 
   tags = {
     "kubernetes.io/cluster/${local.cluster_name}" = "shared"
   }
 
   vpc_tags = {
     Name = "vpc-eks"
   }
 }
 ```

## Prepare
### Terraform versions
Terraform => 0.11.8 and <= 0.11.14

### AWS Account 
- [User Policy](https://docs.aws.amazon.com/vpc/latest/userguide/security_iam_service-with-iam.html#security_iam_service-with-iam-resource-based-policies)

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