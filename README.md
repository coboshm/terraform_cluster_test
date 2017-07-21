# Small Test Using Terraform

This repo contains a sample code to run a cluster of EC2 Instances in an Auto Scaling Group + ELB

## Quick start

1. `brew install terraform`.
1. Set your AWS credentials as the environment variables `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`.
1. `make orchestrate` (`make orchestrate` = `make build` + `terraform apply`)
1. Run `terraform plan`.
1. If the plan looks good, run `terraform apply`.

## Additional info

1. `cd terraform` and run `terraform plan` to check what are you gonna do in your aws
1. `terraform apply` (if there is not the binary of the api build it will fail `make orchestrate` it's better solution)

`make orchestrate` = `make build` + `terraform apply`

## Nice To Have

1. Add Deploy in the make and rollback (codedeploy aws)
1. Provisioning the EC2 Image For example to (create service in order to start using `sudo service {{ item }} start`
...
