---
title: "Anticipate Failure with Customized CloudWatch Metrics"
date: 2020-04-24T11:16:09-04:00
chapter: false
weight: 4
pre: "<b>4. </b>"
---



### 4.1 Prepare for "Low Memory Failure" experiment

From Step.3, we discovered that autoscaling policies was not configured correctly. Now we want to build up a dynamic policy to make sure the scaling mechanism create sufficient memory space on application layer.

In our cloudformation stack, we had cloudwatch agent installed in every EC2 instance. And the memory related metrics already been configured as follow. To prevent system creash, We stick with metric "**mem_available_percent**", make sure the scaling mechanism been triggere whenever available percentage dropping less than 25%.

```
  "metrics": {
    "namespace": "WebApp1",
    "metrics_collected": {
      "mem": {
        "measurement": [
          "mem_used",
          "mem_cached",
          "mem_available",
          "mem_total",
          "mem_used_percent",
          "mem_available_percent"
        ],
        "metrics_collection_interval": 1
      }
    }
    "aggregation_dimensions" : [["AutoScalingGroupName"]] 
  }
```                  


### 4.2 Create Scaling Policy and CloudWatch Alarm Trigger through awscli

 1. Fisrt we create a scaling policy in autoscaling group **WepAPP1** for scaling out. It will **add 1 instance into capacity** when the policy been triggerd. This command will create a new policy, we will need to copy the **ARN** for next step creating a CloudWatch Alarm as a target action.

```
aws autoscaling put-scaling-policy \
  --policy-name mem-lower-30percent-scale-out \
  --auto-scaling-group-name WebApp1 \
  --scaling-adjustment 1 \
  --adjustment-type ChangeInCapacity \
  --cooldown 120 \
  --region <REGION>
```

 2. We copy the Policy ARN as an alarm action, make sure the namespace point to **WebApp1**, threshold is **30** *(means 30%)*, and the comparison-operator been set as **LessThanOrEqualToThreshold**. 

```
aws cloudwatch put-metric-alarm \
  --alarm-name mem-lower-25percent-add-capacity \
  --metric-name mem_available_percent \
  --namespace WebApp1 \
  --statistic Average \
  --period 30 \
  --evaluation-periods 3 \
  --threshold 30 \
  --comparison-operator LessThanOrEqualToThreshold \
  --dimensions "Name=AutoScalingGroupName,Value=WebApp1" \
  --alarm-actions "<SCALE_OUT_POLICY_ARN>" \
  --region <REGION>
```

 3. We repeat 1. and 2., to create a scaling policy for scaling in, to remove instance capacity when average available memory percentage is higher than threshold 35%. 

```
aws autoscaling put-scaling-policy \
  --policy-name mem-higer-45percent-scale-in \
  --auto-scaling-group-name WebApp1 \
  --scaling-adjustment -1 \
  --adjustment-type ChangeInCapacity \
  --cooldown 120 \
  --region <REGION>
```

 4. Also we create the ARN from 3. and create cloudwatch alarm to trigger the action when available memory is more than 45%. Set the namespace point to **WebApp1**, threshold is **45** *(means 45%)*, and the comparison-operator been set as **GreaterThanOrEqualToThreshold**. 

```
aws cloudwatch put-metric-alarm \
  --alarm-name mem-higer-45percent-remove-capacity \
  --metric-name mem_available_percent \
  --namespace WebApp1 \
  --statistic Average \
  --period 30 \
  --evaluation-periods 3 \
  --threshold 45 \
  --comparison-operator GreaterThanOrEqualToThreshold \
  --dimensions "Name=AutoScalingGroupName,Value=WebApp1" \
  --alarm-actions "<SCALE_IN_POLICY_ARN>" \
  --region <REGION>
```


### 4.3 Run the experiment on Low Memory
 1. Same as [Step.3](../3_build_run_investigative_playbook/), we start the experiment from AWS FIS Console, the **"BurnMemoryViaSSM"** one.

 2. Or we can start with awscli.
```
aws fis start-experiment --experiment-template-id <TEMPLATE_ID> --region <REGION>
```

### 4.4 Validate the responding actions 

 1. We swtich to CloudWatch service page, find the alarm we set in 4.2.
![cloudwatch-list-memory-alarm](/Operations/200_Anticipate_failure_with_fault_injection_simulator/Images/session4-cloudwatch-memory-alarm.png)

 2. We click into the alarm "**mem-lower-25percent-add-capacity**" and you can see the average available memory is droping after FIS experiment running. 
![cloudwatch-memory-avg-drop-during-fis](/Operations/200_Anticipate_failure_with_fault_injection_simulator/Images/session4-cloudwatch-memory-avg-drop-during-fis.png)


 3. To check if autoscaling group did scale-out with expected behavior if existed instance's memory been drain. And we found the autoscaling group scale out as we expected.
![validate-memory-drain-scaling-history](/Operations/200_Anticipate_failure_with_fault_injection_simulator/Images/session4-validate-memory-drain-scaling-history.png)

 


{{< prev_next_button link_prev_url="../3_build_run_investigative_playbook/" link_next_url="../4_build_run_remediation_runbook/" />}}
