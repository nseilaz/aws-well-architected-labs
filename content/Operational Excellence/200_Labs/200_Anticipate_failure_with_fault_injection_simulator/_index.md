---
title: "200 - Anticipate failure with Fault Injection Simulator"
## menutitle: "Lab #2"
date: 2020-11-08T10:21:08-04:00
chapter: false
weight: 1
hidden: false
---

## Authors
* **Bob Yeh**, Well-Architected Geo Solutions Architect.

## Contributors
* **Brian Carlson**, Well-Architected Operational Excellence Pillar Lead.
* **Nicolas Seilaz**, Senior Enterprise Solutions Architect.

## Introduction

A highly available service is one that is designed to continue the operation or function while undergoing one or more component failures. In some cases, the requirement is that the service must continue to sustain normal operational load under component failure and in other cases reduced service is acceptable, for example longer processing times but not complete outage.

Testing and stressing an application through different failure scenario allows developers, engineers, architects and business service owner to have confidence how the service will operate through different failure scenario.  It also allows run and playbooks, process, procedures, monitoring and event systems, alert and communication methods to be tested.

In this lab, a 3-tier website application will be used to exercise fault injection into the application layer, the Amazon EC2 instances run in an autoscaling group. Using different scenarios, you will practice how to perform a failure simulation and incident response.
Using the High CPU Utilization failure experiment from AWS Fault Injection Simulator against the web servers, the web application is not able to service external requests and this results in the service being unavailable.

In the architecture an autoscaling group which is an AWS capability that can automatically add additional Amazon EC2 instances which are configured as web servers, the result is more web servers which should provide additional web request capacity to service requests.  By doing this, the expected outcome is that the web requests continue to be serviced as expected regardless of the high CPU event that is occurring.  Once the high CPU is resolved then the autoscaling group will reduce the number of Amazon EC2 instances either back to the baseline while still serving request at the desired performance expectation of the service.

In the lab when testing the above scenario, you will observe that the autoscaling event does not occur as expected, this indicates that you have an issue and that under this type of condition the web application would fail to provide the expected service.   To diagnose what has occurred, you will first validate the fault simulation has taken place, then using the observation from the simulation you will check the responding mechanism are correctly configured.

## Services 
* [AWS Fault Injection Simulator](https://docs.aws.amazon.com/fis/latest/userguide/what-is.html)
* [Systems Manager](https://docs.aws.amazon.com/systems-manager/latest/userguide/systems-manager-automation.html)
* [Amazon CloudWatch](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/WhatIsCloudWatch.html)

## Goals: 

* Anticipate failure - identify potential sources of failure
* Use Fault Injection Simulator to organize the predefined failure and experiment
* Simulate the unexpected incident and response for the incident
* Define and validate workload metrics in relation to application health

## Prerequisites:

* An [AWS account](https://portal.aws.amazon.com/gp/aws/developer/registration/index.html) that you are able to use for testing. The account should not be used for production purposes.  
* An [IAM user](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_users.html) in your AWS account with full access to [CloudFormation,](https://aws.amazon.com/cloudformation/) [Amazon EC2,](https://aws.amazon.com/ec2/)[Amazon RDS,](https://aws.amazon.com/rds/)[Amazon Virtual Private Cloud (VPC),](https://aws.amazon.com/vpc/) [AWS Identity and Access Management (IAM)](https://aws.amazon.com/iam/).  

## Costs

{{% notice note %}}
NOTE: You will be billed for any applicable AWS resources used if you complete this lab that are not covered in the [AWS Free Tier](https://aws.amazon.com/free/).
{{% /notice %}}

## Steps:

{{% children  %}}


{{< prev_next_button link_next_url="./1_deploy_base_application_environment/" button_next_text="Start Lab" first_step="true" />}}

Steps:
{{% children  /%}}
