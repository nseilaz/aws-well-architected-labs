aws autoscaling put-scaling-policy \
  --policy-name mem-lower-30percent-scale-out \
  --auto-scaling-group-name WebApp1 \
  --scaling-adjustment 1 \
  --adjustment-type ChangeInCapacity \
  --cooldown 120 \
  --region <YOUR_REGION_HERE>

aws cloudwatch put-metric-alarm \
  --alarm-name mem-lower-30percent-add-capacity \
  --metric-name mem_available_percent \
  --namespace WebApp1 \
  --statistic Average \
  --period 30 \
  --evaluation-periods 3 \
  --threshold 30 \
  --comparison-operator LessThanOrEqualToThreshold \
  --dimensions "Name=AutoScalingGroupName,Value=WebApp1" \
  --alarm-actions "<YOUR_POLICY_ARN_HERE>" \
  --region <YOUR_REGION_HERE>

 aws autoscaling put-scaling-policy \
  --policy-name mem-higer-45percent-scale-in \
  --auto-scaling-group-name WebApp1 \
  --scaling-adjustment -1 \
  --adjustment-type ChangeInCapacity \
  --cooldown 120 
  --region <YOUR_REGION_HERE>



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
  --alarm-actions "<YOUR_POLICY_ARN_HERE>" \
  --region <YOUR_REGION_HERE>