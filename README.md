# Introduction
A terraform module to create a managed Kubernetes cluster on AWS EKS.
This is include 2 sub modules [eks](https://github.com/messi655/terraform-eks-vpc-aws/tree/master/modules/services/eks) and [vpc](https://github.com/messi655/terraform-eks-vpc-aws/tree/master/modules/services/vpc)

I refer and reuse the source code from the terraform repo [vpc](https://github.com/terraform-aws-modules/terraform-aws-vpc) and [eks](https://github.com/terraform-aws-modules/terraform-aws-eks) to create this repo.



## How to run

### Usage

#### Create EKS or VPC
- [VPC](https://github.com/messi655/terraform-eks-vpc-aws/tree/master/testing/vpc)
- [Full flow to create EKS cluster](https://github.com/messi655/terraform-eks-vpc-aws/tree/master/testing/eks-associate-with-vpc)
- [Create EKS Cluster on existed VPC](https://github.com/messi655/terraform-eks-vpc-aws/tree/master/testing/eks-with-existed-vpc)

#### Deploy server on EKS cluster

##### Exposing your application on EKS use AWS ELB

- Deploy
```
$ kubectl apply -f use_aws_elb/helloworld_dep.yaml
$ kubectl apply -f use_aws_elb/helloworld_dep.yaml
```

- Check your application
```
$ kubectl get pods
$ kubectl get svc
```

 - Open your browse and enter `EXTERNAL-IP` of output of `svc`
 

##### Exposing your application on EKS use AWS ELB with Nginx Ingress Controller

- Deploy [Nginx Ingress Controller](https://kubernetes.github.io/ingress-nginx/deploy/#aws)
```
$ kubectl apply -f nginx-ingress-controller/mandatory.yaml
$ kubectl apply -f nginx-ingress-controller/service-l4.yaml
$ kubectl apply -f nginx-ingress-controller/patch-configmap-l4.yaml
```

- Check Nginx Ingress Controller
```
$ kubectl get pods -n ingress-nginx
$ kubectl get svc -n ingress-nginx
```

- Deploy service
```
$ kubectl apply -f use_nginx_ingress_over_aws_elb/nginx_ingress_helloworld_dep.yaml
$ kubectl apply -f use_nginx_ingress_over_aws_elb/nginx_ingress_helloworld_svc.yaml
$ kubectl apply -f use_nginx_ingress_over_aws_elb/nginx_ingress_helloworld_ingress.yaml
```

- Check your application 
```
$ kubectl get pods
$ kubectl get svc
$ kubectl get ing
```

- Open your browse and enter `HOSTS` of output of `ing`