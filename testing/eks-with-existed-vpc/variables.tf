

variable "map_accounts" {
  description = "Additional AWS account numbers to add to the aws-auth configmap."
  type        = "list"

  default = [
    "036260429817",
   // "888888888888",
  ]
}

variable "map_accounts_count" {
  description = "The count of accounts in the map_accounts list."
  type        = "string"
  default     = 1
}

variable "map_roles" {
  description = "Additional IAM roles to add to the aws-auth configmap."
  type        = "list"

  default = [
    {
      role_arn = "arn:aws:iam::036260429817:role/tinhuynh"
      username = "tinhuynh"
      group    = "system:masters"
    },
  ]
}

variable "map_roles_count" {
  description = "The count of roles in the map_roles list."
  type        = "string"
  default     = 1
}

variable "map_users" {
  description = "Additional IAM users to add to the aws-auth configmap."
  type        = "list"

  default = [
    {
      user_arn = "arn:aws:iam::036260429817:user/tinhuynh"
      username = "tinhuynh"
      group    = "system:masters"
    },
//    {
//      user_arn = "arn:aws:iam::66666666666:user/user2"
//      username = "user2"
//      group    = "system:masters"
//    },
  ]
}

variable "map_users_count" {
  description = "The count of roles in the map_users list."
  type        = "string"
  default     = 1
}

variable "private_subnets" {
  type    = "list"
  default = ["subnet-0d0864778a94d2ab5", "subnet-001a253d1f8accae1", "subnet-078b6877023440b97"]

}

variable "vpc_id" {
  type  = "string"
  default = "vpc-9763aaf2"

}
