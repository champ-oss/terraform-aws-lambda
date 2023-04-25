# terraform-aws-lambda

A Terraform module for deploying AWS Lambda functions

[![.github/workflows/module.yml](https://github.com/champ-oss/terraform-aws-lambda/actions/workflows/module.yml/badge.svg?branch=main)](https://github.com/champ-oss/terraform-aws-lambda/actions/workflows/module.yml)
[![.github/workflows/lint.yml](https://github.com/champ-oss/terraform-aws-lambda/actions/workflows/lint.yml/badge.svg?branch=main)](https://github.com/champ-oss/terraform-aws-lambda/actions/workflows/lint.yml)
[![.github/workflows/sonar.yml](https://github.com/champ-oss/terraform-aws-lambda/actions/workflows/sonar.yml/badge.svg)](https://github.com/champ-oss/terraform-aws-lambda/actions/workflows/sonar.yml)

[![SonarCloud](https://sonarcloud.io/images/project_badges/sonarcloud-black.svg)](https://sonarcloud.io/summary/new_code?id=terraform-aws-lambda_champ-oss)

[![Quality Gate Status](https://sonarcloud.io/api/project_badges/measure?project=terraform-aws-lambda_champ-oss&metric=alert_status)](https://sonarcloud.io/summary/new_code?id=terraform-aws-lambda_champ-oss)
[![Vulnerabilities](https://sonarcloud.io/api/project_badges/measure?project=terraform-aws-lambda_champ-oss&metric=vulnerabilities)](https://sonarcloud.io/summary/new_code?id=terraform-aws-lambda_champ-oss)
[![Reliability Rating](https://sonarcloud.io/api/project_badges/measure?project=terraform-aws-lambda_champ-oss&metric=reliability_rating)](https://sonarcloud.io/summary/new_code?id=terraform-aws-lambda_champ-oss)

## Example Usage

See the `examples/` folder

## Features

- Optionally attach the Lambda function to an Application Load Balancer and create a Route53 DNS record
- Optionally run the Lambda inside a VPC
- Deploy the Lambda from a ZIP file or from ECR
- Optionally sync a Docker image from another repository source (ex: Docker Hub) to ECR for deployment to the Lambda
- Supports triggering the Lambda on a schedule (using CloudWatch event)
- Supports enabling a Lambda function URL
- Optionally create API Gateway to serve HTTP requests to the lambda, using JWT authentication


## Contributing
