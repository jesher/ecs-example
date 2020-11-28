![Slash Command Dispatch](https://github.com/jesher/ecs-example/workflows/Slash%20Command%20Dispatch/badge.svg?branch=master) ![build](https://github.com/jesher/ecs-example/workflows/build/badge.svg?branch=master)

# Example ECS Fargate Deploy
Example of creating an ECS infrastructure on AWS using terraform and deploying an application and API to the Cluster.

## Architecture

![Base Architecture](docs/img/architecture.svg)

## Getting started

This project is an example, therefore, its settings are predetermined to work in this model, but it does not prevent you from copying and implementing the same structure in your projects.

### 1. Github secrets

Add secrets in github reference your credentials AWS and create personal access token (PAT)[https://docs.github.com/en/free-pro-team@latest/github/authenticating-to-github/creating-a-personal-access-token]

```
AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
REPO_ACCESS_TOKEN
```
> More info in [encrypted-secret](https://docs.github.com/pt/free-pro-team@latest/actions/reference/encrypted-secrets)
### 2. Terraform
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

### 3. ChatOps

It is easy to interact with this project we created a ChatOps comment via the pull request.

  > Command | Description
  > --- | ---
  > /terrafor-plan | terraform plan command is used to create an execution plan
  > /terrafor-apply | command is used to apply the changes
  > /terrafor-destroy | command is used to destroy
  > /help | command help
  > /create-demo | Create demo project
  > /build | Deploy application and API

<br>

__Mas para funcionar vocẽ deve criar um pull request e executar alguns dos comados apresentados na tabela__

### 1. Criar demostração

> Fork this repository and follow the instructions below to see the magic happen

To create a small desmotração the project you must create a pull request and comment type the command: `/ create-demo`. This will create the environment for you if you have correctly configured the variables

A few minutes later a comment from terraform appears, after finishing the terraform application he will start building the application and API, it may take some time.

![Base Architecture](docs/img/01_github.png)

> NIn the commentary there will be two links for you to access both application and API

If you want to destroy is so run the command `\terraform-destroy`

![Base Architecture](docs/img/02_github.png)
### 2. Run separately
If you want to run separately you should follow this order

1. `\terraform-plan`
2. `\terraform-apply`

If it has been no error in creating your environment you can run the command to perform the deploy

3. `\build`

If you want to destroy what was created just run

4. `\terraform-destroy`

### 3. Update application or API only
If you wanted to accomplish some change in the application or API to validate or test you do not need to perform the creation of the environment if it is already set up, just run `\ build` it will update everything in ECS.

## Remarks

Some points bothers me even compared structure created in AWS, I am using public networks for the cluster in order to be able to download images of the ECR, the correct would be to create a NAT gateway and add private networks or [privatelink](https://aws.amazon.com/pt/blogs/compute/setting-up-aws-privatelink-for-amazon-ecs-and-amazon-ecr/) to resolve this issue

If something goes wrong contact-me and we'll fix the problems.

Cheers!!