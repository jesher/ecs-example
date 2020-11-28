![Slash Command Dispatch](https://github.com/jesher/ecs-example/workflows/Slash%20Command%20Dispatch/badge.svg?branch=master) ![build](https://github.com/jesher/ecs-example/workflows/build/badge.svg?branch=master)

# Example ECS Fargate Deploy
Example of creating an ECS infrastructure on AWS using terraform and deploying an application and API to the Cluster.

## Architecture

![Base Architecture](docs/img/architecture.svg)

## Use Guide

This project is an example, therefore, its settings are predetermined to work in this model, but it does not prevent you from copying and implementing the same structure in your projects.

### Github secrets

Add secrets in github reference your credentials AWS

```
AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
```
> More info in [encrypted-secret](https://docs.github.com/pt/free-pro-team@latest/actions/reference/encrypted-secrets)
### Terraform
You can run terraform in two ways, locally and through `github actions`, but both will need you to create a bucket for the backend of the terraform and change the file `infra/provider.tf`

 ```HCL
terraform {
  backend "s3" {
    bucket = "<YOUR_BUCKET>"
    key    = "terraform/<YOUR_BUCKET>"
    region = "<YOUR_REGION>"
  }
}
 ```

>Run from any changes made to the folder `infra/`. As you will need to update the bucket after uploading it to your repository it will run terraform

### Application and API
 (TODO): Create

