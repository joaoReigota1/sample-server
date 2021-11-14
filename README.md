# Sample Server

This Repository is helper for KICS execution presentations.

For simplicity, the server will have only one method:

- `/` - should send 200 response with a `Hello World`

This simple server uses port: `4000`

## Features

 - Custom Query
 - Terraform example deployment
 - Golang simple server

 Terraform Resources:

 - aws_security_group
 - aws_launch_configuration
- aws_autoscaling_group
- aws_elb


## KICS commands

Please make sure you have KICS installed:

https://docs.kics.io/latest/getting-started/#installation

### Excute Scan

To execute KICS against the terraform files run the following command

```bash
kics scan -p deployment -t terraform -v -o results --report-formats all
```

### Execute Scan Custom Query

To execute KICS against terraform using the custom query run the following command

```bash
kics scan -p deployment -q custom -t terraform -v -o results --report-formats all
```

## Deploy Simple Server

**NOTE**: These next steps require an AWS profile
See https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-profiles.html for more information, And an S3 Bucket for elb access logs


To deploy the server in AWS Cloud Provider run the following commands

```
#!bin/bash
cd deployment
terraform init
terraform plan -out=plan-sample.tfplan
terraform apply
terraform apply plan-sample.tfplan
```

To test if the server is up, Open your browser and place the URL returned in the apply output with the port `:4000`

## Clean up Server

To remove server from AWS Cloud Provider run the following command

```
cd deployment
terraform destroy
```

# Additional Links

https://kics.io/
https://github.com/Checkmarx/kics
https://docs.kics.io/latest/
https://www.terraform.io/
https://aws.amazon.com/