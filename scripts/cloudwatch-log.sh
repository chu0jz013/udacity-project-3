aws iam attach-role-policy \
  --role-name eksctl-project3-udacity-nodegroup--NodeInstanceRole-h3BHJpk9gOAq \
  --policy-arn arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy --profile udacity

aws eks create-addon --addon-name amazon-cloudwatch-observability --cluster-name project3-udacity --profile udacity
