---
title: "Simulate High CPU failure to Validate the Scaling Mechanism"
date: 2020-04-24T11:16:09-04:00
chapter: false
weight: 3
pre: "<b>3. </b>"
---


**AWS Fault Injection Simulator (AWS FIS)** provides visibility throughout every stage of an experiment via the console and APIs. As an experiment is running you can observe what actions have executed. After an experiment has completed you can see details on what actions were run, if stop conditions were triggered, how metrics compared to your expected steady state, and more. To support accurate operational metrics and effective troubleshooting, you can also identify what resources and APIs are affected by a Fault Injection Simulator experiment.

In [Step.2](../2_deploy_aws_fis_stack/) we had setup a FIS stack with an experiement template to make EC2 instances running into high CPU utilization status and exhausted. This scenario is to simulate incorrect application logic, malfunctions, or external intent for denial of service. 

In [Step.1](../1_deploy_sample_application_environment/) we deployed WordPress stack with EC2 instance running in Auto-Scaling Group. The CPU-Burning experiment template will send operating system command through AWS Systems Managers to simulate nearly identical condition in real operational incident - CPU exhaustion. 


### 3.1.Run experiment on high CPU failure

### Run through AWS Console

- Find the experiment template from AWS FIS console
- Check the template "**BurnMemoryViaSSM**" and drag down the "**Actions**"
list, and click "**Start Experiment**"

![fis-start-experiment](/Operations/200_Anticipate_failure_with_fault_injection_simulator/Images/session3-fis-start-experiment.png)

- Enter the tag Key and Value to indicate the purpose for this experiment, we set the Key=Name, Value=

![fis-set-experiment-tag](/Operations/200_Anticipate_failure_with_fault_injection_simulator/Images/session3-fis-set-experiment-tag.png)

- Input ***Start*** and click the botton


### Run through AWSCLI

- We use awscli to find the experiment template id for running
```
aws fis list-experiment-templates --region <REGION>
```
- Then we will the terminal output as follow:
![fis-cli-list-experiment-templates](/Operations/200_Anticipate_failure_with_fault_injection_simulator/Images/session3-fis-cli-list-experiment-templates.png)

- Use the ***"id"*** with following command, also with correct ***REGION*** input.
```
aws fis start-experiment --experiment-template-id <TEMPLATE_ID> --region <REGION>
```
- Then we can see the FIS experiment is initiating from the terminal output:
![fis-cli-start-experiment-burn-cpu](/Operations/200_Anticipate_failure_with_fault_injection_simulator/Images/session3-fis-cli-start-experiment-burn-cpu.png)

### 3.2 Validate the responding actions 

We expect Fault Injection Simulation will drive all the EC2 instance running into high CPU utilization, and start to trigger the scaling mechanism to add capacity into autoscaling group. At this moment, our operational procedure will be:

 Check the response of Auto-Scaling Group

 1. Go to AutoScaling Group on EC2 service page

 2. Find the autoscaling group "**WepApp1**" and switch to "Activity Tab"

 3. scorlliong down to "**Activity history**". Unfortunately we found that there is no scaling activity happened. 

 4. We switch to "Automatic scaling Tab" to make sure policy responding to CPU demand exist. 
![fis-cli-start-experiment-burn-cpu](/Operations/200_Anticipate_failure_with_fault_injection_simulator/Images/session3-asg-has-no-policy.png)
 And we found there was no dynamic scaling policies existed to response to any failure cases, include the high CPU condition. 

 5. Here we suspect the root cause could be missing of the scaling policy, we click the botton "Create dynamic scaling policy".
 Choose the **Policy Type** as "**Target tracking policy**"
    **Scaling policy name** as "**Target Tracking Policy**"
    **Metric type** as "**Average CPU Utilization**". 
    Input the **Target Value** as 50, and set **300** seconds warm up before including in metric. 
![asg-create-dynamic-target-tracking-policy](/Operations/200_Anticipate_failure_with_fault_injection_simulator/Images/session3-asg-create-dynamic-target-tracking-policy.png)

 8. Click the **Create** to create a scaling policy which reacting to future CPU exhaustion.

### 3.3 We launch a new experiment with same template and verify again.

 1. **Validate the simulation action taken from external**
 * Since the FIS experiment is launch a Systems Managers Run Command toward the target instance, we check the Run Command History page in AWS Systems Managers.
 * And we can see there is Success record for our CPU stress process. 
 ![Validate the action from external](/Operations/200_Anticipate_failure_with_fault_injection_simulator/Images/session3-validate-action-external.png)
 2. **Validate the simulation action taken fom internal** 
 * Then we turn to check the CPU from instance inside
 * We can leverage the the CloudWatch metrics of Average CPU utilization Rate, which already installed from Cloudformation initialization. 
 * Go to the AutoScaling Group and find **WebApp1** and switch to **Monitoring** tab, select **EC2**, then you can see the **CPU Utilization (Percentage)** metrics.
 * As we expected, the CPU is climing up when we launched the experiment.
![Validate the action from internal](/Operations/200_Anticipate_failure_with_fault_injection_simulator/Images/session3-validate-action-internal.png)

 3. And we check the responding action on Activity History Tab on Autoscaling Group "**WebApp1**". It shows instance Scale-out with expected average CPU utilization rate. 
![asg-create-dynamic-target-tracking-policy](/Operations/200_Anticipate_failure_with_fault_injection_simulator/Images/session3-asg-history-scale-out-high-cpu.png)


Now we can said our architecture design is ready on autoscaling for High CPU utilization. 

{{< prev_next_button link_prev_url="../2_deploy_aws_fis_stack/" link_next_url="../4_anticipate_failure_with_customized_cw_metrics/" />}}
