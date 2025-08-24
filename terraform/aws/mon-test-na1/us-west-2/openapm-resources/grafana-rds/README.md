# inputs.yaml data source

## availability_zones

## shared_eks_private_subnets

Go to vpc, then subnets. Look for "shared_eks-private" and put each subnet id into the list

## vpc_security_group_ids

Go to the vpc, then Security, then subnet groups. Look for "shared_eks01-eks_worker_sg" and grab its id

## tags

List of tags to be applied to all resources

