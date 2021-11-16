---
title: "Deploy AWS Fault Injection Simulator Stack"
date: 2020-04-24T11:16:09-04:00
chapter: false
weight: 2
pre: "<b>2. </b>"
---

Understanding the health of your workload is an essential component of Operational Excellence. By performing “pre-mortem” exercises to identify potential sources of failure so that they can be removed or mitigated. 

AWS Fault Injection Simulator is a fully managed service for running fault injection experiments on AWS that makes it easier to improve an application’s performance, observability, and resiliency. In this section of the lab, you will deploy the AWS Fault Injection Simulator for following steps, include experiment templates with preset resource target. 

### 2.1 Setup FIS Stack

1. the version of the CloudFormation template and download to your computer, or by cloning this repository: [200-fis-experiment-templates.yaml](/Operations/200_Anticipate_failure_with_fault_injection_simulator/Code/200-fis-experiment-templates.yaml) to create a AWS FIS stack, include 2 experiment templates.

2. Sign in to the AWS Management Console, select your preferred region, and open the CloudFormation console at https://console.aws.amazon.com/cloudformation/ . Note if your CloudFormation console does not look the same, you can enable the redesigned console by clicking New Console in the CloudFormation menu.

3. Click Create Stack, then With new resources (standard). And we setup the stack name with **WebApp1-FIS**

4. After stack status change to CREATE_COMPLETE, you can find the Experiment Tempates from *Resources Tab*
![cloudformation-fist-stack-resource-output](/Operations/200_Anticipate_failure_with_fault_injection_simulator/Images/session2-cloudformation-fis-stack-resource-output.png)

5. Then we switch service to AWS Fault Injection Simulator, 
from the left hand side we click the "Experiment templates" we can find thep predefined failure simulation experiment templates already been created. 
![aws-fault-injection-simulator-experiment-templates](/Operations/200_Anticipate_failure_with_fault_injection_simulator/Images/session2-aws-fis-experiment-templates.png)

6. We can click the link of experiment template and check the detail of each experiement. We take the "BurnCPUViaSSM" as an example, we can see this template had assigned an action through Amazon Systems Managers (SSM) to run CPU Stress command toward instances targets.
![aws-fault-injection-simulator-experiment-templates-actions](/Operations/200_Anticipate_failure_with_fault_injection_simulator/Images/session2-aws-fis-experiment-templates-actions.png)

7. We can also switch to *Targets Tab* and see the target filter for this template. The targets indicating to those EC2 instnaces with resource tag "**Name**" has "**WebApp1**" assigned. 
![aws-fault-injection-simulator-experiment-templates-targets](/Operations/200_Anticipate_failure_with_fault_injection_simulator/Images/session2-aws-fis-experiment-templates-targets.png)

Now you have your Fault Injection Simulator stack ready for **Next Step**.


{{< prev_next_button link_prev_url="../1_deploy_sample_application_environment/" link_next_url="../3_build_run_investigative_playbook/" />}}

